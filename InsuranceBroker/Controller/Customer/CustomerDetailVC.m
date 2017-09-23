//
//  CustomerDetailVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/21.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "CustomerDetailVC.h"
#import "define.h"
#import "NetWorkHandler+queryCustomerBaseInfo.h"
#import "NetWorkHandler+queryForCustomerVisitsPageList.h"
#import "NetWorkHandler+saveOrUpdateCustomerVisits.h"
#import "NetWorkHandler+queryForCustomerInsurPageList.h"
#import "NetWorkHandler+queryForInsuredPageList.h"
#import "CustomerDetailModel.h"
#import "VisitInfoModel.h"
#import <MessageUI/MessageUI.h>
#import "NetWorkHandler+saveOrUpdateCustomerCar.h"
#import "NetWorkHandler+updateCustomerHeadImg.h"
#import "AVOSCloud/AVOSCloud.h"
#import "OnlineCustomer.h"
#import "BaseNavigationController.h"
#import "InsuredUserInfoModel.h"
#import "ProductListSelectVC.h"

@interface CustomerDetailVC ()<BaseInsuranceInfoDelegate, InsuranceInfoViewDelegate, MFMessageComposeViewControllerDelegate>
{
    NSString *_productId;
}
@property (nonatomic, strong) NSString *customerId;

@end

@implementation CustomerDetailVC
{
    UIButton * leftBarButtonItemButton;
    UIButton * rightBarButtonItemButton;
}
@synthesize scrollview;


- (void) setCustomerinfoModel:(CustomerInfoModel *)model
{
    _customerinfoModel = model;
    self.data = _customerinfoModel.detailModel;
}

- (void) dealloc
{
    AppContext *context = [AppContext sharedAppContext];
    [context removeObserver:self forKeyPath:@"isBDKFHasMsg"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AppContext *con= [AppContext sharedAppContext];
    
    if(con.isBDKFHasMsg){
        [self showBadgeWithFlag:YES];
    }
    else{
        [self showBadgeWithFlag:NO];
    }
}

- (void) reloadCustomerDetail:(NSNotification *) notify
{
    [self loadDetailWithCustomerId:self.data.customerId];
}

- (void) refreshOrderList:(NSNotification *) notify
{
    [self startRefresh];
    [self loadInsurPageList:0];
}

- (void) refreshInsuredList:(NSNotification *) notify
{
    [self loadDetailWithCustomerId:self.data.customerId];
}

- (void) loadInsuredListWithCustomerId:(NSString *) customerId
{
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    [rules addObject:[self getRulesByField:@"customerId" op:@"cn" data:customerId]];
    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    [NetWorkHandler requestToQueryForInsuredPageListOffset:0 limit:1000 filters:filters customerId:customerId Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            NSArray *array = [InsuredUserInfoModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]];
            self.data.insuredArray = [[NSMutableArray alloc] initWithArray:array];
            _insuranceDetailView.data = self.data.insuredArray;
            [_insuranceDetailView.tableviewNoCar reloadData];
            [self resetContetHeight:_selectedView];
        }
    }];
}

- (void) showBadgeWithFlag:(BOOL) flag
{
    if(flag){
        self.btnChat.imageView.badgeView.badgeValue = 1;
    }
    else
        self.btnChat.imageView.badgeView.badgeValue = 0;
}

- (void) refreshCarList:(NSNotification *) notify
{
    [_insuranceDetailView.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Do any additional setup after loading the view from its nib.
    
    AppContext *context = [AppContext sharedAppContext];
    [context addObserver:self forKeyPath:@"isBDKFHasMsg" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCarList:) name:Notify_Refresh_Car_list object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCustomerDetail:) name:Notify_Reload_CustomerDetail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList:) name:Notify_Refresh_OrderList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInsuredList:) name:Notify_Refresh_Insured_list object:nil];
    
    self.title = @"客户资料";
    
    [self.headerView.btnPhone addTarget:self action:@selector(doBtnRing:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.btnMsg addTarget:self action:@selector(doBtnEmail:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.photoImageV sd_setImageWithURL:[NSURL URLWithString:FormatImage(self.data.headImg, (int)self.headerView.photoImageV.frame.size.width, (int)self.headerView.photoImageV.frame.size.height)] placeholderImage:ThemeImage(@"user_head")];
    
    self.headerView.delegate = self;
    UIColor *normal = _COLOR(0x75, 0x75, 0x75);
    UIColor *select = _COLOR(0xff, 0x66, 0x19);
    self.headerView.pvc = self;
    
    [self.btnInfo setTitleColor:normal forState:UIControlStateNormal];
    [self.btnInfo setTitleColor:select forState:UIControlStateSelected];
    [self.btnOrderInfo setTitleColor:normal forState:UIControlStateNormal];
    [self.btnOrderInfo setTitleColor:select forState:UIControlStateSelected];
    [self.btnSituation setTitleColor:normal forState:UIControlStateNormal];
    [self.btnSituation setTitleColor:select forState:UIControlStateSelected];
    [self.btnInfo addTarget:self action:@selector(doBtnSelectDetailInfoView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnOrderInfo addTarget:self action:@selector(doBtnSelectDetailInfoView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSituation addTarget:self action:@selector(doBtnSelectDetailInfoView:) forControlEvents:UIControlEventTouchUpInside];
    self.btnInfo.tag = 101;
    self.btnOrderInfo.tag = 102;
    self.btnSituation.tag = 103;
    
    if(self.data){
        
        self.data.isLoadInsur = NO;
        self.data.isLoadVisit = NO;
        self.data.isLoadInsuredList = NO;
        
        self.headerView.lbName.text = self.data.customerName;
        if(self.data.customerName == nil || [self.data.customerName isKindOfClass:[NSNull class]] || [self.data.customerName length] == 0)
        {
            self.headerView.lbName.text = Default_Customer_Name;
        }
        self.headerView.lbMobile.text = self.data.customerPhone;
        self.headerView.lbTag.text = [self.data getCustomerLabelString];
    }
    
    
    self.headerHConstraint.constant = ScreenWidth;
    self.headerVConstraint.constant = 199 - 10;
    
    _insuranceView = [[InsuranceInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 190)];
    [self.detailView addSubview:_insuranceView];
    _insuranceView.delegate = self;
    
    
    _followUpView = [[CustomerFollowUpInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 2000)];
    [self.detailView addSubview:_followUpView];
    _followUpView.translatesAutoresizingMaskIntoConstraints = NO;
    _followUpView.delegate = self;
    
    _policyListView = [[UserPolicyListView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 2000)];
    [self.detailView addSubview:_policyListView];
    _policyListView.translatesAutoresizingMaskIntoConstraints = NO;
    _policyListView.delegate = self;
    
    _insuranceDetailView = [[InsuranceDetailView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 2000)];
    [self.detailView addSubview:_insuranceDetailView];
    _insuranceDetailView.translatesAutoresizingMaskIntoConstraints = NO;
    _insuranceDetailView.delegate = self;
    _insuranceDetailView.pVc = self;
    
    NSDictionary *views = NSDictionaryOfVariableBindings( _followUpView, _policyListView, _insuranceDetailView);
    [self.detailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_followUpView]-0-|" options:0 metrics:nil views:views]];
    [self.detailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_followUpView]-0-|" options:0 metrics:nil views:views]];
    [self.detailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_policyListView]-0-|" options:0 metrics:nil views:views]];
    [self.detailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_policyListView]-0-|" options:0 metrics:nil views:views]];
    [self.detailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_insuranceDetailView]-0-|" options:0 metrics:nil views:views]];
    [self.detailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_insuranceDetailView]-0-|" options:0 metrics:nil views:views]];
 
    
    [self doBtnSelectDetailInfoView:self.btnInfo];
    // 加载客服
    
    self.btnChat = [[HighNightBgButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.btnChat setImage:ThemeImage(@"chat") forState:UIControlStateNormal];
    [self.btnChat addTarget:self action:@selector(handleRightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightBarButtonWithButton:self.btnChat];
    self.btnChat.clipsToBounds = NO;
    self.btnChat.imageView.clipsToBounds = NO;
//    [self setRightBarButtonWithImage:ThemeImage(@"chat")];
    
    [self observeValueForKeyPath:@"isBDKFHasMsg" ofObject:nil change:nil context:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.headerView.lbName.text = self.data.customerName;
    if(self.data.customerName == nil || [self.data.customerName isKindOfClass:[NSNull class]] || [self.data.customerName length] == 0)
    {
        self.headerView.lbName.text = Default_Customer_Name;
    }
    self.headerView.lbMobile.text = self.data.customerPhone;
    self.headerView.lbTag.text = [self.data getCustomerLabelString];
    [self setCarInfo];
    [self resetContetHeight:_selectedView];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void) kefuNavigationBar{
    // 左边按钮
    leftBarButtonItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftBarButtonItemButton setImage:[UIImage imageNamed:@"arrow_left"]
                              forState:UIControlStateNormal];
    [leftBarButtonItemButton addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 右边按钮
    rightBarButtonItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [rightBarButtonItemButton setImage:[UIImage imageNamed:@"garbage"] forState:UIControlStateNormal];
}

- (void) handleRightBarButtonClicked:(id)sender
{
    self.btnChat.imageView.badgeView.badgeValue = 0;
    NSString * msex =@"男";
    UIImage *placeholderImage = ThemeImage(@"head_male");
    if([UserInfoModel shareUserInfoModel].sex==2){
         msex =@"女";
         placeholderImage = ThemeImage(@"head_famale");
    }
    if([UserInfoModel shareUserInfoModel].headerImg!=nil){
        placeholderImage =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[UserInfoModel shareUserInfoModel].headerImg]]];
    }
    
    [self kefuNavigationBar];
    [OnlineCustomer sharedInstance].navTitle=bjTitle;
    [OnlineCustomer sharedInstance].groupName=bjkf;
    [ProgressHUD show:@"连接客服..."];
    [[OnlineCustomer sharedInstance] userInfoInit:[UserInfoModel shareUserInfoModel].realName sex:msex Province:[UserInfoModel shareUserInfoModel].liveProvince City:[UserInfoModel shareUserInfoModel].liveCity phone:[UserInfoModel shareUserInfoModel].phone headImage:placeholderImage nav:self.navigationController leftBtn:leftBarButtonItemButton rightBtn:rightBarButtonItemButton];
}

- (void) doBtnClicked:(id) sender
{
    AppContext *con= [AppContext sharedAppContext];
    con.isBDKFHasMsg = NO;
    [con saveData];
}

//拨打电话
- (IBAction) doBtnRing:(UIButton *)sender
{
    if(![Util isMobilePhoeNumber:self.data.customerPhone] && ![Util checkPhoneNumInput:self.data.customerPhone]){
        [Util showAlertMessage:@"没有设置客户电话或电话格式不正确"];
        return;
    }
    
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",self.data.customerPhone]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:num];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];

}

- (IBAction) doBtnEmail:(UIButton *)sender
{
    if(![Util isMobilePhoeNumber:self.data.customerPhone] ){
        [Util showAlertMessage:@"没有设置客户手机或手机号码格式不正确"];
        return;
    }
    NSArray *array = [NSArray arrayWithObject:self.data.customerPhone];
    [self showMessageView:array title:@"" body:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    scrollview.contentSize = CGSizeMake(ScreenWidth, self.viewVConstraint.constant);
}



//获取详情
- (void) loadDetailWithCustomerId:(NSString *)customerId
{
    self.customerId = customerId;
    
    [NetWorkHandler requestToQueryCustomerBaseInfo:customerId carInfo:@"1" Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            self.data = (CustomerDetailModel*)[CustomerDetailModel modelFromDictionary:[content objectForKey:@"data"]];
            self.headerView.lbName.text = self.data.customerName;
            if(self.data.customerName == nil || [self.data.customerName isKindOfClass:[NSNull class]] || [self.data.customerName length] == 0)
            {
                self.headerView.lbName.text = Default_Customer_Name;
            }
            self.headerView.lbMobile.text = self.data.customerPhone;
            self.headerView.lbTag.text = [self.data getCustomerLabelString];
            [self.headerView.photoImageV sd_setImageWithURL:[NSURL URLWithString:self.data.headImg] placeholderImage:ThemeImage(@"user_head")];
            [self setCarInfo];
            if([_selectedView isKindOfClass:[InsuranceDetailView class]])
                [self doBtnSelectDetailInfoView:self.btnInfo];
            if(self.customerinfoModel){
                self.customerinfoModel.detailModel = self.data;
                self.customerinfoModel.customerName = self.data.customerName;
            }else{
                CustomerInfoModel *model = [[CustomerInfoModel alloc] init];
                model.detailModel = self.data;
                model.customerName = self.data.customerName;
                model.customerId = self.data.customerId;
                model.isAgentCreate = 1;
                model.headImg = self.data.headImg;
                self.customerinfoModel = model;
            }
            
            [self loadVisitList:0];
            [self startRefresh];
            [self loadInsurPageList:0];
            [self loadInsuredListWithCustomerId:self.customerId];
            
        }
    }];
}

//获取客户跟进信息
- (void) loadVisitList:(NSInteger) offset
{
//    NSInteger offset = [self.data.visitAttay count];
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    [rules addObject:[self getRulesByField:@"userId" op:@"eq" data:user.userId]];
    [rules addObject:[self getRulesByField:@"customerId" op:@"eq" data:self.customerId]];
    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    
    self.data.isLoadVisit = YES;
    
    [NetWorkHandler requestToQueryForCustomerVisitsPageList:offset
                                                      limit:LIMIT
                                                       sord:@"desc"
                                                    filters:filters
                                                 Completion:^(int code, id content) {
                                                     [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
                                                     if(code == 200){
                                                         NSArray *array = [[content objectForKey:@"data"] objectForKey:@"rows"];
                                                         [self.data.visitAttay addObjectsFromArray:[VisitInfoModel modelArrayFromArray:array]];
                                                         self.data.visitTotal = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
                                                         
                                                         _followUpView.data = self.data.visitAttay;
                                                         [_followUpView.tableview reloadData];
                                                         if([_selectedView isKindOfClass:[CustomerFollowUpInfoView class]])
                                                         {
                                                             [self doBtnSelectDetailInfoView:self.btnSituation];
                                                         }
                                                         [_followUpView endLoadMore];
                                                         
                                                         if(self.data.visitTotal == [self.data.visitAttay count]){
                                                             _followUpView.footer.hidden = YES;
                                                         }else{
                                                             _followUpView.footer.hidden = NO;
                                                         }
                                                     }
                                                 }];
}

//获取保单信息列表
- (void) loadInsurPageList:(NSInteger) offset
{
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    [rules addObject:[self getRulesByField:@"customerId" op:@"eq" data:self.customerId]];
    [rules addObject:[self getRulesByField:@"userId" op:@"eq" data:user.userId]];
    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    
    self.data.isLoadInsur = YES;
    
    [NetWorkHandler requestToQueryForCustomerInsurPageList:nil
                                                    offset:offset
                                                     limit:LIMIT
                                                      sord:@"desc"
                                                   filters:filters
                                                gxbzStatus:nil
                                                Completion:^(int code, id content) {
        [_policyListView endAnimation];
        [_insuranceView endAnimation];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            NSArray *array = [[content objectForKey:@"data"] objectForKey:@"rows"];
            if(offset == 0){
                [self.data.insurArray removeAllObjects];
            }
            [self.data.insurArray addObjectsFromArray:[InsurInfoModel modelArrayFromArray:array]];
            self.data.insurTotal = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
            _policyListView.data = self.data.insurArray;
            [_policyListView.tableview reloadData];
            if([_selectedView isKindOfClass:[UserPolicyListView class]]){
                [self doBtnSelectDetailInfoView:self.btnOrderInfo];
            }
            [_policyListView endLoadMore];
            
            if(self.data.insurTotal == [self.data.insurArray count]){
                _policyListView.footer .hidden = YES;
            }else{
                _policyListView.footer .hidden = NO;
            }
        }
    }];
}

- (NSDictionary *) getRulesByField:(NSString *) field op:(NSString *) op data:(NSString *) data
{
    NSMutableDictionary *rule = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:rule value:field key:@"field"];
    [Util setValueForKeyWithDic:rule value:op key:@"op"];
    [Util setValueForKeyWithDic:rule value:data key:@"data"];
    
    return rule;
}

//
- (void) setCarInfo
{
    _insuranceDetailView.carInfo = self.data.carInfo;
    _insuranceDetailView.customerInfo = self.customerinfoModel;
    [_insuranceDetailView.tableview reloadData];
}

#pragma CustomDetailHeaderViewDelegate
//点击事件进入客户资料编辑页面
- (void) NotifyToEditUserInfo:(CustomDetailHeaderView*) sender
{
    if(self.data){
        CustomerInfoEditVC *vc = [IBUIFactory CreateCustomerInfoEditViewController];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        vc.data = self.data;
    }else{
        [Util showAlertMessage:@"获取客户数据中，暂时不能编辑客户"];
    }
}

//投保资料，线索进展，保单信息按钮点击事件
- (void) doBtnSelectDetailInfoView:(UIButton *)sender
{
    self.btnInfo.selected = NO;
    self.btnOrderInfo.selected = NO;
    self.btnSituation.selected = NO;
    NSInteger tag = sender.tag;
    sender.selected = YES;
    
    _policyListView.hidden = YES;
    _insuranceView.btnAdd.hidden = NO;
    [_insuranceView.btnAdd setTitle:@"立即添加" forState:UIControlStateNormal];
    _followUpView.hidden = YES;
    _insuranceDetailView.hidden = YES;
    _insuranceView.hidden = YES;
    
    CGRect frame = self.lbFocusLine.frame;
    self.scrollOffsetConstraint.constant = 0;
    
    switch (tag) {
        case 101:
        {
            [self focusLineMovieTo:CGRectMake(0, frame.origin.y, ScreenWidth /3, 3)];
            _insuranceView.lbTitle.text = @"车险信息";
            _insuranceView.lbExplain.text = @"暂无新的车险信息，请添加";
            _insuranceView.type = enumInsuranceInfoViewTypeInsurance;
            self.scrollOffsetConstraint.constant = 0;
            _insuranceView.indicatorView.hidden = YES;
            [self resetContetHeight:_insuranceDetailView];
            
            _insuranceView.hidden = YES;
            _insuranceDetailView.hidden = NO;
        }
            break;
        case 102:
        {
            [self focusLineMovieTo:CGRectMake(ScreenWidth /3, frame.origin.y, ScreenWidth /3, 3)];
            _insuranceView.lbTitle.text = @"保单信息";
            _insuranceView.lbExplain.text = @"暂无保单信息";
            [_insuranceView.btnAdd setTitle:@"刷新" forState:UIControlStateNormal];
            if(_insuranceView.indicatorView.isAnimating){
                _insuranceView.indicatorView.hidden = NO;
            }else{
                _insuranceView.indicatorView.hidden = YES;
            }
            _insuranceView.type = enumInsuranceInfoViewTypePolicy;
            if(self.data.carInfo == nil)
                _insuranceView.btnAdd.hidden = YES;
            _policyListView.hidden = NO;
            [self resetContetHeight:_policyListView];
//            if(!self.data.isLoadInsur ){
//                [self startRefresh];
//                [self loadInsurPageList:0];
//            }
        }
            break;
        case 103:
        {
            [self focusLineMovieTo:CGRectMake(ScreenWidth /3 * 2, frame.origin.y, ScreenWidth /3, 3)];
            _insuranceView.lbTitle.text = @"线索进展";
            _insuranceView.lbExplain.text = @"暂无新的线索进展，请添加";
            _insuranceView.btnAdd.hidden = NO;
            _followUpView.hidden = NO;
            _insuranceView.type = enumInsuranceInfoViewTypeFollowUp;
            [self resetContetHeight:_followUpView];
            _insuranceView.indicatorView.hidden = YES;
            
//            if(!self.data.isLoadVisit){
//                [self loadVisitList];
//            }
        }
            break;
        default:
            break;
    }
}

//黄线移动位置
- (void) focusLineMovieTo:(CGRect) rect
{
    [UIView animateWithDuration:0.25 animations:^{
        self.xfxocusxxLineOffsizeConstraint.constant = rect.origin.x;
        [self.view setNeedsLayout];
    }];
}

//重置view的高度
- (void) resetContetHeight:(BaseInsuranceInfo*) view
{
    _selectedView = view;
    
    if([view isKindOfClass:[InsuranceDetailView class]]){
        CGFloat viewheight = [view resetSubviewsFrame];
        CGFloat constant = self.headerVConstraint.constant + 65 + viewheight;
        if(![view isKindOfClass:[InsuranceDetailView class]])
            constant += 50;
        self.viewVConstraint.constant = constant;
        self.detailVConstraint.constant = viewheight;
        scrollview.contentSize = CGSizeMake(ScreenWidth, self.viewVConstraint.constant);
        [view.tableview reloadData];
        view.hidden = NO;
        _insuranceView.hidden = YES;
        _selectedView.hidden = NO;
    }else{
        NSInteger num = view.data.count;//[view tableView:view.tableview numberOfRowsInSection:0];
        if(num > 0){
            CGFloat viewheight = [view resetSubviewsFrame];
            CGFloat constant = self.headerVConstraint.constant + 65 + viewheight;
            if(![view isKindOfClass:[InsuranceDetailView class]])
                constant += 50;
            self.viewVConstraint.constant = constant;
            self.detailVConstraint.constant = viewheight;
            scrollview.contentSize = CGSizeMake(ScreenWidth, self.viewVConstraint.constant);
            [view.tableview reloadData];
            view.hidden = NO;
            _insuranceView.hidden = YES;
        }else{
            self.viewVConstraint.constant = self.headerVConstraint.constant +65 + 230;
            self.detailVConstraint.constant = 190;
            view.hidden = YES;
            _insuranceView.hidden = NO;
        }
    }
    
    [self.view setNeedsLayout];
}

#pragma BaseInsuranceInfoDelegate
//添加客户跟进信息
- (void) NotifyAddFollowUpInfo:(BaseInsuranceInfo *) sender//添加客户跟进信息
{
    if(sender == _followUpView)
        [self addFollowUp];
}
//编辑投保资料
- (void) NotifyModifyInsuranceInfo:(BaseInsuranceInfo *) sender
{
    if(sender == _insuranceDetailView)
        [self editAutoInsuranceInfo];
}

//客户跟进列表点击
- (void) NotifyHandleFollowUpClicked:(BaseInsuranceInfo *)sender idx:(NSInteger) idx
{
    if(sender == _followUpView){
        AddFollowUpVC *vc = [IBUIFactory CreateAddFollowUpViewController];
        [self.navigationController pushViewController:vc animated:YES];
        vc.visitModel = [self.data.visitAttay objectAtIndex:idx];
    }
}
//处理保单列表点击
- (void) NotifyHandlePolicyClicked:(BaseInsuranceInfo *)sender idx:(NSInteger) idx
{
    if(sender == _policyListView){
        InsurInfoModel *model = [self.data.insurArray objectAtIndex:idx];
        
        if(model.insuranceType == 1){
            NSInteger orderOfferStatus = model.orderOfferStatus;
            
            if (orderOfferStatus == 4 || orderOfferStatus == 5 || orderOfferStatus == 6 || orderOfferStatus == 7 || orderOfferStatus == 8){
                OrderDetailWebVC *web = [IBUIFactory CreateOrderDetailWebVC];
                web.insModel = model;
                web.title = @"报价详情";
                web.type = enumShareTypeShare;
                if(model.productLogo){
                    web.shareImgArray = [NSArray arrayWithObject:model.productLogo];
                }
                UserInfoModel *user = [UserInfoModel shareUserInfoModel];
                web.shareTitle = [NSString stringWithFormat:@"我是%@，我是优快保自由经纪人。这是为您定制的投保方案报价，请查阅。电话%@", user.realName, user.phone];
                [self.navigationController pushViewController:web animated:YES];
                [web initShareUrl:model.insuranceOrderUuid];
                
                NSString *url = [NSString stringWithFormat:@"%@?appId=%@&orderUuId=%@&helpInsure=1", model.clickUrl, [UserInfoModel shareUserInfoModel].uuid, model.insuranceOrderUuid];
                [web initShareUrl:model.insuranceOrderUuid];
                [web loadHtmlFromUrl:url];
            }
            else if (orderOfferStatus == 3){
                if(kShenHeBeiAn){
                    OrderDetailWebVC *web = [IBUIFactory CreateOrderDetailWebVC];
                    web.insModel = model;
                    web.title = @"报价详情";
                    [self.navigationController pushViewController:web animated:YES];
                    
                    NSString *url = [NSString stringWithFormat:@"%@?appId=%@&orderUuId=%@&helpInsure=1", model.clickUrl, [UserInfoModel shareUserInfoModel].uuid, model.insuranceOrderUuid];
                    [web initShareUrl:model.insuranceOrderUuid];
                    [web loadHtmlFromUrl:url];
                }
                else{
                    OfferDetailsVC *vc = [IBUIFactory CreateOfferDetailsViewController];
                    vc.orderId = model.insuranceOrderUuid;
                    vc.insurInfo = model;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                OrderDetailWebVC *web = [IBUIFactory CreateOrderDetailWebVC];
                web.insModel = model;
                web.title = @"报价详情";
                [self.navigationController pushViewController:web animated:YES];
                
                NSString *url = [NSString stringWithFormat:@"%@?appId=%@&orderUuId=%@&helpInsure=1", model.clickUrl, [UserInfoModel shareUserInfoModel].uuid, model.insuranceOrderUuid];
                [web initShareUrl:model.insuranceOrderUuid];
                [web loadHtmlFromUrl:url];
            }
        }else{
            OurProductDetailVC *web = [IBUIFactory CreateOurProductDetailVC];
            web.title = @"保单详情";
            [self.navigationController pushViewController:web animated:YES];
            NSString *url = [NSString stringWithFormat:@"%@?orderId=%@", model.clickUrl, model.insuranceOrderUuid];
            [web loadHtmlFromUrl:url];
        }
    
    }
    
}

//客户跟进加载更多
- (void) NotifyToLoadMoreFollowUp:(BaseInsuranceInfo *)sender
{
    if(sender == _followUpView){
        NSInteger offset = [self.data.insurArray count];
        [self loadVisitList:offset];
    }
}

//爆单信息加载更多
- (void) NotifyToLoadMorePloicy:(BaseInsuranceInfo *)sender
{
    if(sender == _policyListView){
        NSInteger offset = [self.data.insurArray count];
        [self loadInsurPageList:offset];
    }
}

//列表的删除事件，
- (void) NotifyHandleItemDelegateClicked:(BaseInsuranceInfo *)sender model:(id) model
{
    if(sender == _policyListView){
        InsurInfoModel *policy = (InsurInfoModel*) model;
        [_policyListView deleteItemWithOrderId:policy.insuranceOrderUuid Completion:^(int code, id content) {
            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
            if(code == 200){
                [self.customerinfoModel.detailModel.insurArray removeObject:model];
                self.customerinfoModel.detailModel.insurTotal --;
                if(self.customerinfoModel.detailModel.insurTotal < 0){
                    self.customerinfoModel.detailModel.insurTotal = 0;
                }
                [self resetContetHeight:_selectedView];
            }
            [_policyListView.tableview reloadData];
        }];
    }
    else if (sender == _insuranceDetailView){}
    else{
        VisitInfoModel *visit = (VisitInfoModel *) model;
        [NetWorkHandler requestToSaveOrUpdateCustomerVisits:nil userId:nil visitTime:nil visitAddr:nil visitType:nil visitTypeId:nil visitProgress:nil visitProgressId:nil visitLon:nil visitLat:nil visitStatus:-1 visitMemo:nil visitId:visit.visitId Completion:^(int code, id content) {
            [self.data.visitAttay removeObject:visit];
            self.data.visitTotal -- ;
            _followUpView.data = self.data.visitAttay;
            [_followUpView.tableview reloadData];
            
            if(self.data.visitTotal > 0 && [self.data.visitAttay count] == 0){
                [self loadVisitList:0];
            }else{
                if([_selectedView isKindOfClass:[CustomerFollowUpInfoView class]]){
                    [self doBtnSelectDetailInfoView:self.btnSituation];
                }
            }
        }];
    }
}


#pragma InsuranceInfoViewDelegate
//
- (void) NotifyAddButtonClicked:(InsuranceInfoView *) sender type:(InsuranceInfoViewType) type
{
    if(type == enumInsuranceInfoViewTypeFollowUp){
        [self addFollowUp];
    }
    else if(type == enumInsuranceInfoViewTypeInsurance){
        [self addAutoInsuranceInfo];
    }else{
        [self startRefresh];
        [self loadInsurPageList:0];
    }
    
}

//非车险报价
- (void) NotifyToPlanInsurance:(InsuredUserInfoModel *) model
{
    //先选择被保人的情况
    ProductListSelectVC *vc = [[ProductListSelectVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    InsuredInfoModel *infoModel = [InsuredInfoModel initFromInsuredUserInfoModel:model];
    infoModel.type = InsuredType1;
    [vc loadDataWithLimitVal:infoModel customerDetail:self.data];
}

//添加非车险客户资料
- (void) NotifyToAddInsuranceInfo:(BaseInsuranceInfo *) sender
{
    InsuredUserInfoEditVC *vc = [IBUIFactory CreateInsuredUserInfoEditVC];
    vc.title = @"被保人信息";
    if(self.customerinfoModel)
        vc.customerId = self.customerinfoModel.customerId;
    else
        vc.customerId = self.customerId;
    vc.customerDetail = self.data;
    [self.navigationController pushViewController:vc animated:YES];
}

//非车险列表点击
- (void) NotifyHandleInsuranceInfoClicked:(BaseInsuranceInfo *)sender idx:(NSInteger) idx
{
    EditInsuredUserInfoVC *vc = [IBUIFactory CreateEditInsuredUserInfoVC];
    vc.title = @"被保人信息";
    if(self.customerinfoModel)
        vc.customerId = self.customerinfoModel.customerId;
    else
        vc.customerId = self.customerId;
    vc.insuredModel = [self.data.insuredArray objectAtIndex:idx];
    [self.navigationController pushViewController:vc animated:YES];
}

//把服务端存储的FIELD->NULL置为本地的@“”
- (NSString *) notNullString:(NSString *) string
{
    if([string isEqualToString:@"FIELD->NULL"])
        string = @"";
    
    return string;
}

- (void) NotifyToRefreshSubviewFrames
{
    [self resetContetHeight:_selectedView];
    [self.scrollview scrollRectToVisible:CGRectMake(0, self.viewVConstraint.constant - self.scrollview.frame.size.height, ScreenWidth, self.scrollview.frame.size.height) animated:YES];
}

//刷新按钮动画
- (void) startRefresh
{
    _insuranceView.indicatorView.hidden = NO;
    [_insuranceView startAnimation];
}

//点击按钮，刷新保单列表
- (void) NotifyToRefresh:(BaseInsuranceInfo *)sender;//刷新保单列表
{
    [self startRefresh];
    [self loadInsurPageList:0];
}

//添加客户跟进
- (void) addFollowUp
{
    AddFollowUpVC *vc = [IBUIFactory CreateAddFollowUpViewController];
    [self.navigationController pushViewController:vc animated:YES];
    vc.customerId = self.customerId;
    vc.customerModel = self.customerinfoModel;
}

//编辑车险资料
- (void) editAutoInsuranceInfo
{
    [self addAutoInsuranceInfo];
}

//添加车险资料
- (void) addAutoInsuranceInfo
{
    AutoInsuranceInfoEditVC *vc = [IBUIFactory CreateAutoInsuranceInfoEditViewController];
    [self.navigationController pushViewController:vc animated:YES];
    vc.customerId = self.customerId;
    vc.customerModel = self.data;
    vc.carInfo = self.data.carInfo;
}

//上传车险资料
- (void) NotifyToSubmitImage:(UIImage *) travelCard1 travelCard2:(UIImage *)travelCard2 image1:(UIImage *) image1 cert2:(UIImage *)image2
{
    [ProgressHUD show:@"正在上传"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        NSString *filePahe1 = [self fileupMothed:travelCard1];
        NSString *filePahe2 = [self fileupMothed:travelCard2];
        NSString *filePahe3 = [self fileupMothed:image1];
        NSString *filePahe4 = [self fileupMothed:image2];
        
        NSInteger labourOfferStatus = 1;
        NSString *carTypeNo = self.data.carInfo.carTypeNo;
        NSString *carShelfNo = self.data.carInfo.carShelfNo;
        NSString *carEngineNo = self.data.carInfo.carEngineNo;
        NSString *carRegTime = [Util getDayString:self.data.carInfo.carRegTime];
        NSString *carTradeTime = @"";
        if(filePahe1){
            labourOfferStatus = 2;
            carTypeNo = [Util nullString:carTypeNo];
            carShelfNo = [Util nullString:carShelfNo];
            carEngineNo = [Util nullString:carEngineNo];
            carRegTime = [Util nullString:carRegTime];
            carTradeTime = [Util nullString:@""];
        }
        
        [NetWorkHandler requestToSaveOrUpdateCustomerCar:self.data.carInfo.customerCarId customerId:self.data.customerId carNo:nil carProvinceId:nil carCityId:nil driveProvinceId:nil driveCityId:nil carTypeNo:carTypeNo carShelfNo:carShelfNo carEngineNo:carEngineNo carOwnerName:nil carOwnerCard:nil carOwnerPhone:nil carOwnerTel:nil carOwnerAddr:nil travelCard1:filePahe1 travelCard2:filePahe2 carOwnerCard1:filePahe3 carOwnerCard2:filePahe4 carRegTime:carRegTime newCarNoStatus:nil carTradeStatus:@"1" carTradeTime:carTradeTime carInsurStatus1:nil carInsurCompId1:nil labourOfferStatus:labourOfferStatus Completion:^(int code, id content) {
            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
            dispatch_async(dispatch_get_main_queue(),^{
                if(code == 200){
                    CarInfoModel *model = self.data.carInfo;
                    if(model == nil){
                        model = [[CarInfoModel alloc] init];
                        self.data.carInfo = model;
                    }
                    model.customerCarId = [content objectForKey:@"data"];
                    model.customerId = self.data.customerId;
                    model.carOwnerName = self.data.customerName;
                    if(filePahe1 != nil)
                        model.travelCard1 = filePahe1;
                    if(filePahe2 != nil)
                        model.travelCard2 = filePahe2;
                    if(filePahe3 != nil)
                        model.carOwnerCard1 = filePahe3;
                    if(filePahe4 != nil)
                        model.carOwnerCard2 = filePahe4;
                    model.carTypeNo = [self notNullString:carTypeNo];
                    model.carShelfNo = [self notNullString:carShelfNo];
                    model.carEngineNo = [self notNullString:carEngineNo];
                    model.carRegTime = nil;
                    model.carTradeStatus = 1;
                    model.carTradeTime = nil;
                    
                    [_insuranceDetailView.tableview reloadData];
                    [ProgressHUD showSuccess:@"上传成功"];
                }else{
                    [ProgressHUD showError:@"上传失败"];
                }
            });
        }];
    });
}

-(NSString *)fileupMothed:(UIImage *) image
{
    if(image == nil)
        return nil;
    //图片
    //添加文件名
    @autoreleasepool {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        AVFile *file = [AVFile fileWithData:imageData];
        [file save];
        
        return file.url;
    }
    
    //文字内容
}

- (void) NotifyToSubmitCustomerHeadImg:(UIImage *) image
{
    [ProgressHUD show:@"正在上传"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        NSString *filePahe1 = [self fileupMothed:image];
        [NetWorkHandler requestToUpdateCustomerHeadImg:self.data.customerId headImg:filePahe1 Completion:^(int code, id content) {
            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
            //[ProgressHUD dismiss];
            if(code == 200){
                self.data.headImg = filePahe1;
                self.customerinfoModel.headImg = filePahe1;
                self.customerinfoModel.detailModel.headImg = filePahe1;
                [ProgressHUD showSuccess:@"上传成功"];
            }else{
                [ProgressHUD showError:@"上传失败"];
            }

        }];
    });

}

#pragma MFMessageComposeViewControllerDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
          [Util showAlertMessage:@"该设备不支持短信功能"];
    }
}

//车险算价
- (void) NotifyToPlanCarInsurance
{
    if([Util checkInfoFull:self.data.carInfo]){
        
        QuickQuoteVC *web = [IBUIFactory CreateQuickQuoteVC];
        web.title = @"报价";
        [self.navigationController pushViewController:web animated:YES];
        NSString *url = [NSString stringWithFormat:CAR_INSUR_PLAN, CHE_XIAN_SUAN_JIA, self.data.carInfo.customerCarId, [UserInfoModel shareUserInfoModel].uuid, @""];
        
        [web loadHtmlFromUrl:url];
    }else{

        [Util showAlertMessage:@"请输入车牌或上传行驶证！"];
        AutoInsuranceInfoEditVC *vc = [IBUIFactory CreateAutoInsuranceInfoEditViewController];
        [self.navigationController pushViewController:vc animated:YES];
        vc.customerId = self.customerId;
        vc.customerModel = self.data;
        vc.carInfo = self.data.carInfo;
    }
}

@end
