//
//  OnlineCustomer.h
//  AppKeFuDemo7
//
//  Created by forrestLee on 5/3/16.
//  Copyright © 2016 appkefu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>
#define kefuUrl = @"http://admin.appkefu.com/AppKeFu/admin/assets/avatar/"
#define bjkf @"policy"
#define zxkf @"business"
#define bjTitle @"保单咨询"
#define zxTitle @"专属客服"
@interface OnlineCustomer : NSObject{
    
    UIImage *UserAvatarImage;
    UILabel *titleView;
 
}

@property (nonatomic, copy) NSString *groupName; //组名
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic, assign) BOOL openRobot;
@property (nonatomic, copy) UIImage *KefuAvatarImage;
@property (nonatomic, retain) UINavigationController *nav;
@property (nonatomic, strong) UIButton *leftBarButtonItemButton;
@property (nonatomic, strong) UIButton *rightBarButtonItemButton;

//保单信息
@property (nonatomic, copy) NSString *baodanLogoUrlstring;
@property (nonatomic, copy) NSString *baodanDetail;
@property (nonatomic, copy) NSString *baodanPrice;
@property (nonatomic, copy) NSString *baodanURL;
@property (nonatomic, copy) NSString *baodanCallbackID;
@property (copy, nonatomic) void(^BaodanInfoClicked)(NSString*);


+ (OnlineCustomer *)sharedInstance;

-(void)userInfoInit:(NSString *)userName sex:(NSString *)sex Province:(NSString *)Province City:(NSString *)City phone:(NSString *)phone headImage:(UIImage *)headImage nav :(UINavigationController * )nav leftBtn:(UIButton *)leftBtn rightBtn:(UIButton *)rightBtn
;

-(void)userInfoInit:(NSString *)userName sex:(NSString *)sex Province:(NSString *)Province City:(NSString *)City phone:(NSString *)phone headImage:(UIImage *)headImage baodanLogoUrlstring:(NSString *) baodanLogoUrlstring baodanDetail:(NSString *) baodanDetail baodanPrice:(NSString *) baodanPrice baodanURL:(NSString *) baodanURL baodanCallbackID:(NSString *) baodanCallbackID nav :(UINavigationController * )nav leftBtn:(UIButton *)leftBtn rightBtn:(UIButton *)rightBtn
;

-(void)intoFAQ;
-(void)beginChat;
@end
