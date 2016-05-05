//
//  OnlineCustomer.m
//  AppKeFuDemo7
//
//  Created by forrestLee on 5/3/16.
//  Copyright © 2016 appkefu.com. All rights reserved.
//

#import "OnlineCustomer.h"
#import "AppKeFuLib.h"
#import "define.h"
@implementation OnlineCustomer



-(instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self) {
         _groupName = array[0];
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        titleView.textColor = [UIColor blackColor];
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.text = array[1];
        nav =array[2];
         _leftBarButtonItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_leftBarButtonItemButton setImage:[UIImage imageNamed:@"arrow_left"]
                                 forState:UIControlStateNormal];
        [_leftBarButtonItemButton addTarget:self action:@selector(leftBarButtonItemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

        [self customerInit];
    }
    return self;
}

-(void)leftBarButtonItemTouchUpInside:(UIButton *)sender
{
    [self backfromServie];
}
-(void)customerInit{
    
    //监听在线状态
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(notifyOnlineStatus:) name:APPKEFU_WORKGROUP_ONLINESTATUS object:nil];
    
    //监听连接服务器报错
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyXmppStreamDisconnectWithError:) name:APPKEFU_NOTIFICATION_DISCONNECT_WITH_ERROR object:nil];

}


-(void)backfromServie{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_WORKGROUP_ONLINESTATUS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_DISCONNECT_WITH_ERROR object:nil];
}

-(void)userInfoInit:(NSString *)userName sex:(NSString *)sex Province:(NSString *)Province City:(NSString *)City phone:(NSString *)phone headImage:(UIImage *)headImage
 {
      [[AppKeFuLib sharedInstance] setTagNickname:userName];
      [[AppKeFuLib sharedInstance] setTagSex:sex];
      [[AppKeFuLib sharedInstance] setTagProvince:Province];
      [[AppKeFuLib sharedInstance] setTagCity:City];
      [[AppKeFuLib sharedInstance] setTagOther:phone];
      UserAvatarImage=headImage;
      [[AppKeFuLib sharedInstance] queryWorkgroupOnlineStatus:_groupName];
 }



-(void)notifyXmppStreamDisconnectWithError:(NSNotification *)notification
{
    //登录失败
    _returnMsg= @"网络连接失败,请稍候再试";
}

#pragma mark OnlineStatus



-(void)intoFAQ
{
    [[AppKeFuLib sharedInstance] pushFAQViewController:nav
                                     withWorkgroupName:_groupName
                              hidesBottomBarWhenPushed:YES];
}

//监听工作组在线状态
-(void)notifyOnlineStatus:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    //客服工作组名称
    NSString *workgroupName = [dict objectForKey:@"workgroupname"];
    //客服工作组在线状态
    NSString *status   = [dict objectForKey:@"status"];
    if ([workgroupName isEqualToString:_groupName]) {
        
        //客服工作组在线
        if ([status isEqualToString:@"online"])
        {
            openRobot=NO;
        }
        //客服工作组离线
        else
        {
            openRobot=YES;
        }
        if ([_groupName isEqual:zxkf] || _baodanCallbackID==nil) {
            [self beginChat];
        }else{
            [self beginBaoDanChat];
        }

    }
}

#pragma mark  进入在线客户聊天界面

-(void)beginChat
 {
    [[AppKeFuLib sharedInstance] pushChatViewController:nav
                                      withWorkgroupName:_groupName
                                 hideRightBarButtonItem:NO
                             rightBarButtonItemCallback:nil
                                 showInputBarSwitchMenu:NO
                                  withLeftBarButtonItem:_leftBarButtonItemButton
                                          withTitleView:titleView
                                 withRightBarButtonItem:nil
                                        withProductInfo:nil
                             withLeftBarButtonItemColor:nil
                               hidesBottomBarWhenPushed:YES
                                     showHistoryMessage:YES
                                           //客服不在线，开启机器人
                                           defaultRobot:openRobot
                                               mustRate:NO
                                    withKefuAvatarImage:KefuAvatarImage
                                    withUserAvatarImage:UserAvatarImage
                                         shouldShowGoodsInfo:NO
                                  withGoodsImageViewURL:nil
                                   withGoodsTitleDetail:nil
                                         withGoodsPrice:nil
                                           withGoodsURL:nil
                                    withGoodsCallbackID:nil
                               goodsInfoClickedCallback:nil
     
                             httpLinkURLClickedCallBack:nil
                         faqButtonTouchUpInsideCallback:nil];
}

-(void)beginBaoDanChat{
    [[AppKeFuLib sharedInstance] pushChatViewController:nav
                                      withWorkgroupName:_groupName
                                 hideRightBarButtonItem:NO
                             rightBarButtonItemCallback:nil
                                 showInputBarSwitchMenu:NO
                                  withLeftBarButtonItem:_leftBarButtonItemButton
                                          withTitleView:titleView
                                 withRightBarButtonItem:nil
                                        withProductInfo:nil
                             withLeftBarButtonItemColor:nil
                               hidesBottomBarWhenPushed:YES
                                     showHistoryMessage:YES
                                           //客服不在线，开启机器人
                                           defaultRobot:openRobot
                                               mustRate:NO
                                    withKefuAvatarImage:KefuAvatarImage
                                    withUserAvatarImage:UserAvatarImage
                                    shouldShowGoodsInfo:YES
                                  withGoodsImageViewURL:_baodanLogoUrlstring
                                   withGoodsTitleDetail:_baodanDetail
                                         withGoodsPrice:_baodanPrice
                                           withGoodsURL:_baodanURL
                                    withGoodsCallbackID:_baodanCallbackID
                               goodsInfoClickedCallback:^(NSString *goodsCallbackId) {
                                   //点击保单详情区域会触发此回调函数
                                   NSLog(@"%s this is: %@", __PRETTY_FUNCTION__, goodsCallbackId);
                               }
     
                             httpLinkURLClickedCallBack:nil
                         faqButtonTouchUpInsideCallback:^(){
                             
                             NSLog(@"faqButtonTouchUpInsideCallback, 自定义FAQ常见问题button回调，可在此打开自己的常见问题FAQ页面");
                             [self intoFAQ];
                             
                         }];
    
    
}


@end
