//
//  RootViewController.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/14.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "RootViewController.h"
#import "define.h"
#import "OrderManagerVC.h"
#import "UITabBar+badge.h"
#import "AVOSCloud/AVOSCloud.h"

@interface RootViewController ()

@property (nonatomic, copy) CustomerMainVC *customervc;

@end

@implementation RootViewController
@synthesize homevc;
@synthesize customervc;
//@synthesize workvc;
@synthesize usercentervc;
@synthesize selectVC;

+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    /** 设置默认状态 */
    NSMutableDictionary *norDict = @{}.mutableCopy;
    norDict[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    norDict[NSForegroundColorAttributeName] = _COLOR(0x99, 0x99, 0x99);
    [tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];
    
    /** 设置选中状态 */
    NSMutableDictionary *selDict = @{}.mutableCopy;
    selDict[NSFontAttributeName] = norDict[NSFontAttributeName];
    selDict[NSForegroundColorAttributeName] = _COLOR(255, 255, 255);
    [tabBarItem setTitleTextAttributes:selDict forState:UIControlStateSelected];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppContext *context = [AppContext sharedAppContext];
    [context removeObserver:self forKeyPath:@"pushCustomerNum"];
}

- (void)tapReceivedNotificationHandler:(NSNotification *)notice
{
    CMNavBarNotificationView *notificationView = (CMNavBarNotificationView *)notice.object;
    if ([notificationView isKindOfClass:[CMNavBarNotificationView class]])
    {
        NSLog( @"Received touch for notification with text: %@", ((CMNavBarNotificationView *)notice.object).textLabel.text );
    }
    [self pushtoControllerByTap:notificationView.msgInfo];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self displayGuests];
}

-(void)displayGuests{
    AppContext *con= [AppContext sharedAppContext];
    if(con.pushCustomerNum > 0)
    {
        self.tabBar.items[1].badgeValue= [NSString stringWithFormat:@"%ld", (long)con.pushCustomerNum];
    }
    else{
        self.tabBar.items[1].badgeValue=nil;
        
    }

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self displayGuests];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tapReceivedNotificationHandler:)
                                                 name:kCMNavBarNotificationViewTapReceivedNotification
                                               object:nil];
    self.delegate = self;
   
    AppContext *context = [AppContext sharedAppContext];
    [context addObserver:self forKeyPath:@"pushCustomerNum" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    homevc = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
    [self setUpChildControllerWith:homevc norImage:ThemeImage(@"home") selImage:ThemeImage(@"home_fill") title:@"代理"];
    homevc.tabBarItem.tag = 1001;
    
    customervc = [[CustomerMainVC alloc] initWithNibName:nil bundle:nil];
    [self setUpChildControllerWith:customervc norImage:ThemeImage(@"people") selImage:ThemeImage(@"people_fill") title:@"客 户"];
    customervc.tabBarItem.tag = 1002;
    
    usercentervc = [[UserCenterVC alloc] initWithNibName:@"UserCenterVC" bundle:nil];
    [self setUpChildControllerWith:usercentervc norImage:ThemeImage(@"myself") selImage:ThemeImage(@"myself_fill") title:@"我 的"];
    usercentervc.tabBarItem.tag = 1004;
    
    
    UIImageView *tabBarBgView = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
    tabBarBgView.backgroundColor = _COLORa(0x22, 0x22, 0x22, 0.9);//_COLOR(0x22, 0x22, 0x22);
    [self.tabBar insertSubview:tabBarBgView atIndex:0];
    
    /** 设置tabar工具条 */
//    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
    selectVC = homevc;
}

//添加item 视图控制器
- (void)setUpChildControllerWith:(UIViewController *)childVc norImage:(UIImage *)norImage selImage:(UIImage *)selImage title:(NSString *)title
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    childVc.tabBarItem.title = title;
    
    childVc.tabBarItem.image = norImage;
    selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selImage;
    [childVc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
    [self addChildViewController:nav];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSInteger tag = viewController.tabBarItem.tag;
    if(tag == 1001){
        selectVC = homevc;
        return YES;
    }
    else if (tag == 1002){
        selectVC = customervc;
        return YES;
    }
    else{
        selectVC = usercentervc;
        
        return YES;
        
/*        BOOL result = [selectVC login];
        if(result){
            if(tag == 1002){
                selectVC = customervc;
            }
//            else if (tag == 1003){
//                selectVC = workvc;
//            }
            else
            {
                selectVC = usercentervc;
            }
        }
        return result;*/
    }
}

/**
 * 手动跳转页面
 * mt 跳转到的页面ID
 */


-(void) pushActivetoController:(id)dic{
    
    UINavigationController *nav =[self.viewControllers objectAtIndex:0];
    NSInteger mt = [[dic objectForKey:@"mt"] integerValue];
    if ([nav.topViewController isKindOfClass:[PrivateMsgVC class]]&&mt==4)
    {
         [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Msg_Reload object:nil userInfo:dic];
        
    }else if (504 == mt){
        NSInteger ct = [[dic objectForKey:@"ct"] integerValue];
        if (504 == ct) {
            [self logout];
        }
        [CMNavBarNotificationView notifyWithText:[[dic objectForKey:@"aps"] objectForKey:@"category"]
                                          detail:[[dic objectForKey:@"aps"] objectForKey:@"alert"]                                       image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[App_Delegate appIcon]]]]
                                     andDuration:5.0
                                       msgparams:dic];
    }
    else{
    [CMNavBarNotificationView notifyWithText:[[dic objectForKey:@"aps"] objectForKey:@"category"]
                                      detail:[[dic objectForKey:@"aps"] objectForKey:@"alert"]                                       image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[App_Delegate appIcon]]]]
                                 andDuration:5.0
                                  msgparams:dic];
    }
}

- (void) setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    if(selectedIndex == 0){
        selectVC = homevc;
    }
    else if (selectedIndex == 1){
        selectVC = customervc;
    }
    else if (selectedIndex == 2){
        selectVC = usercentervc;
    }
}

//mt ＝1   交易类
//mt＝2 客户相关类（获客，客户跟进）
//mt＝ 3  通知消息类
//mt＝ 4 私信
//mt = 504  服务器禁止访问的推送
-(void) pushtoController:(NSDictionary *)info
{
     if([homevc login]==NO){
         return;
     }
    NSInteger mt = [[info objectForKey:@"mt"] integerValue];
    NSInteger ct = [[info objectForKey:@"ct"] integerValue];
    AppContext *context = [AppContext sharedAppContext];
     long long datenew = [[info objectForKey:@"lastNewsDt"] longLongValue];
     [context UpdateNewsTipTime:datenew category:ct];
    //[context changeNewsTip:ct display:NO];
    if (mt == 1){  // 进入保单列表页面
        OrderManagerVC *vc = [[OrderManagerVC alloc] initWithNibName:nil bundle:nil];
        vc.filterString = [info objectForKey:@"p"];
        vc.hidesBottomBarWhenPushed = YES;
        [selectVC.navigationController pushViewController:vc animated:YES];
    }
    else if(mt == 2){  // 刷新客户列表界面
        [customervc.navigationController popToRootViewControllerAnimated:NO];
        self.selectedIndex = 1;
        selectVC = customervc;
        [customervc.pulltable reloadData];

    }
    else if (mt == 3){  // 进入消息详情
        WebViewController *web = [IBUIFactory CreateWebViewController];
        web.hidesBottomBarWhenPushed = YES;
        web.title =  [[info objectForKey:@"aps"] objectForKey:@"category"];
        web.type = enumShareTypeShare;
        web.shareTitle = web.title;
        web.hidesBottomBarWhenPushed = YES;
        [selectVC.navigationController pushViewController:web animated:YES];
        NSLog(@"%@", selectVC);
        
        [web loadHtmlFromUrlWithUserId:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", [info objectForKey:@"p"]]];

    }else if (mt == 4){  // 进入私信详情

        UINavigationController *nav =[self.viewControllers objectAtIndex:0];
        if ([nav.topViewController isKindOfClass:[PrivateMsgVC class]]&&mt==4)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Msg_Reload object:nil userInfo:info];
            
        }else{
            PrivateMsgVC *web = [IBUIFactory CreatePrivateMsgVC];
            web.hidesBottomBarWhenPushed = YES;
            web.title =  [[info objectForKey:@"aps"] objectForKey:@"category"];
            web.type = enumShareTypeNo;
            web.shareTitle = web.title;
            web.toUserId = [info objectForKey:@"p"];
            web.hidesBottomBarWhenPushed = YES;
            [selectVC.navigationController pushViewController:web animated:YES];
            UserInfoModel *model = [UserInfoModel shareUserInfoModel];
            
            [web loadHtmlFromUrl:[NSString stringWithFormat:Peivate_Msg_Url, SERVER_ADDRESS, model.userId, [info objectForKey:@"p"]]];
          }
       }
    else if( 504 == mt)
    {
        NSInteger ct = [[info objectForKey:@"ct"] integerValue];
        if (504 == ct) {
            [self logout];
        }
        
        [CMNavBarNotificationView notifyWithText:[[info objectForKey:@"aps"] objectForKey:@"category"]
                                          detail:[[info objectForKey:@"aps"] objectForKey:@"alert"]                                       image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[App_Delegate appIcon]]]]
                                     andDuration:5.0
                                       msgparams:info];
    }
}

-(void) pushtoControllerByTap:(NSDictionary *)info
{
    if([homevc login]==NO){
        return;
    }
    NSInteger mt = [[info objectForKey:@"mt"] integerValue];
    NSInteger ct = [[info objectForKey:@"ct"] integerValue];
    AppContext *context = [AppContext sharedAppContext];
   // [context changeNewsTip:ct display:NO];
    long long datenew = [[info objectForKey:@"lastNewsDt"] longLongValue];
    [context UpdateNewsTipTime:datenew category:ct];
    if (mt == 1){  // 进入保单列表页面
        OrderManagerVC *vc = [[OrderManagerVC alloc] initWithNibName:nil bundle:nil];
        vc.filterString = [info objectForKey:@"p"];
        vc.hidesBottomBarWhenPushed = YES;
        [selectVC.navigationController pushViewController:vc animated:YES];
    }
    else if(mt == 2){  // 刷新客户列表界面
        [customervc.navigationController popToRootViewControllerAnimated:NO];
        self.selectedIndex = 1;
        selectVC = customervc;
        [customervc.pulltable reloadData];
        
    }
    else if (mt == 3){  // 进入消息详情
        WebViewController *web = [IBUIFactory CreateWebViewController];
        web.hidesBottomBarWhenPushed = YES;
        web.title =  [[info objectForKey:@"aps"] objectForKey:@"category"];
        web.type = enumShareTypeShare;
        web.shareTitle = web.title;
        web.hidesBottomBarWhenPushed = YES;
        [selectVC.navigationController pushViewController:web animated:YES];
        NSLog(@"%@", selectVC);
        
        [web loadHtmlFromUrlWithUserId:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", [info objectForKey:@"p"]]];
        
    }else if (mt == 4){  // 进入私信详情
        PrivateMsgVC *web = [IBUIFactory CreatePrivateMsgVC];
        web.hidesBottomBarWhenPushed = YES;
        web.title =  [[info objectForKey:@"aps"] objectForKey:@"category"];
        web.type = enumShareTypeNo;
        web.shareTitle = web.title;
        web.toUserId = [info objectForKey:@"p"];
        web.hidesBottomBarWhenPushed = YES;
        [selectVC.navigationController pushViewController:web animated:YES];
        UserInfoModel *model = [UserInfoModel shareUserInfoModel];
        
        [web loadHtmlFromUrl:[NSString stringWithFormat:Peivate_Msg_Url,SERVER_ADDRESS, model.userId, [info objectForKey:@"p"]]];
        //          }
    }
    else if( 504 == mt)
    {
        NSInteger ct = [[info objectForKey:@"ct"] integerValue];
        if (504 == ct) {
            [self logout];
        }
        [CMNavBarNotificationView notifyWithText:[[info objectForKey:@"aps"] objectForKey:@"category"]
                                          detail:[[info objectForKey:@"aps"] objectForKey:@"alert"]                                       image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[App_Delegate appIcon]]]]
                                     andDuration:5.0
                                       msgparams:info];
    }
    
}

- (void) logout
{
    [Util logout];
    
    loginViewController *vc = [IBUIFactory CreateLoginViewController];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:naVC animated:NO completion:nil];
}

@end
