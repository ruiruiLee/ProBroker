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
#import "CustomerDetailModel.h"
#import "VisitInfoModel.h"
#import <MessageUI/MessageUI.h>
#import "OrderWebVC.h"
#import "NetWorkHandler+saveOrUpdateCustomerCar.h"
//#import "NetWorkHandler+saveOrUpdateCustomer.h"
#import "NetWorkHandler+updateCustomerHeadImg.h"
#import <AVOSCloud/AVOSCloud.h>

@interface CustomerDetailVC ()<BaseInsuranceInfoDelegate, InsuranceInfoViewDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) CustomerDetailModel *data;
@property (nonatomic, strong) NSString *customerId;

@end

@implementation CustomerDetailVC
@synthesize scrollview;
@synthesize btnQuote;

- (void) setCustomerinfoModel:(CustomerInfoModel *)model
{
    _customerinfoModel = model;
    self.data = _customerinfoModel.detailModel;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCustomerDetail:) name:Notify_Reload_CustomerDetail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList:) name:Notify_Refresh_OrderList object:nil];
    
    self.title = @"客户资料";
    
//    [self setRightBarButtonWithImage:ThemeImage(@"chat")];
    
    [self.headerView.btnPhone addTarget:self action:@selector(doBtnRing:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.btnMsg addTarget:self action:@selector(doBtnEmail:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.photoImageV sd_setImageWithURL:[NSURL URLWithString:self.data.headImg] placeholderImage:ThemeImage(@"user_head")];
    
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
        self.headerView.lbName.text = self.data.customerName;
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
    
    
    btnQuote = [[UIButton alloc] init];
    [self.view addSubview:btnQuote];
    [btnQuote setTitle:@"立即\n报价" forState:UIControlStateNormal];
    btnQuote.translatesAutoresizingMaskIntoConstraints = NO;
    btnQuote.layer.cornerRadius = 24;
    btnQuote.backgroundColor = _COLOR(0xff, 0x66, 0x19);
    btnQuote.titleLabel.font = _FONT_B(14);
    btnQuote.titleLabel.numberOfLines = 2;
    btnQuote.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnQuote.layer.shadowColor = _COLOR(0xff, 0x66, 0x19).CGColor;
    btnQuote.layer.shadowOffset = CGSizeMake(0, 0);
    btnQuote.layer.shadowOpacity = 0.5;
    btnQuote.layer.shadowRadius = 1;
    [btnQuote addTarget:self action:@selector(doBtnCarInsurPlan:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSDictionary *views1 = NSDictionaryOfVariableBindings(btnQuote);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnQuote(48)]-10-|" options:0 metrics:nil views:views1]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[btnQuote(48)]->=0-|" options:0 metrics:nil views:views1]];
    
    [self doBtnSelectDetailInfoView:self.btnInfo];
}

//
- (void) handleRightBarButtonClicked:(id)sender
{
    
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.headerView.lbName.text = self.data.customerName;
    self.headerView.lbMobile.text = self.data.customerPhone;
    self.headerView.lbTag.text = [self.data getCustomerLabelString];
    [self setCarInfo];
    
    [self resetContetHeight:_selectedView];
    
    //客服跟进和保单信息后续

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
            self.headerView.lbMobile.text = self.data.customerPhone;
            self.headerView.lbTag.text = [self.data getCustomerLabelString];
            [self.headerView.photoImageV sd_setImageWithURL:[NSURL URLWithString:self.data.headImg] placeholderImage:ThemeImage(@"user_head")];
            [self setCarInfo];
            [self doBtnSelectDetailInfoView:self.btnInfo];
            if(self.customerinfoModel){
                self.customerinfoModel.detailModel = self.data;
                self.customerinfoModel.customerName = self.data.customerName;
            }
        }else{
//            if(self .data == nil){
//                self.data = [[CustomerDetailModel alloc] init];
//                self.data.visitAttay = [[NSMutableArray alloc] init];
//                self.data.insurArray = [[NSMutableArray alloc] init];
//            }
        }
    }];
}

//获取客户跟进信息
- (void) loadVisitList
{
    NSInteger offset = [self.data.visitAttay count];
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    [rules addObject:[self getRulesByField:@"userId" op:@"eq" data:user.userId]];
    [rules addObject:[self getRulesByField:@"customerId" op:@"eq" data:self.customerId]];
    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    
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
                                                         self.data.isLoadVisit = YES;
                                                         _followUpView.data = self.data.visitAttay;
                                                         [_followUpView.tableview reloadData];
                                                         if([_selectedView isKindOfClass:[CustomerFollowUpInfoView class]])
                                                         {
                                                             [self doBtnSelectDetailInfoView:self.btnSituation];
                                                         }
                                                         [_followUpView endLoadMore];
                                                         
                                                         if(self.data.visitTotal == [self.data.visitAttay count]){
                                                             _followUpView.footer.hidden = YES;
                                                         }
                                                     }
                                                 }];
}

//获取保单信息列表
- (void) loadInsurPageList:(NSInteger) offset
{
    if(self.data.carInfo == nil){
        [_policyListView endAnimation];
        [_insuranceView endAnimation];
        return;
    }
    
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    [rules addObject:[self getRulesByField:@"insuranceType" op:@"eq" data:@"1"]];
    [rules addObject:[self getRulesByField:@"customerId" op:@"eq" data:self.customerId]];
    [rules addObject:[self getRulesByField:@"userId" op:@"eq" data:user.userId]];
    [rules addObject:[self getRulesByField:@"customerCarId" op:@"eq" data:self.data.carInfo.customerCarId]];
    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    
    [NetWorkHandler requestToQueryForCustomerInsurPageList:@"1"
                                                    offset:offset
                                                     limit:LIMIT
                                                      sord:@"desc"
                                                   filters:filters
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
            self.data.isLoadInsur = YES;
            _policyListView.data = self.data.insurArray;
            [_policyListView.tableview reloadData];
            if([_selectedView isKindOfClass:[UserPolicyListView class]]){
                [self doBtnSelectDetailInfoView:self.btnOrderInfo];
            }
            [_policyListView endLoadMore];
            
            if(self.data.insurTotal == [self.data.insurArray count]){
                _policyListView.footer .hidden = YES;
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

- (void) setCarInfo
{
    _insuranceDetailView.carInfo = self.data.carInfo;
    _insuranceDetailView.customerInfo = self.customerinfoModel;
    [_insuranceDetailView.tableview reloadData];
}

#pragma CustomDetailHeaderViewDelegate
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
    btnQuote.hidden = YES;
    
    switch (tag) {
        case 101:
        {
            [self focusLineMovieTo:CGRectMake(0, frame.origin.y, ScreenWidth /3, 3)];
            _insuranceView.lbTitle.text = @"车险信息";
            _insuranceView.lbExplain.text = @"暂无新的车险信息，请添加";
            _insuranceView.btnAdd.hidden = NO;
            _insuranceDetailView.hidden = NO;
            _insuranceView.type = enumInsuranceInfoViewTypeInsurance;
            self.scrollOffsetConstraint.constant = 0;
            [self resetContetHeight:_insuranceDetailView];
            btnQuote.hidden = NO;
            _insuranceView.indicatorView.hidden = YES;
        }
            break;
        case 102:
        {
            [self focusLineMovieTo:CGRectMake(ScreenWidth /3 * 2, frame.origin.y, ScreenWidth /3, 3)];
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
            if(!self.data.isLoadInsur ){
                [self startRefresh];
                [self loadInsurPageList:0];
            }
        }
            break;
        case 103:
        {
            [self focusLineMovieTo:CGRectMake(ScreenWidth /3, frame.origin.y, ScreenWidth /3, 3)];
            _insuranceView.lbTitle.text = @"跟进信息";
            _insuranceView.lbExplain.text = @"暂无新的跟进信息，请添加";
            _insuranceView.btnAdd.hidden = NO;
            _followUpView.hidden = NO;
            _insuranceView.type = enumInsuranceInfoViewTypeFollowUp;
            [self resetContetHeight:_followUpView];
            _insuranceView.indicatorView.hidden = YES;
            
            if(!self.data.isLoadVisit){
                [self loadVisitList];
            }
        }
            break;
        default:
            break;
    }
}

- (void) focusLineMovieTo:(CGRect) rect
{
    [UIView animateWithDuration:0.25 animations:^{
//        self.lbFocusLine.frame = rect;
        self.xfxocusxxLineOffsizeConstraint.constant = rect.origin.x;
        [self.view setNeedsLayout];
    }];
}

- (void) resetContetHeight:(BaseInsuranceInfo*) view
{
    _selectedView = view;
    NSInteger num = [view tableView:view.tableview numberOfRowsInSection:0];
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
    
    [self.view setNeedsLayout];
}

#pragma BaseInsuranceInfoDelegate
- (void) NotifyAddFollowUpInfo:(BaseInsuranceInfo *) sender//添加客户跟进信息
{
    if(sender == _followUpView)
        [self addFollowUp];
}

- (void) NotifyModifyInsuranceInfo:(BaseInsuranceInfo *) sender//编辑投保资料
{
    if(sender == _insuranceDetailView)
        [self editAutoInsuranceInfo];
}

- (void) NotifyHandleFollowUpClicked:(BaseInsuranceInfo *)sender idx:(NSInteger) idx
{
    if(sender == _followUpView){
        AddFollowUpVC *vc = [IBUIFactory CreateAddFollowUpViewController];
        [self.navigationController pushViewController:vc animated:YES];
        vc.visitModel = [self.data.visitAttay objectAtIndex:idx];
    }
}

- (void) NotifyHandlePolicyClicked:(BaseInsuranceInfo *)sender idx:(NSInteger) idx//处理保单列表点击
{
    if(sender == _policyListView){
        InsurInfoModel *model = [self.data.insurArray objectAtIndex:idx];
        NSInteger orderOfferStatus = model.orderOfferStatus;
        
        if(orderOfferStatus == 1 || orderOfferStatus == 2 || orderOfferStatus == 9){
            WebViewController *web = [IBUIFactory CreateWebViewController];
            web.title = @"报价详情";
            [self.navigationController pushViewController:web animated:YES];
            NSString *url = [NSString stringWithFormat:@"%@/car_insur/car_insur_detail.html?insuranceType=%@&orderId=%@", Base_Uri, @"1", model.insuranceOrderUuid];
            [web loadHtmlFromUrl:url];
        }
        else if (orderOfferStatus == 4 || orderOfferStatus == 5 || orderOfferStatus == 6 || orderOfferStatus == 7 || orderOfferStatus == 8){
            OrderDetailWebVC *web = [IBUIFactory CreateOrderDetailWebVC];
            web.title = @"报价详情";
            web.type = enumShareTypeShare;
            if(model.productLogo){
                web.shareImgArray = [NSArray arrayWithObject:model.productLogo];
            }
            UserInfoModel *user = [UserInfoModel shareUserInfoModel];
            web.shareTitle = [NSString stringWithFormat:@"我是%@，我是优快保自由经纪人。这是为您定制的投保方案报价，请查阅。电话%@", user.realName, user.phone];
            [self.navigationController pushViewController:web animated:YES];
            [web initShareUrl:model.insuranceOrderUuid insuranceType:@"1" planOfferId:model.planOfferId];
            if(model.planOfferId){
                NSString *url = [NSString stringWithFormat:@"%@/car_insur/car_insur_detail.html?insuranceType=%@&orderId=%@&planOfferId=%@", Base_Uri, @"1", model.insuranceOrderUuid, model.planOfferId];
                [web loadHtmlFromUrl:url];
            }else
            {
                NSString *url = [NSString stringWithFormat:@"%@/car_insur/car_insur_detail.html?insuranceType=%@&orderId=%@", Base_Uri, @"1", model.insuranceOrderUuid];
                [web loadHtmlFromUrl:url];
            }
        }
        else if (orderOfferStatus == 3){
            OfferDetailsVC *vc = [IBUIFactory CreateOfferDetailsViewController];
            vc.orderId = model.insuranceOrderUuid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void) NotifyToLoadMoreFollowUp:(BaseInsuranceInfo *)sender
{
    if(sender == _followUpView){
        [self loadVisitList];
    }
}

- (void) NotifyToLoadMorePloicy:(BaseInsuranceInfo *)sender
{
    if(sender == _policyListView){
        NSInteger offset = [self.data.insurArray count];
        [self loadInsurPageList:offset];
        
    }
}

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
                [_policyListView.tableview reloadData];
            }
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
                [self loadVisitList];
            }else{
                if([_selectedView isKindOfClass:[CustomerFollowUpInfoView class]]){
                    [self doBtnSelectDetailInfoView:self.btnSituation];
                }
            }
        }];
    }
}


#pragma InsuranceInfoViewDelegate
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

- (void) NotifyToSubmitImage:(UIImage *) travelCard1 travelCard2:(UIImage *)travelCard2 image1:(UIImage *) image1 cert2:(UIImage *)image2
{
    //[ProgressHUD show:@"正在上传"];
    [KGStatusBar showWithStatus:@"正在上传..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        NSString *filePahe1 = [self fileupMothed:travelCard1];
        NSString *filePahe2 = [self fileupMothed:travelCard2];
        NSString *filePahe3 = [self fileupMothed:image1];
        NSString *filePahe4 = [self fileupMothed:image2];
        
        [NetWorkHandler requestToSaveOrUpdateCustomerCar:self.data.carInfo.customerCarId customerId:self.data.customerId carNo:nil carProvinceId:nil carCityId:nil driveProvinceId:nil driveCityId:nil carTypeNo:nil carShelfNo:nil carEngineNo:nil carOwnerName:nil carOwnerCard:nil carOwnerPhone:nil carOwnerTel:nil carOwnerAddr:nil travelCard1:filePahe1 travelCard2:filePahe2 carOwnerCard1:filePahe3 carOwnerCard2:filePahe4 carRegTime:nil newCarNoStatus:nil carTradeStatus:nil carTradeTime:nil carInsurStatus1:nil carInsurCompId1:nil Completion:^(int code, id content) {
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
                      [KGStatusBar showSuccessWithStatus:@"照片上传成功"];
                    [_insuranceDetailView.tableview reloadData];
                }
                else{
                     [KGStatusBar showErrorWithStatus:@"照片上传失败，请检查网络设置。"];
                }
                //[ProgressHUD dismiss];
                 //[KGStatusBar dismiss];
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
        NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
        AVFile *file = [AVFile fileWithData:imageData];
        [file save];
        
        return file.url;
    }
    
    //文字内容
}

- (void) NotifyToRefreshSubviewFrames
{
    [self resetContetHeight:_selectedView];
    [self.scrollview scrollRectToVisible:CGRectMake(0, self.viewVConstraint.constant - self.scrollview.frame.size.height, ScreenWidth, self.scrollview.frame.size.height) animated:YES];
}

- (void) startRefresh
{
    _insuranceView.indicatorView.hidden = NO;
    [_insuranceView startAnimation];
}

- (void) NotifyToRefresh:(BaseInsuranceInfo *)sender;//刷新保单列表
{
    [self startRefresh];
    [self loadInsurPageList:0];
}

- (void) addFollowUp
{
    AddFollowUpVC *vc = [IBUIFactory CreateAddFollowUpViewController];
    [self.navigationController pushViewController:vc animated:YES];
    vc.customerId = self.customerId;
    vc.customerModel = self.customerinfoModel;
}

- (void) editAutoInsuranceInfo
{
    AutoInsuranceInfoEditVC *vc = [IBUIFactory CreateAutoInsuranceInfoEditViewController];
    [self.navigationController pushViewController:vc animated:YES];
    vc.customerId = self.customerId;
    vc.customerModel = self.data;
}

- (void) addAutoInsuranceInfo
{
    AutoInsuranceInfoEditVC *vc = [IBUIFactory CreateAutoInsuranceInfoEditViewController];
    [self.navigationController pushViewController:vc animated:YES];
    vc.customerId = self.customerId;
    vc.customerModel = self.data;
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

//算价
- (void) doBtnCarInsurPlan:(UIButton *) sender
{
    if([Util checkInfoFull:self.data.carInfo]){
        
        NSString *str = @"";
        if(self.customerinfoModel.detailModel.carInfo.carInsurStatus1 && self.customerinfoModel.detailModel.carInfo.carInsurCompId1 != nil){
            str = [NSString stringWithFormat:@"&lastYearStatus=1&carInsurCompId1=%@", self.customerinfoModel.detailModel.carInfo.carInsurCompId1];
        }
        
        OrderWebVC *web = [[OrderWebVC alloc] initWithNibName:@"OrderWebVC" bundle:nil];
        web.title = @"报价";
        [self.navigationController pushViewController:web animated:YES];
        NSString *url = [NSString stringWithFormat:@"%@/car_insur/car_insur_plan.html?clientKey=%@&userId=%@&customerId=%@&customerCarId=%@%@", Base_Uri, [UserInfoModel shareUserInfoModel].clientKey, [UserInfoModel shareUserInfoModel].userId, self.data.customerId, self.data.carInfo.customerCarId, str];
        [web loadHtmlFromUrl:url];
    }else{
        [self showProgressHUD];
        [self performSelector:@selector(shutProgressHUD) withObject:nil afterDelay:0.5];
    }
}

- (void) showProgressHUD
{
    [ProgressHUD show:@"请完善投保资料"];
}

- (void) shutProgressHUD
{
    [ProgressHUD dismiss];
}

@end
