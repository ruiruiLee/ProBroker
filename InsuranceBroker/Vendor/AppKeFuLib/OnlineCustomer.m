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


-(void)setNavTitle:(NSString *)navTitle{
    _navTitle=navTitle;
     titleView.text = navTitle;
}

-(void)customerInit{
    
    // title
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleView.textColor = [UIColor blackColor];
    titleView.font = [UIFont boldSystemFontOfSize:18];
    titleView.textAlignment = NSTextAlignmentCenter;
    
}


-(void)userInfoInit:(NSString *)userName sex:(NSString *)sex Province:(NSString *)Province City:(NSString *)City phone:(NSString *)phone headImage:(UIImage *)headImage nav :(UINavigationController * )nav leftBtn:(UIButton *)leftBtn rightBtn:(UIButton *)rightBtn
 {
      [[AppKeFuLib sharedInstance] setTagNickname:userName];
      [[AppKeFuLib sharedInstance] setTagSex:sex];
      [[AppKeFuLib sharedInstance] setTagProvince:Province];
      [[AppKeFuLib sharedInstance] setTagCity:City];
      [[AppKeFuLib sharedInstance] setTagOther:phone];
       UserAvatarImage=headImage;
     self.nav=nav;
     self.leftBarButtonItemButton=leftBtn ;
     self.rightBarButtonItemButton=rightBtn;
      [[AppKeFuLib sharedInstance] queryWorkgroupOnlineStatus:_groupName];
    }

-(void)userInfoInit:(NSString *)userName sex:(NSString *)sex Province:(NSString *)Province City:(NSString *)City phone:(NSString *)phone headImage:(UIImage *)headImage baodanLogoUrlstring:(NSString *) baodanLogoUrlstring baodanDetail:(NSString *) baodanDetail baodanPrice:(NSString *) baodanPrice baodanURL:(NSString *) baodanURL baodanCallbackID:(NSString *) baodanCallbackID nav :(UINavigationController * )nav leftBtn:(UIButton *)leftBtn rightBtn:(UIButton *)rightBtn
{
    [[AppKeFuLib sharedInstance] setTagNickname:userName];
    [[AppKeFuLib sharedInstance] setTagSex:sex];
    [[AppKeFuLib sharedInstance] setTagProvince:Province];
    [[AppKeFuLib sharedInstance] setTagCity:City];
    [[AppKeFuLib sharedInstance] setTagOther:phone];
    UserAvatarImage=headImage;
    
    if(baodanLogoUrlstring == nil)
        baodanLogoUrlstring = ((AppDelegate *)[UIApplication sharedApplication].delegate).chexianimg;
    self.baodanLogoUrlstring = baodanLogoUrlstring;
    self.baodanDetail = baodanDetail;
    self.baodanPrice = baodanPrice;
    self.baodanURL = baodanURL;
    self.baodanCallbackID = baodanCallbackID;
    self.nav=nav;
    self.leftBarButtonItemButton=leftBtn ;
    self.rightBarButtonItemButton=rightBtn;
    [[AppKeFuLib sharedInstance] queryWorkgroupOnlineStatus:_groupName];
}

#pragma mark OnlineStatus


-(void)intoFAQ:(NSString *)groupName
{
    [[AppKeFuLib sharedInstance] pushFAQViewController:self.nav
                                     withWorkgroupName:groupName
                              hidesBottomBarWhenPushed:YES];
}



#pragma mark  进入在线客户聊天界面

-(void)beginChat
{
  
    if ([_groupName isEqual:zxkf] || _baodanCallbackID==nil){
        [[AppKeFuLib sharedInstance] pushChatViewController: self.nav
                                          withWorkgroupName:_groupName
                                     hideRightBarButtonItem:NO
                                 rightBarButtonItemCallback:^(){
                                     UIAlertView *alerview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:@"确定清空当前聊天记录吗?" delegate:self
                                                                              cancelButtonTitle:@"取消"
                                                                              otherButtonTitles:@"确定", nil];
                                      [alerview show];
                                 }
                                     showInputBarSwitchMenu:NO
                                      withLeftBarButtonItem:_leftBarButtonItemButton
                                              withTitleView:titleView
                                     withRightBarButtonItem:_rightBarButtonItemButton
                                            withProductInfo:nil
                                 withLeftBarButtonItemColor:UIColorFromRGB(0xff6619)
                                   hidesBottomBarWhenPushed:YES
                                         showHistoryMessage:YES
                                          //客服不在线，开启机器人
                                               defaultRobot:_openRobot
                                                   mustRate:NO
                                        withKefuAvatarImage:_KefuAvatarImage
                                        withUserAvatarImage:UserAvatarImage
                                        shouldShowGoodsInfo:NO
                                      withGoodsImageViewURL:nil
                                       withGoodsTitleDetail:nil
                                             withGoodsPrice:nil
                                               withGoodsURL:nil
                                        withGoodsCallbackID:nil
                                   goodsInfoClickedCallback:nil
         
                                 httpLinkURLClickedCallBack:nil
                             faqButtonTouchUpInsideCallback:^(){
                                 [self intoFAQ:faq];
                                 NSLog(@"faqButtonTouchUpInsideCallback, 自定义FAQ常见问题button回调，可在此打开自己的常见问题FAQ页面");
                                 
                             }];

    }
    else{
        [[AppKeFuLib sharedInstance] pushChatViewController:self.nav
                                          withWorkgroupName:_groupName
                                     hideRightBarButtonItem:NO
                                 rightBarButtonItemCallback:^(){
                                     UIAlertView *alerview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:@"确定清空当前聊天记录吗?" delegate:self
                                                                              cancelButtonTitle:@"取消"
                                                                              otherButtonTitles:@"确定", nil];
                                     [alerview show];
                                 }
                                 showInputBarSwitchMenu:NO
                                      withLeftBarButtonItem:_leftBarButtonItemButton
                                              withTitleView:titleView
                                     withRightBarButtonItem:_rightBarButtonItemButton
                                            withProductInfo:nil
                                 withLeftBarButtonItemColor:UIColorFromRGB(0xff6619)
                                   hidesBottomBarWhenPushed:YES
                                         showHistoryMessage:YES
         //客服不在线，开启机器人
                                               defaultRobot:_openRobot
                                                   mustRate:NO
                                        withKefuAvatarImage:_KefuAvatarImage
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
                                 [self intoFAQ:faq];
                                 NSLog(@"faqButtonTouchUpInsideCallback, 自定义FAQ常见问题button回调，可在此打开自己的常见问题FAQ页面");
                                 
                             }];
        
    }
}

#pragma mark UIAlerviewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s, %ld", __PRETTY_FUNCTION__, (unsigned long)buttonIndex);
    if (buttonIndex == 1) {
        [[AppKeFuLib sharedInstance] deleteMessagesWith:self.groupName];
        [self.nav popViewControllerAnimated:YES];
        
        if([self.groupName isEqualToString:zxkf]){
            AppContext *context = [AppContext sharedAppContext];
            context.isZSKFHasMsg = NO;
            [context saveData];
        }else{
            AppContext *context = [AppContext sharedAppContext];
            context.isBDKFHasMsg = NO;
            [context saveData];
        }
        
        UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"聊天记录已清空！"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView2 show];

    }
}

@end
