//
//  OnlineCustomer.m
//  AppKeFuDemo7
//
//  Created by forrestLee on 5/3/16.
//  Copyright © 2016 appkefu.com. All rights reserved.
//

#import "OnlineCustomer.h"

#import "AppKeFuLib.h"
@implementation OnlineCustomer



-(instancetype)initWithDict:(NSString *)groupName
{
    self = [super init];
    if (self) {
        _groupName = groupName;
        [self customerInit];
    }
    return self;
}


-(void)customerInit{
    //监听登录状态
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(isConnected:) name:APPKEFU_LOGIN_SUCCEED_NOTIFICATION object:nil];
    
    //监听在线状态
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(notifyOnlineStatus:) name:APPKEFU_WORKGROUP_ONLINESTATUS object:nil];
    
    //监听接收到的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    
    //监听连接服务器报错
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyXmppStreamDisconnectWithError:) name:APPKEFU_NOTIFICATION_DISCONNECT_WITH_ERROR object:nil];

}
-(void)backfromServie{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_LOGIN_SUCCEED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_WORKGROUP_ONLINESTATUS object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_DISCONNECT_WITH_ERROR object:nil];
}


//接收是否登录成功通知
- (void)isConnected:(NSNotification*)notification
{
    NSNumber *isConnected = [notification object];
    if ([isConnected boolValue])
    {
        //查询工作组在线状态，官方管理后台地址：http://appkefu.com/AppKeFu/admin
        _returnMsg= @"登录成功";
//        [[AppKeFuLib sharedInstance] queryWorkgroupOnlineStatus:@"zhixun"];
//        [[AppKeFuLib sharedInstance] queryWorkgroupOnlineStatus:@"baojia"];
    }
    else
    {
        _returnMsg= @"登录失败";
        
    }
}

#pragma mark OnlineStatus

//监听工作组在线状态
-(void)notifyOnlineStatus:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    
    //客服工作组名称
    NSString *workgroupName = [dict objectForKey:@"workgroupname"];
    
    //客服工作组在线状态
    NSString *status   = [dict objectForKey:@"status"];
    
    NSLog(@"%s workgroupName:%@, status:%@", __PRETTY_FUNCTION__, workgroupName, status);
    
    //
    if ([workgroupName isEqualToString:_groupName]) {
        
        //客服工作组在线
        if ([status isEqualToString:@"online"])
        {
            _online=YES;
            //onlineStatus = NSLocalizedString(@"1.在线咨询售前(在线)", nil);
        }
        //客服工作组离线
        else
        {
            //onlineStatus = NSLocalizedString(@"1.在线咨询售前(离线)", nil);
             _online=NO;
        }
        
    }

    //[self.tableView reloadData];
}

#pragma mark Message

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
    
    //[self.tableView reloadData];
}

-(void)notifyXmppStreamDisconnectWithError:(NSNotification *)notification
{
    //登录失败
   _returnMsg= @"网络连接失败,请稍候再试";
}


#pragma mark  进入在线客户聊天界面

-(void)beginChat:(UINavigationController *)nav
         KefuAvatarImage:(NSString *)KefuAvatarImage
         UserAvatarImage:(UIImage *)UserAvatarImage
 {
    [[AppKeFuLib sharedInstance] pushChatViewController:nav
                                      withWorkgroupName:_groupName
                                 hideRightBarButtonItem:NO
                             rightBarButtonItemCallback:nil
                                 showInputBarSwitchMenu:YES
                                  withLeftBarButtonItem:nil
                                          withTitleView:nil
                                 withRightBarButtonItem:nil
                                        withProductInfo:nil
                             withLeftBarButtonItemColor:nil
                               hidesBottomBarWhenPushed:YES
                                     showHistoryMessage:YES
                                           defaultRobot:FALSE
     //TRUE 注意：如果要强制用户在关闭会话的时候评价，需要首先设置参数：withLeftBarButtonItem， 否则此参数不会生效
                                               mustRate:FALSE
     //@"http://admin.appkefu.com/AppKeFu/admin/assets/avatar/ykb_kf001.jpg"
     //  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:KefuAvatarImage]]]
                                    withKefuAvatarImage:UserAvatarImage
   
                                    withUserAvatarImage:UserAvatarImage
     
                                    shouldShowGoodsInfo:FALSE
                                  withGoodsImageViewURL:nil
                                   withGoodsTitleDetail:nil
                                         withGoodsPrice:nil
                                           withGoodsURL:nil
                                    withGoodsCallbackID:nil
                               goodsInfoClickedCallback:nil
     
                             httpLinkURLClickedCallBack:nil
                         faqButtonTouchUpInsideCallback:nil];

}



@end
