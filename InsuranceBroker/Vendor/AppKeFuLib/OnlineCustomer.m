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


+ (OnlineCustomer *)sharedInstance
{
    static dispatch_once_t once;
    static OnlineCustomer *instance = nil;
    dispatch_once( &once, ^{
        instance = [[OnlineCustomer alloc] init]; } );
    return instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
         [self customerInit];
    }
    return self;
}

-(void)leftBarButtonItemTouchUpInside:(UIButton *)sender
{
    [self closeNotification];
}

-(void)setNavTitle:(NSString *)navTitle{
    _navTitle=navTitle;
     titleView.text = navTitle;
}

-(void)customerInit{
    
    // title
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleView.textColor = [UIColor blackColor];
    titleView.font = [UIFont boldSystemFontOfSize:20];
    titleView.textAlignment = NSTextAlignmentCenter;
    

    // 左边按钮
    _leftBarButtonItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_leftBarButtonItemButton setImage:[UIImage imageNamed:@"arrow_left"]
                              forState:UIControlStateNormal];
    [_leftBarButtonItemButton addTarget:self action:@selector(leftBarButtonItemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    _rightBarButtonItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];

    //右边按钮
    //        [_rightBarButtonItemButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    
    [_rightBarButtonItemButton setTitle:@"更多" forState:UIControlStateNormal];
    [_rightBarButtonItemButton setTitleColor:UIColorFromRGB(0xff6619)forState:UIControlStateNormal];
}


-(void)closeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_LOGIN_SUCCEED_NOTIFICATION object:nil];

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

-(void)userInfoInit:(NSString *)userName sex:(NSString *)sex Province:(NSString *)Province City:(NSString *)City phone:(NSString *)phone headImage:(UIImage *)headImage baodanLogoUrlstring:(NSString *) baodanLogoUrlstring baodanDetail:(NSString *) baodanDetail baodanPrice:(NSString *) baodanPrice baodanURL:(NSString *) baodanURL baodanCallbackID:(NSString *) baodanCallbackID
{
    [[AppKeFuLib sharedInstance] setTagNickname:userName];
    [[AppKeFuLib sharedInstance] setTagSex:sex];
    [[AppKeFuLib sharedInstance] setTagProvince:Province];
    [[AppKeFuLib sharedInstance] setTagCity:City];
    [[AppKeFuLib sharedInstance] setTagOther:phone];
    UserAvatarImage=headImage;
    
    self.baodanLogoUrlstring = baodanLogoUrlstring;
    self.baodanDetail = baodanDetail;
    self.baodanPrice = baodanPrice;
    self.baodanURL = baodanURL;
    self.baodanCallbackID = baodanCallbackID;
    
    [[AppKeFuLib sharedInstance] queryWorkgroupOnlineStatus:_groupName];
}

#pragma mark OnlineStatus


//接收是否登录成功通知
- (void)isConnected:(NSNotification*)notification
{
    NSNumber *isConnected = [notification object];
    if ([isConnected boolValue])
    {
     //登录成功
      _isConnect =YES;
     [[AppKeFuLib sharedInstance] queryWorkgroupOnlineStatus:_groupName];
    }
    else
    {
     //登录失败
      _isConnect =NO;
    }
}

-(void)intoFAQ
{
    [[AppKeFuLib sharedInstance] pushFAQViewController:_nav
                                     withWorkgroupName:_groupName
                              hidesBottomBarWhenPushed:YES];
}



#pragma mark  进入在线客户聊天界面

-(void)beginChat
 {
    [[AppKeFuLib sharedInstance] pushChatViewController:_nav
                                      withWorkgroupName:_groupName
                                 hideRightBarButtonItem:NO
                             rightBarButtonItemCallback:nil
                                 showInputBarSwitchMenu:NO
                                  withLeftBarButtonItem:_leftBarButtonItemButton
                                          withTitleView:titleView
                                 withRightBarButtonItem:_rightBarButtonItemButton
                                        withProductInfo:nil
                             withLeftBarButtonItemColor:nil
                               hidesBottomBarWhenPushed:YES
                                     showHistoryMessage:YES
                                           //客服不在线，开启机器人
                                           defaultRobot:_openRobot
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
    

    [[AppKeFuLib sharedInstance] pushChatViewController:_nav
                                      withWorkgroupName:_groupName
                                 hideRightBarButtonItem:NO
                             rightBarButtonItemCallback:nil                                 showInputBarSwitchMenu:NO
                                  withLeftBarButtonItem:_leftBarButtonItemButton
                                          withTitleView:titleView
                                 withRightBarButtonItem:_rightBarButtonItemButton
                                        withProductInfo:nil
                             withLeftBarButtonItemColor:nil
                               hidesBottomBarWhenPushed:YES
                                     showHistoryMessage:YES
                                           //客服不在线，开启机器人
                                           defaultRobot:_openRobot
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
                   if(_BaodanInfoClicked !=nil){
                       _BaodanInfoClicked(goodsCallbackId);
                       }
                   }
     
                             httpLinkURLClickedCallBack:nil
                         faqButtonTouchUpInsideCallback:^(){
                             
                             NSLog(@"faqButtonTouchUpInsideCallback, 自定义FAQ常见问题button回调，可在此打开自己的常见问题FAQ页面");
                             [self intoFAQ];
                             
                         }];
    
    
}


@end
