//
//  AppDelegate.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/14.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "AppDelegate.h"
#import "define.h"
#import "AVOSCloud/AVOSCloud.h"
//#import <AVOSCloudSNS/AVOSCloudSNS.h>

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "ZWIntroductionViewController.h"
#import "RootViewController.h"
#import "AppContext.h"
#import "AppKeFuLib.h"
#import "OnlineCustomer.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>


#import "Pingpp.h"

@interface AppDelegate (WXApiDelegate)


@end

@implementation AppDelegate
@synthesize root;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[AppKeFuLib sharedInstance] loginWithAppkey:APP_KEY];
    //监听登录状态
    [self openNotification];
    //第三方分享ggg
    [ShareSDK registerApp:@"c736476da58c" activePlatforms:@[@(SSDKPlatformTypeSMS), @(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ), @(SSDKPlatformSubTypeQZone)] onImport:^(SSDKPlatformType platformType) {
        
        switch (platformType) {
            case SSDKPlatformTypeWechat:
            {
                [ShareSDKConnector connectWeChat:[WXApi class]];
            }
                break;
                case SSDKPlatformTypeQQ:
            {
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
            }
                break;
                
            default:
                break;
        }
        
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx4d5be0425a7a8af0" appSecret:@"963a4be41493c18c5917d285a1c55d0b"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1105028809"
                                     appKey:@"zLTZRV6XCnnHLGwb"
                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
        
        
    }];
    
    [WXApi registerApp:@"wx4d5be0425a7a8af0"];
    
    //设置AVOSCloud
    [AVOSCloud setApplicationId:AVOSCloudAppID clientKey:AVOSCloudAppKey];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        UIRemoteNotificationType types = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:types];
    } else {
        UIUserNotificationType types = UIUserNotificationTypeAlert |
        UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        // 第一次安装时运行打开推送
        // 引导界面展示
        
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    //create root view controller
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    root = [[RootViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = nav;
    nav.navigationBarHidden = YES;
    
    [self.window makeKeyAndVisible];
    
    //ping+设置为测试模式
    [Pingpp setDebugMode:YES];
    

    BOOL firsetLaunch = [AppContext sharedAppContext].firstLaunch;
    if(!firsetLaunch){
        NSArray *coverImageNames = @[@"guide1",@"guide2",@"guide3",@"guide4"];
        // Example 2 自定义登陆按钮
        UIButton *enterButton = [UIButton new];
        [enterButton setImage:ThemeImage(@"liketiyan") forState:UIControlStateNormal];
        self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:nil button:enterButton];
        
        [self.window addSubview:self.introductionView.view];
        [AppContext sharedAppContext].firstLaunch = YES;
        [[AppContext sharedAppContext] saveData];
        __weak AppDelegate *weakSelf = self;
        self.introductionView.didSelectedEnter = ^() {
            [weakSelf.introductionView.view removeFromSuperview];
            weakSelf.introductionView = nil;
        };
    }
    
    //登陆改为开放式
//    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
//    if(!user.uuid){
//        loginViewController *vc = [IBUIFactory CreateLoginViewController];
//        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
//        [root presentViewController:naVC animated:NO completion:nil];
//    }
    
       //判断程序是不是由推送服务完成的
    if (launchOptions)
    {
        NSDictionary* notificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (notificationPayload)
        {
            [self pushGetCoustomerNum:notificationPayload];

            //[self NotificationRedDisplay:notificationPayload];
            
            [self performSelector:@selector(pushDetailPage:) withObject:notificationPayload afterDelay:1.0];
            [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
             [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        }
    }


    return YES;
}


// iOS 8 及以下请用这个
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        // result : success, fail, cancel, invalid
        [self handlePayResult:result error:error];
        
    }];
    return  YES;
}

// iOS 9 以上请用这个
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        // result : success, fail, cancel, invalid
        
        [self handlePayResult:result error:error];
        
    }];
    return  YES;
}

- (void) handlePayResult:(NSString *) result error:(PingppError *) error
{
    NSString *msg;
    // if (error == nil) {
    if ([result isEqual:@"success"]) {
        msg = @"支付成功！";
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Pay_Success object:nil];
    }
    else if([result isEqual:@"cancel"]) {
        msg = @"支付已经取消！";
    }
    else if([result isEqual:@"fail"]) {
        msg = @"支付失败，请稍后再试！";
    }
    else if([result isEqual:@"invalid"]) {
        msg = @"支付无效，请稍后再试！";
    }
    else{
        msg = result;
    }
    
    if (error != nil)
        NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, msg);
    [Util showAlertMessage:msg];
}

// 在线客服
-(void)openNotification{
    //监听登录状态
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(isConnected :) name:APPKEFU_LOGIN_SUCCEED_NOTIFICATION object:nil];
    //监听在线状态
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(notifyOnlineStatus:) name:APPKEFU_WORKGROUP_ONLINESTATUS object:nil];
    //监听接收到的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:APPKEFU_NOTIFICATION_MESSAGE object:nil];

    //监听连接服务器报错
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyXmppStreamDisconnectWithError:) name:APPKEFU_NOTIFICATION_DISCONNECT_WITH_ERROR object:nil];
    }

-(void)closeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_LOGIN_SUCCEED_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_WORKGROUP_ONLINESTATUS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_DISCONNECT_WITH_ERROR object:nil];
    [ProgressHUD dismiss];
}

// 在线客服 接收是否登录成功通知
- (void)isConnected:(NSNotification*)notification
{
    NSNumber *isConnected = [notification object];
    if ([isConnected boolValue])
    {
        //登录成功
        [OnlineCustomer sharedInstance].isConnect =YES;
    }
    else
    {
        //登录失败
        [OnlineCustomer sharedInstance].isConnect =NO;
        [ProgressHUD dismiss];
        [KGStatusBar showErrorWithStatus:@"无法连接网络，请稍后再试！"];
    }
}
 // 在线客服
-(void)notifyXmppStreamDisconnectWithError:(NSNotification *)notification
{
    //登录失败
    [OnlineCustomer sharedInstance].isConnect =NO;
    [ProgressHUD dismiss];
    [KGStatusBar showErrorWithStatus:@"无法连接网络，请稍后再试！"];
}
// 在线客服 监听工作组在线状态
-(void)notifyOnlineStatus:(NSNotification *)notification
{
    // 链接失败 ![OnlineCustomer sharedInstance].isConnect ||
    if([OnlineCustomer sharedInstance].groupName==nil){
        [ProgressHUD dismiss];
        return;
    }
    NSDictionary *dict = [notification userInfo];
    //客服工作组名称
    NSString *workgroupName = [dict objectForKey:@"workgroupname"];
    //客服工作组在线状态
    NSString *status   = [dict objectForKey:@"status"];
    if ([workgroupName isEqualToString:[OnlineCustomer sharedInstance].groupName]) {
        
        //客服工作组在线
        if ([status isEqualToString:@"online"])
        {
            [OnlineCustomer sharedInstance].openRobot=NO;
            [OnlineCustomer sharedInstance].KefuAvatarImage=nil;
        }
        //客服工作组离线
        else
        {
            [OnlineCustomer sharedInstance].openRobot=YES;
            [OnlineCustomer sharedInstance].KefuAvatarImage= ThemeImage(@"robot");
        }
        [[OnlineCustomer sharedInstance] beginChat];
        [ProgressHUD dismiss];
    }
}

//接收到新消息
- (void)notifyMessage:(NSNotification *)nofication
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    KFMessageItem *msgItem = [nofication object];
    
    //接收到来自客服的消息
    if (!msgItem.isSendFromMe) {

        NSString * kefu = [NSString stringWithFormat:@"%@%@.jpg",kefuUrl,msgItem.username];
        [OnlineCustomer sharedInstance].KefuAvatarImage =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kefu]]];
        if([msgItem.workgroupName isEqualToString:zxkf]){
            AppContext *context = [AppContext sharedAppContext];
            context.isZSKFHasMsg = YES;
            [context saveData];
        }else{
            AppContext *context = [AppContext sharedAppContext];
            context.isBDKFHasMsg = YES;
            [context saveData];
        }
        
        //
        NSLog(@"消息时间:%@, 工作组名称:%@, 发送消息用户名:%@",
              msgItem.timestamp,
              msgItem.workgroupName,
              msgItem.username);
        
        //文本消息
//        if (KFMessageTypeText == msgItem.messageType) {
//            
//            NSLog(@"文本消息内容：%@", msgItem.messageContent);
//        }
//        //图片消息
//        else if (KFMessageTypeImageHTTPURL == msgItem.messageType)
//        {
//            NSLog(@"图片消息内容：%@", msgItem.messageContent);
//        }
//        //语音消息
//        else if (KFMessageTypeSoundHTTPURL == msgItem.messageType)
//        {
//            NSLog(@"语音消息内容：%@", msgItem.messageContent);
//        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    //离线消息通过服务器推送可接收到
    //在程序切换到前台时，执行重新登录，见applicationWillEnterForeground函数中
    [[AppKeFuLib sharedInstance] logout];
    //监听登录状态
    [self closeNotification];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //切换到前台重新登录
    [[AppKeFuLib sharedInstance] loginWithAppkey:APP_KEY];
    //监听登录状态
    [self openNotification];
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //推送功能打开时, 注册当前的设备, 同时记录用户活跃, 方便进行有针对的推送
    [AVOSCloud handleRemoteNotificationsWithDeviceToken:deviceToken];
    
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation addUniqueObject:@"ykbbrokerAllUser4" forKey:@"channels"];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    }];
    
    //在线客服同步deviceToken便于离线消息推送, 同时必须在管理后台上传 .pem文件才能生效
    [[AppKeFuLib sharedInstance] uploadDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{

    //可选 通过统计功能追踪打开提醒失败, 或者用户不授权本应用推送
    [AVAnalytics event:@"开启推送失败" label:[error description]];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //[UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [self pushGetCoustomerNum:userInfo];
   // [self NotificationRedDisplay:userInfo];
    NSLog(@"%@", userInfo);
    // 程序在运行中接收到推送
    if (application.applicationState == UIApplicationStateActive)
    {
        [root pushActivetoController:userInfo];
    }
    else  //程序在后台中接收到推送
    {
       //可选 通过统计功能追踪通过提醒打开应用的行为
        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
        [root pushtoController:userInfo];
    }
}

//mt ＝1   交易类
//mt＝2 客户相关类（获客，客户跟进）
//mt＝ 3  通知消息类
//mt＝ 4 私信
//mt = 504  服务器禁止访问的推送
// 推送获客 数字提示
- (void) pushGetCoustomerNum:(NSDictionary *) userInfo{
      NSInteger mt = [[userInfo objectForKey:@"mt"] integerValue];
    if(mt==2){
        AppContext *context = [AppContext sharedAppContext];
        context.pushCustomerNum = [[userInfo objectForKey:@"hk"] integerValue];
        [context saveData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_PushCustomer_Got object:nil];
    }
    
    else if(mt == 1){
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Refresh_OrderList1 object:nil];
    }

}
//推送消息提示小红点
- (void) NotificationRedDisplay:(NSDictionary *) userInfo{
      NSInteger mt = [[userInfo objectForKey:@"mt"] integerValue];
      NSInteger ct = [[userInfo objectForKey:@"ct"] integerValue];
    if(mt != 2 && mt != 504){
      AppContext *context = [AppContext sharedAppContext];
      [context changeNewsTip:ct display:YES];
    }
 }

-(void) pushDetailPage: (id)dic
{
     [root pushtoController:dic];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [self loadAppNotifyInfo];

}

- (void)loadAppNotifyInfo
{
    [self performSelector:@selector(openlocation) withObject:nil afterDelay:1.0f];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[UserInfoModel shareUserInfoModel] loadLastNewsTip];
        [[UserInfoModel shareUserInfoModel] loadCustomerCount];
    });
}

- (void)openlocation{
      [LcationInstance startUpdateLocation];
}
@end
