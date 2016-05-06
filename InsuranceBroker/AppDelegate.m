//
//  AppDelegate.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/14.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "AppDelegate.h"
#import "define.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>

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
@interface AppDelegate ()

@property (nonatomic, strong) ZWIntroductionViewController *introductionView;

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
    
    //设置AVOSCloud
    [AVOSCloud setApplicationId:AVOSCloudAppID clientKey:AVOSCloudAppKey];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        // 第一次安装时运行打开推送
#if !TARGET_IPHONE_SIMULATOR
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                    | UIUserNotificationTypeBadge
                                                    | UIUserNotificationTypeSound
                                                                                     categories:nil];
            [application registerUserNotificationSettings:settings];
            [application registerForRemoteNotifications];
        }
        else{
            [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |
             UIRemoteNotificationTypeAlert |
             UIRemoteNotificationTypeSound];
        }
#endif
        // 引导界面展示
        // [_rootTabController showIntroWithCrossDissolve];
        
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
    

    BOOL firsetLaunch = [AppContext sharedAppContext].firstLaunch;
    if(!firsetLaunch){
        NSArray *coverImageNames = @[@"guide1",@"guide2",@"guide3",@"guide4"];
        // Example 2 自定义登陆按钮
        UIButton *enterButton = [UIButton new];
        [enterButton setBackgroundColor:[UIColor redColor]];
        [enterButton setTitle:NSLocalizedString(@"立刻体验", nil) forState:UIControlStateNormal];
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
    
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    if(!user.isLogin){
        
        loginViewController *vc = [IBUIFactory CreateLoginViewController];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
        [root presentViewController:naVC animated:NO completion:nil];
    }
    
       //判断程序是不是由推送服务完成的
    if (launchOptions)
    {
       // [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        NSDictionary* notificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (notificationPayload)
        {
            [self NotificationRedDisplay:notificationPayload];
            
            [self performSelector:@selector(pushDetailPage:) withObject:notificationPayload afterDelay:1.0];
            [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
             [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        }
    }


    return YES;
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
        [KGStatusBar showErrorWithStatus:@"无法连接网络，请稍后再试！"];
    }
}
 // 在线客服
-(void)notifyXmppStreamDisconnectWithError:(NSNotification *)notification
{
    //登录失败
    [OnlineCustomer sharedInstance].isConnect =NO;
    [KGStatusBar showErrorWithStatus:@"无法连接网络，请稍后再试！"];
}
// 在线客服 监听工作组在线状态
-(void)notifyOnlineStatus:(NSNotification *)notification
{
    // 链接失败 ![OnlineCustomer sharedInstance].isConnect ||
    if([OnlineCustomer sharedInstance].groupName==nil){
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
        }
        //客服工作组离线
        else
        {
            [OnlineCustomer sharedInstance].openRobot=YES;
        }
        if ([[OnlineCustomer sharedInstance].groupName isEqual:zxkf] || [OnlineCustomer sharedInstance].baodanCallbackID==nil)
        {
            [[OnlineCustomer sharedInstance] beginChat];
        }
        else
        {
            [[OnlineCustomer sharedInstance] beginBaoDanChat];
        }
        
    }
}

//接收到新消息
- (void)notifyMessage:(NSNotification *)nofication
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    KFMessageItem *msgItem = [nofication object];
    
    //接收到来自客服的消息
    if (!msgItem.isSendFromMe) {
        
        //
        NSLog(@"消息时间:%@, 工作组名称:%@, 发送消息用户名:%@",
              msgItem.timestamp,
              msgItem.workgroupName,
              msgItem.username);
        
        //文本消息
        if (KFMessageTypeText == msgItem.messageType) {
            
            NSLog(@"文本消息内容：%@", msgItem.messageContent);
        }
        //图片消息
        else if (KFMessageTypeImageHTTPURL == msgItem.messageType)
        {
            NSLog(@"图片消息内容：%@", msgItem.messageContent);
        }
        //语音消息
        else if (KFMessageTypeSoundHTTPURL == msgItem.messageType)
        {
            NSLog(@"语音消息内容：%@", msgItem.messageContent);
        }
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
    self.deviceToken = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    
    [AVUser logOut];  //清除缓存用户对象
    [UserInfoModel shareUserInfoModel].userId = nil;
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation addUniqueObject:@"ykbbrokerAllUser4" forKey:@"channels"];
    [currentInstallation saveInBackground];
    //同步deviceToken便于离线消息推送, 同时必须在管理后台上传 .pem文件才能生效
    [[AppKeFuLib sharedInstance] uploadDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{

    //可选 通过统计功能追踪打开提醒失败, 或者用户不授权本应用推送
    [AVAnalytics event:@"开启推送失败" label:[error description]];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //[UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    // 程序在运行中接收到推送
    if (application.applicationState == UIApplicationStateActive)
    {
        [self NotificationRedDisplay:userInfo];
        [root pushActivetoController:userInfo];
    }
    else  //程序在后台中接收到推送
    {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
       //可选 通过统计功能追踪通过提醒打开应用的行为
        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
        [root pushtoController:userInfo];
    }
}

//推送消息提示小红点
- (void) NotificationRedDisplay:(NSDictionary *) userInfo{
      NSInteger mt = [[userInfo objectForKey:@"mt"] integerValue];
      NSInteger ct = [[userInfo objectForKey:@"ct"] integerValue];
      AppContext *context = [AppContext sharedAppContext];
    if(mt == 1){
      [context changeNewsTip:ct display:YES];
    }
    
 }

//category：10|12, //消息类别 10代表为“通知消息”12代表为”交易消息”，
//title: "消息标题"，如体现通知、收益通知等
//content: "消息内容"，如“您申请体现的￥300，已转入到你的帐号，请查收”
//userId:44，//经纪人userIds，有则传，没有则不传
//ct:消息子类别，
//
//当mt=1时，ct 可为10，11，12，13，系统通知消息类ct=10,交易通知类ct=12
//具体情况为
//ct=10 表示实名认证通过 ,提现申请审核通过  需要userId//通知类消息
//ct=12 表示保单交易成功   ，需要userId
//Ct=11,表示销售政策
//Ct=13,表示激励政策
//objectId:具体业务表主键，如报价完成时需要传入报价单id,提现申请需要传入申请单id,保单交易完成需要传入保单id,

-(void) pushDetailPage: (id)dic
{
     [root pushtoController:dic];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [self performSelector:@selector(openlocation) withObject:nil afterDelay:1.0f];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       
        [[UserInfoModel shareUserInfoModel] queryUserInfo];
        [[UserInfoModel shareUserInfoModel] queryLastNewsTip:^(int code, id content) {
        if(code == 200){
            AppContext *context = [AppContext sharedAppContext];
            [context SaveNewsTip:[NSArray arrayWithArray:[[content objectForKey:@"data"] objectForKey:@"rows"]]];
         }
    }];
    });

}
-(void)openlocation{
      [LcationInstance startUpdateLocation];
}
@end
