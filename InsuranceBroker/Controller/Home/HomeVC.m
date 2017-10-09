//
//  HomeVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/18.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "HomeVC.h"
#import "define.h"
#import "NoticeListVC.h"
#import "AgentStrategyViewController.h"
#import "NetWorkHandler+index.h"
#import "PosterModel.h"
#import "HaedlineModel.h"
#import "UIButton+WebCache.h"
#import "WebViewController.h"
#import "SelectCustomerVC.h"
#import "MyTeamInfoVC.h"
#import "RootViewController.h"
#import "UITabBar+badge.h"
#import "ServiceSelectView.h"
#import "OnlineCustomer.h"
#import "UIScrollView+JElasticPullToRefresh.h"
#import "PayUtil.h"
#import "SalesTableViewCell.h"

#import "ProductListViewController.h"
#import "THSegmentedPager.h"
#import "HeadlineView.h"

#import "SBJson.h"

#import "NetWorkHandler+queryForProductAttrPageList.h"

#import "ProductListTableViewCell.h"

#define CellHeight 135

@interface HomeVC ()<MJBannnerPlayerDeledage, PopViewDelegate, UITableViewDelegate, UITableViewDataSource, HeadlineViewDelegate>
{
    UIButton * leftBarButtonItemButton;
    UIButton * rightBarButtonItemButton;
    
    HeadlineView *_headleine;

}

@property (nonatomic, strong) NSArray *infoArray;
@property (nonatomic, strong) NSArray *headlines;
@property (nonatomic, strong) NSArray *productArray;

@property (nonatomic, strong) NetWorkHandler *handler;

@end

@implementation HomeVC

@synthesize scrollview;
@synthesize btnMessage;
@synthesize scroll;

- (void) dealloc
{
    AppContext *context = [AppContext sharedAppContext];
    [context removeObserver:self forKeyPath:@"isNewMessage"];
    [context removeObserver:self forKeyPath:@"isZSKFHasMsg"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    if([user.uuid isEqualToString:youKeUUId]){
        self.btnMessage.imageView.badgeView.badgeValue = 0;
        [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
        
        [self showServiceBadge:NO];
    }
    else{
        AppContext *con= [AppContext sharedAppContext];
        if(con.isNewMessage)
        {
            self.btnMessage.imageView.badgeView.badgeValue = 1;
            [self.tabBarController.tabBar showBadgeOnItemIndex:0];
        }else{
            self.btnMessage.imageView.badgeView.badgeValue = 0;
            [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
        }
        
        if(con.isZSKFHasMsg){
            [self showServiceBadge:YES];
        }
        else{
            [self showServiceBadge:NO];
        }
    }
}

- (void) showServiceBadge:(BOOL) flag
{
    if(flag){
        self.btnMyService.imageView.badgeView.badgeValue = 1;
        self.btnMyService.imageView.badgeView.frame = CGRectMake(39.5, -2.5, 15, 15);
    }
    else
        self.btnMyService.imageView.badgeView.badgeValue = 0;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppContext *context = [AppContext sharedAppContext];
    [context addObserver:self forKeyPath:@"isNewMessage" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [context addObserver:self forKeyPath:@"isZSKFHasMsg" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyLogin:) name:Notify_Login object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyRefreshData:) name:Notify_Refresh_Home object:nil];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:ThemeImage(@"logo")];
    self.navigationItem.titleView = logoView;
    [self setLeftBarButtonWithImage:nil];

    [self initSubViews];
    
    self.viewWidth.constant = ScreenWidth;
    
    self.btnMessage = [[HighNightBgButton alloc] initWithFrame:CGRectMake(ScreenWidth - 60, 20, 46, 46)];
    [self.btnMessage setImage:ThemeImage(@"user_message2") forState:UIControlStateNormal];
    [self.btnMessage addTarget:self action:@selector(handleRightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.btnMessage];
    
    self.btnMessage.imageView.clipsToBounds = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SalesTableViewCell" bundle:nil] forCellReuseIdentifier:@"SalesTableViewCell"];
    
    _headleine = [[HeadlineView alloc] initWithFrame:CGRectMake((26.0 * ScreenWidth)/375.0, (39 * ScreenWidth)/375.0 - (40 - (40 * ScreenWidth)/375)/2.0, (234 * ScreenWidth)/375, 40)];
    [self.btnBg addSubview:_headleine];
    _headleine.delegate = self;
    _headleine.userInteractionEnabled = NO;
//    _headleine.backgroundColor = [UIColor redColor];
    
    UIImage *old = ThemeImage(@"img_home_gonggao");
    [self.btnBg setBackgroundImage:old forState:UIControlStateNormal];
    self.infoHeight.constant = (87 * ScreenWidth)/375;
    
    self.handler = [[NetWorkHandler alloc] init];
    self.btnBg.userInteractionEnabled = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadDatas];
}

- (void) initSubViews
{
    [self.bgview addConstraint:[NSLayoutConstraint constraintWithItem:scrollview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[Util getHeightByWidth:750 height:360 nwidth:ScreenWidth]]];
    
    JElasticPullToRefreshLoadingViewCircle *loadingViewCircle = [[JElasticPullToRefreshLoadingViewCircle alloc] init];
    loadingViewCircle.tintColor = [UIColor whiteColor];
    
    __weak __typeof(self)weakSelf = self;
    [self.scroll addJElasticPullToRefreshViewWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf egoRefreshTableHeaderDidTriggerRefresh:nil];
        });
    } LoadingView:loadingViewCircle];
    [self.scroll setJElasticPullToRefreshFillColor:[UIColor clearColor]];
    [self.scroll setJElasticPullToRefreshBackgroundColor:[UIColor clearColor]];
    
    self.scroll.delegate = self;
}

- (void) buildForStudyAndZhanye
{
    
    NSArray *subviews = self.scrollForStudy.subviews;
    
    for (int i = 0; i < subviews.count; i++) {
        UIView *view = [subviews objectAtIndex:i];
        [view removeFromSuperview];
    }
    
    CGFloat ox = 10;
    for (int i = 0 ; i < self.infoArray.count; i++) {
        AnnouncementModel *chengGongZhiLu = [self.infoArray objectAtIndex:i];
        NSString *url = chengGongZhiLu.bgImg;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ox, 0, 230, 100)];
        [btn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        
        btn.tag = 200+i;
        [btn addTarget:self action:@selector(doBtnStudyInfo:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollForStudy addSubview:btn];
        
        ox += 240;
    }
    
    self.scrollForStudy.contentSize = CGSizeMake(240 * self.infoArray.count + 10, 110);
}

- (void) NotifyLogin:(NSNotification *) notify
{
    [self loadDatas];
    [App_Delegate loadAppNotifyInfo];
}

- (void) NotifyRefreshData:(NSNotification *) notify
{
    [self loadDatas];
}

- (void) removeProductArray
{
    [self loadDatas];
    [self.tableView reloadData];
}

#pragma mark - EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self loadDatas];
}

- (void) loadDatas
{
    [self loadRecommend];
    
    [NetWorkHandler requestToIndex:^(int code, id content) {
        [self.scroll stopLoading];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            NSDictionary *d = [content objectForKey:@"data"];
            _adArray = [PosterModel modelArrayFromArray:[d objectForKey:@"poster"]];
            [App_Delegate setCustomerBanner:(NewUserModel*)[NewUserModel modelFromDictionary:[d objectForKey:@"customerBanner"]]];
            [App_Delegate setWorkBanner:(NewUserModel*)[NewUserModel modelFromDictionary:[d objectForKey:@"workBanner"]]];
            [App_Delegate setInviteBanner:(NewUserModel*)[NewUserModel modelFromDictionary:[d objectForKey:@"friendBanner"]]];
            [App_Delegate setExactQuoteNewsId:[d objectForKey:@"exactQuoteNewsId"]];
            NSDictionary *commonImg = [d objectForKey:@"commonImg"];
            [App_Delegate setAppIcon:[commonImg objectForKey:@"appIcon"]];
            [App_Delegate setChexianimg:[commonImg objectForKey:@"cheXian"]];
            [App_Delegate setLineCustomer:[commonImg objectForKey:@"lineCustomer"]];
            [App_Delegate setQuoteUrl:[d objectForKey:@"quoteUrl"]];
            self.infoArray = [AnnouncementModel modelArrayFromArray:[d objectForKey:@"gongLue"]];
            self.headlines = [HeadlineModel modelArrayFromArray:[d objectForKey:@"headlines"]];
            
            if(self.headlines.count > 0)
                self.btnBg.userInteractionEnabled = YES;
            else
                self.btnBg.userInteractionEnabled = NO;
            [_headleine reloadData];
            [self buildForStudyAndZhanye];
            @try {
//                _jiHuaShu = [self.infoArray objectAtIndex:1];
                for (int i = 0; i < [self.infoArray count] ; i++) {
                    AnnouncementModel *model = [self.infoArray objectAtIndex:i];
                    if([model.category isEqualToString:@"7"]){
                        _jiHuaShu = model;
                        break;
                    }
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            [self initData];
        }
    }];
}

//获取推荐数据
- (void) loadRecommend
{
//    if([self isLogin]){
        [self.handler requestToQueryForProductAttrPageList:0 limit:1000 filters:nil userId:[UserInfoModel shareUserInfoModel].userId uuid:[UserInfoModel shareUserInfoModel].uuid insuranceType:@"-1" completion:^(int code, id content) {
            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
            
            if(code == 200){
                
                self.productArray = [productAttrModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]];
                [self.tableView reloadData];
            }
        }];
//    }else{
//        self.productArray = [[NSArray alloc] init];
//        [self.tableView reloadData];
//    }
}

- (BOOL) isLogin
{
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    if(!user.uuid){
        return NO;
    }else{
        return YES;
    }
}

- (NSDictionary *) getRulesByField:(NSString *) field op:(NSString *) op data:(NSString *) data
{
    NSMutableDictionary *rule = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:rule value:field key:@"field"];
    [Util setValueForKeyWithDic:rule value:op key:@"op"];
    [Util setValueForKeyWithDic:rule value:data key:@"data"];
    
    return rule;
}

- (void) initData
{
     NSMutableArray * mArray  =  [[NSMutableArray alloc]init];
     for (int i = 0; i < _adArray.count; i++) {
          PosterModel *item = [_adArray objectAtIndex:i];
//         NSString *url = [NSString stringWithFormat:@"%@?imageView/1/w/%f/h/%d", item.imgUrl, ScreenWidth * 3, 180 * 3];
          [mArray addObject:item.imgUrl];
         //Banner img
     }

    [MJBannnerPlayer initWithUrlArray:mArray
                                addTarget:self.scrollview
                                 delegate:self
                                 withSize:CGRectMake(0, 0, self.view.frame.size.width, [Util getHeightByWidth:375 height:180 nwidth:ScreenWidth])
                         withTimeInterval:4.f];
    
}

# pragma mark MJBannnerPlayer delegate
-(void)MJBannnerPlayer:(UIView *)bannerPlayer didSelectedIndex:(NSInteger)index{
    PosterModel *model = [_adArray objectAtIndex:index];
    if(model.isRedirect == 1){
        WebViewController *vc = [IBUIFactory CreateWebViewController];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = model.title;
        vc.type = enumShareTypeShare;
        if(model.imgUrl != nil)
            vc.shareImgArray = [NSArray arrayWithObject:model.imgUrl];
        vc.shareTitle = model.title;
        vc.shareContent = model.content;
        [self.navigationController pushViewController:vc animated:YES];
        if(model.url == nil){
            [vc loadHtmlFromUrlWithUserId:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", model.pid]];
        }else{
            [vc loadHtmlFromUrlWithUserId:model.url];
        }
    }

}

//个人消息
- (void) handleRightBarButtonClicked:(id)sender
{
    if([self login]){
        NoticeListVC *vc = [[NoticeListVC alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

////我的团队
//- (void)doBtnMyTeams:(id)sender
//{
//    if([self login]){
//        
//        MyTeamInfoVC *vc = [[MyTeamInfoVC alloc] initWithNibName:nil bundle:nil];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.userid = [UserInfoModel shareUserInfoModel].userId;
//        vc.title = @"我的团队";
//        vc.toptitle = @"我的队员";
//        vc.name = @"我";
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}

#pragma ServiceSelectView

- (void) HandleItemSelect:(PopView *) view selectImageName:(NSString *) imageName
{
    if([imageName isEqualToString:@"service_ring"]){
        NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",ServicePhone]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }else{
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
        [OnlineCustomer sharedInstance].navTitle=zxTitle;
        [OnlineCustomer sharedInstance].groupName=zxkf;
        [ProgressHUD show:@"连接客服..."];
        [[OnlineCustomer sharedInstance] userInfoInit:[UserInfoModel shareUserInfoModel].realName sex:msex Province:[UserInfoModel shareUserInfoModel].liveProvince City:[UserInfoModel shareUserInfoModel].liveCity phone:[UserInfoModel shareUserInfoModel].phone headImage:placeholderImage nav:self.navigationController leftBtn:leftBarButtonItemButton rightBtn:rightBarButtonItemButton];
    }
}

-(void) kefuNavigationBar{
    // 左边按钮
    leftBarButtonItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftBarButtonItemButton setImage:[UIImage imageNamed:@"arrow_left"]
                             forState:UIControlStateNormal];
    [leftBarButtonItemButton addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    rightBarButtonItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [rightBarButtonItemButton setImage:[UIImage imageNamed:@"garbage"] forState:UIControlStateNormal];
    
  }

- (void) doBtnClicked:(id) sender
{
    AppContext *con= [AppContext sharedAppContext];
    con.isZSKFHasMsg = NO;
    [con saveData];
}

- (IBAction)doBtnMenuClicked:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    
    switch (tag) {
        case 1001:
        {//车险
            AutoInsuranceStep1VC *vc = [IBUIFactory CreateAutoInsuranceStep1VC];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = @"车险算价";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1002:
        {//意外险
            [self turnToARisk:@"3" riskName:@"意外.旅游"];
        }
            break;
        case 1003:
        {//旅游险
            [self turnToARisk:@"6" riskName:@"少儿险"];
        }
            break;
        case 1004:
        {//少儿险
            [self turnToARisk:@"2" riskName:@"家财险"];
        }
            break;
        case 1005:
        {//健康险
            [self turnToARisk:@"4" riskName:@"健康险"];
        }
            break;
        case 1006:
        {//家财险
//            [self turnToARisk:@"2" riskName:@"家财险"];
            [self turnToARisk:@"5" riskName:@"特色"];
        }
            break;
        case 1007:
        {//专属客服
            ServiceSelectView *popview = [[ServiceSelectView alloc] initWithImageArray:@[@"service_ring", @"info_online"] nameArray:@[@"客服电话", @"在线咨询"]];
            [self.view.window addSubview:popview];
            popview.delegate = self;
            [popview show];
        }
            break;
        case 1008:
        {//邀请好友
            if([self login]){
                NewUserModel *model = [App_Delegate workBanner];
                if(model.isRedirect){
                    WebViewController *web = [IBUIFactory CreateWebViewController];
                    web.title = model.title;
                    web.type = enumShareTypeShare;
                    web.shareTitle = model.title;
                    web.shareContent = model.content;
                    if(model.imgUrl)
                        web.shareImgArray = [NSArray arrayWithObject:model.imgUrl];
                    web.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:web animated:YES];
                    NSString *url = [NSString stringWithFormat:@"%@appId=%@", model.url, [UserInfoModel shareUserInfoModel].uuid];
                    [web loadHtmlFromUrlWithAppId:url];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void) turnToARisk:(NSString *) category riskName:(NSString *) riskName
{
    ProductListViewController *vc = [[ProductListViewController alloc] initWithNibName:nil bundle:nil];
    vc.title = riskName;
    vc.category = category;
    vc.hidesBottomBarWhenPushed = YES;
            
    [self.navigationController pushViewController:vc animated:YES];
}

//学习展业
- (void) doBtnStudyInfo:(UIButton *) sender
{
    NSInteger tag = sender.tag;
    
    switch (tag) {
        case 200://成功之路
            [self obtainSelectAtIndex:0];
            break;
        case 201://服务支撑
            [self obtainSelectAtIndex:1];
            break;
        case 202://推广
            [self obtainSelectAtIndex:2];
            break;
        case 203://互联网车生活
            [self obtainSelectAtIndex:3];
            break;
        default:
            break;
    }
}

- (void) obtainSelectAtIndex:(NSInteger) idx
{
    if([self.infoArray count] > idx){
        AnnouncementModel *chengGongZhiLu = [self.infoArray objectAtIndex:idx];
        AgentStrategyViewController *vc = [[AgentStrategyViewController alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        vc.category = chengGongZhiLu.category;
        vc.title = chengGongZhiLu.title;
        vc.totalModel = chengGongZhiLu;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.productArray count];
    
//    self.tableHeight.constant = count * CellHeight;
    if(count > 0){
        self.commondViewHeight.constant = count * CellHeight + 64;
        self.commondView.hidden = NO;
    }
    else{
        self.commondViewHeight.constant = 0;
        self.commondView.hidden = YES;
    }
    
    CGSize size = self.scroll.contentSize;
    CGRect frame = self.scroll.frame;
    
    if(size.height - self.commondViewBootomSpace.constant < frame.size.height - 10){
        CGFloat constant = frame.size.height - (size.height - self.commondViewBootomSpace.constant)  + 1;
        self.commondViewBootomSpace.constant = constant;
    }else{
        self.commondViewBootomSpace.constant = 10;
    }

    
    return count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SalesTableViewCell"];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"SalesTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    productAttrModel *model = [self.productArray objectAtIndex:indexPath.row];
    
    [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:Normal_Image];
    cell.lbTitle.text = model.productName;
    cell.lbContent.text = model.productIntro;
    if(model.productSellNums){
        cell.lbCount.hidden = NO;
        cell.lbCount.text = [NSString stringWithFormat:@"已售 %@ 份", model.productSellNums];
    }else{
        cell.lbCount.hidden = YES;
    }
    
    if(model.showPrice){
        cell.lbPrice.hidden = NO;
        cell.lbPrice.text = model.showPrice;
    }
    else{
        cell.lbPrice.hidden = YES;
    }
    
    if(model.productMaxRatio != nil)
        cell.lbRate.text = [self attstringwithRate:model.productMaxRatio];
    else
        cell.lbRate.text = @"";//[self attstringwithRate:@"0"];
    
    
    return cell;
}


#pragma UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(![self login]){
        return;
    }
    
    productAttrModel *m = [self.productArray objectAtIndex:indexPath.row];
    if(![m.uniqueFlag isEqualToString:@"100"])
    {//自有产品
        OurProductDetailVC *web = [IBUIFactory CreateOurProductDetailVC];
        web.hidesBottomBarWhenPushed = YES;
        web.title = m.productName;
        //    web.type = enumShareTypeShare;
        if(m.productLogo != nil)
            web.shareImgArray = [NSArray arrayWithObject:m.productLogo];
        
        web.shareContent = m.productIntro;
        web.shareTitle = m.productName;
        [self.navigationController pushViewController:web animated:YES];
        [web loadHtmlFromUrlWithUserId:m.clickAddr productId:m.productId];
    }
    else{//众安产品
        ProductDetailWebVC *web = [IBUIFactory CreateProductDetailWebVC];
        web.hidesBottomBarWhenPushed = YES;
        web.title = m.productName;
        if(m.productLogo != nil)
            web.shareImgArray = [NSArray arrayWithObject:m.productLogo];
        
        web.shareContent = m.productIntro;
        web.shareTitle = m.productName;
        web.selectProModel = m;
        
        NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
        [mdic setObject:@{@"appId": [UserInfoModel shareUserInfoModel].userId, @"productId": m.productId} forKey:@"extraInfo"];
        
        SBJsonWriter *_writer = [[SBJsonWriter alloc] init];
        NSString *dataString = [_writer stringWithObject:mdic];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.view.userInteractionEnabled = NO;
        
        NSString *url = [NSString stringWithFormat:@"http://118.123.249.87:8783/UKB.AgentNew/web/security/encryRC4.xhtml?"];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
        [pramas setObject:dataString forKey:@"dataString"];
        
        [[NetWorkHandler shareNetWorkHandler] getWithUrl:url Params:pramas Completion:^(int code, id content) {
            self.view.userInteractionEnabled = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(code == 1){
                NSString *bizContent =  (NSString *) content;
                
                NSString *url = [NSString stringWithFormat:@"%@&bizContent=%@", m.clickAddr, bizContent];
                
                [self.navigationController pushViewController:web animated:YES];
                [web loadHtmlFromUrl:url];
            }
        }];
    }
}

#pragma HeadlineViewDelegate
- (void) headline:(HeadlineCell *)headline cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HeadlineModel *model = [self.headlines objectAtIndex:indexPath.row];
    headline.lbDetail.text = model.title;
}

- (NSInteger) numberOfRows:(HeadlineView *)headline
{
    return self.headlines.count;
}

- (void) headline:(HeadlineView *)headline SelectAtIndexPath:(NSIndexPath *)indexpath
{
    
}

- (NSAttributedString *) attstringwithPrice:(NSString *) price
{
    NSString *string = [NSString stringWithFormat:@"¥ %@ 起", price];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [string rangeOfString:@"起"];
    [attString addAttribute:NSFontAttributeName value:_FONT(10) range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:_COLOR(0x75, 0x75, 0x75) range:range];
    return attString;
}

- (NSString *) attstringwithRate:(NSString *) rate
{
    NSString *string = [NSString stringWithFormat:@"推广费:%@", rate];
    if(rate == nil || [rate length] == 0)
        return @"";
    return string;
}

#pragma ACTION

- (IBAction)doBtnYouKuaiTouTiaoClicked:(id)sender
{
    if([_headlines count] > 0){
        NSInteger idx = [_headleine getCurrentSelectIdx];
        if(idx < 0)
            return;
        HeadlineModel *model = [_headlines objectAtIndex:idx];
        if(model && model.isRedirect){
            WebViewController *web = [IBUIFactory CreateWebViewController];
            web.hidesBottomBarWhenPushed = YES;
            web.title = model.title;
            web.type = enumShareTypeShare;
            web.shareTitle = model.title;
            web.shareContent = model.content;
            [self.navigationController pushViewController:web animated:YES];
            
            if(model.url == nil){
                [web loadHtmlFromUrlWithUserId:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", model.hid]];
            }else{
                [web loadHtmlFromUrlWithUserId:model.url];
            }
        }
    }

}
@end
