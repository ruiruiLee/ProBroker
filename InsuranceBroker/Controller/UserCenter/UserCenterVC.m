//
//  UserCenterVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/18.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "UserCenterVC.h"
#import "define.h"
#import "UserSettingVC.h"
#import "UserInfoModel.h"
#import "UIImageView+WebCache.h"
#import "MyTeamsVC.h"
#import "DetailAccountVC.h"
#import "MyTeamInfoVC.h"
#import "OrderManagerVC.h"
#import "InsuranceBroker-Swift.h"

@implementation UserCenterVC

- (void) dealloc
{
    UserInfoModel *model = [UserInfoModel shareUserInfoModel];
    [model removeObserver:self forKeyPath:@"headerImg"];
    [model removeObserver:self forKeyPath:@"cardVerifiy"];
    [model removeObserver:self forKeyPath:@"sex"];
    [model removeObserver:self forKeyPath:@"nickname"];
    [model removeObserver:self forKeyPath:@"nowMonthOrderSuccessNums"];
    AppContext *context = [AppContext sharedAppContext];
    [context removeObserver:self forKeyPath:@"isRedPack"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoImgV.layer.cornerRadius = 45;
    self.logoImgv.layer.cornerRadius = 9;
    self.photoImgV.backgroundColor = [UIColor whiteColor];
    
    self.photoImgV.clipsToBounds = YES;
    self.photoImgV.layer.cornerRadius = 45;
    self.btnEditPhoto.layer.cornerRadius = 45;
//    self.btnEditPhoto.clipsToBounds = YES;
    self.lbRedLogo.clipsToBounds = YES;
    self.lbRedLogo.layer.cornerRadius = 4;
    self.redFlagConstraint.constant = -((ScreenWidth - 320)/2 + 50);
    
    self.lbOrderEarn.textColor = Subhead_Color;
    self.lbTotalOrderSuccessNums.textColor = Subhead_Color;
    self.lbUserInvite.textColor = Subhead_Color;
    self.lbTeamTotal.textColor = Subhead_Color;
    
    self.headHConstraint.constant = ScreenWidth;
    self.footVConstraint.constant = SCREEN_HEIGHT - 585 - 44 + 1 + 50;
    
    UserInfoModel *model = [UserInfoModel shareUserInfoModel];
    AppContext *context = [AppContext sharedAppContext];
    [model addObserver:self forKeyPath:@"headerImg" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"cardVerifiy" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"sex" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"nickname" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [context addObserver:self forKeyPath:@"isRedPack" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [model addObserver:self forKeyPath:@"nowMonthOrderSuccessNums" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
//    [self config];
    DGElasticPullToRefreshLoadingViewCircle *loadingView = [[DGElasticPullToRefreshLoadingViewCircle alloc] init];
    loadingView.tintColor = _COLOR(78, 221, 200);
    [self.scrollview dg_addPullToRefreshWithActionHandler:^{
//        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:0.5];
        [self egoRefreshTableHeaderDidTriggerRefresh:nil];
    } loadingView:loadingView];
    [self.scrollview dg_setPullToRefreshBackgroundColor:self.scrollview.backgroundColor];
    [self.scrollview dg_setPullToRefreshFillColor:_COLOR(0xff, 0x66, 0x19)];
    
    [self updateUserInfo];
}

- (void) stopRefresh
{
    [self.scrollview dg_stopLoading];
}

- (void) updateUserInfo
{
    UserInfoModel *model = [UserInfoModel shareUserInfoModel];
    
    self.lbMonthOrderSuccessNums.text = [NSString stringWithFormat:@"%.2f", model.nowMonthOrderSellEarn];
    self.lbTotalOrderSuccessNums.text = [NSString stringWithFormat:@"本月单量：%d单", model.nowMonthOrderSuccessNums];
//    self.lbMonthOrderEarn.text = [NSString stringWithFormat:@"%.2f", model.nowMonthOrderSuccessEarn];
//    self.lbOrderEarn.text = [NSString stringWithFormat:@"累计收益：%.2f元", model.orderTotalSuccessEarn];
    self.lbMonthOrderEarn.text = [NSString stringWithFormat:@"%.2f", model.nowUserTotalMoney];
    self.lbOrderEarn.text = [NSString stringWithFormat:@"累计收益：%.2f元", model.userTotalMoney];
    
    self.lbUserInvite.text = [NSString stringWithFormat:@"%d人", model.teamInviteNums];
    self.lbTeamTotal.text = [NSString stringWithFormat:@"%d人", model.teamTotalNums];
    self.lbNowMonthOrderCount.text = [NSString stringWithFormat:@"%d", model.nowMonthOrderSuccessNums];
    
    [self.btNameEdit setTitle:model.nickname forState:UIControlStateNormal];
    UIImage *placeholderImage = ThemeImage(@"head_male");
    if(model.sex == 2)
        placeholderImage = ThemeImage(@"head_famale");
    [self.photoImgV sd_setImageWithURL:[NSURL URLWithString:model.headerImg] placeholderImage:placeholderImage];
    
    if(model.leader == 1){
        self.lbRole.text = @"团长";
        self.logoImgv.image = ThemeImage(@"leader");
    }else
    {
        self.logoImgv.image = ThemeImage(@"member");
        self.lbRole.text = @"个人";
    }
    
    self.lbCertificate.textColor = _COLOR(0xf4, 0x43, 0x36);
    if(model.cardVerifiy == 1){
        self.lbCertificate.text = @"认证中";
        self.lbCertificate.textColor = _COLOR(53, 202, 100);
    }
    else if (model.cardVerifiy == 2){
        self.lbCertificate.text = @"认证失败";
    }
    else if (model.cardVerifiy == 3){
        self.lbCertificate.text = @"已认证";
        self.lbCertificate.textColor = _COLOR(53, 202, 100);
    }else{
        self.lbCertificate.text = @"未认证";
    }
    
//    if([AppContext sharedAppContext].isRedPack){
//        self.lbRedLogo.hidden = NO;
//    }else{
//        self.lbRedLogo.hidden = YES;
//    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self updateUserInfo];
}

# pragma mark - Custom view configuration

- (void) config
{
    /* Refresh View */
    refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    refreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    refreshView.delegate = self;
    [self.scrollview addSubview:refreshView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UserInfoModel *model = [UserInfoModel shareUserInfoModel];
    if(model.cardVerifiy == 1)
    {
        [model queryUserInfo];
    }
    [self updateUserInfo];
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.gradientView setGradientColor:_COLOR(0xff, 0x8c, 0x19) end:_COLOR(0xff, 0x66, 0x19)];
}

//修改用户资料
- (IBAction)EditUserInfo:(id)sender
{
    QRCodeVC *vc = [IBUIFactory CreateQRCodeViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnUserSetting:(id)sender
{
//    [self doBtnUserSetting:sender];
    UserInfoEditVC *vc = [IBUIFactory CreateUserInfoEditViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doBtnUserSetting:(id)sender
{
    UserSettingVC *vc = [[UserSettingVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//我的红包
- (IBAction)redPachet:(id)sender
{
//    MyLuckyMoneyVC *vc = [IBUIFactory CreateMyLuckyMoneyViewController];
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.title = @"我的红包";
//    [self.navigationController pushViewController:vc animated:YES];
    UserInfoModel *model = [UserInfoModel shareUserInfoModel];
    if(model.cardVerifiy == 3){
        IncomeWithdrawVC *vc = [IBUIFactory CreateIncomeWithdrawViewController];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [Util showAlertMessage:@"为保护您的资金安全，只有实名认证后才能收益提取"];
    }
}

//收益提现
- (IBAction)withdraw:(id)sender
{
//    UserInfoModel *model = [UserInfoModel shareUserInfoModel];
//    if(model.cardVerifiy == 3){
//        IncomeWithdrawVC *vc = [IBUIFactory CreateIncomeWithdrawViewController];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        [Util showAlertMessage:@"为保护您的资金安全，只有实名认证后才能收益提取"];
//    }
    DetailAccountVC *vc = [[DetailAccountVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//我的邀请
- (IBAction)invite:(id)sender
{
    MyTeamInfoVC *vc = [[MyTeamInfoVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userid = [UserInfoModel shareUserInfoModel].userId;
    vc.title = @"我的团队";
    vc.toptitle = @"我的队员";
    vc.name = @"我";
    //                vc.need = enumNeedIndicator;
    [self.navigationController pushViewController:vc animated:YES];
}

//整体规模
- (IBAction)scale:(id)sender
{
    DetailAccountVC *vc = [[DetailAccountVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)managerOrder:(id)sender
{
    OrderManagerVC *vc = [[OrderManagerVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//本月销售额
- (IBAction)finish:(id)sender
{
    NSLog(@"finish ===============");
    SalesStatisticsVC *vc = [IBUIFactory CreateSalesStatisticsViewController];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userId = [UserInfoModel shareUserInfoModel].userId;
    vc.title = [NSString stringWithFormat:@"我的销售统计"];
    [self.navigationController pushViewController:vc animated:YES];
}

//本月收益
- (IBAction)incomePrevMounth:(id)sender
{
    NSLog(@"incomePrevMounth --------------");
    IncomeStatisticsVC *vc = [IBUIFactory CreateIncomeStatisticsViewController];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userId = [UserInfoModel shareUserInfoModel].userId;
    vc.title = [NSString stringWithFormat:@"我的收益统计"];
    [self.navigationController pushViewController:vc animated:YES];
}

//认证
- (IBAction)authentication:(id)sender
{
    RealNameAuthenticationVC *vc = [IBUIFactory CreateRealNameAuthenticationViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    //    [pullDelegate pullTableViewDidTriggerRefresh:self];
    [[UserInfoModel shareUserInfoModel] loadDetail:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
//        [refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollview];
        [self.scrollview dg_stopLoading];
        [self updateUserInfo];
    }];
}

//- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
//    return self.pullLastRefreshDate;
//}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [refreshView egoRefreshScrollViewDidScroll:scrollView];
    
    // Also forward the message to the real delegate
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    
    // Also forward the message to the real delegate
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [refreshView egoRefreshScrollViewWillBeginDragging:scrollView];
    
    // Also forward the message to the real delegate
}
@end
