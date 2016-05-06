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

@interface OnlineCustomer : NSObject{
    
    UIImage *UserAvatarImage;
    UILabel *titleView;
    UINavigationController * chatNavigation;
 
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

-(void)userInfoInit:(NSString *)userName sex:(NSString *)sex Province:(NSString *)Province City:(NSString *)City phone:(NSString *)phone headImage:(UIImage *)headImage;

-(void)userInfoInit:(NSString *)userName sex:(NSString *)sex Province:(NSString *)Province City:(NSString *)City phone:(NSString *)phone headImage:(UIImage *)headImage baodanLogoUrlstring:(NSString *) baodanLogoUrlstring baodanDetail:(NSString *) baodanDetail baodanPrice:(NSString *) baodanPrice baodanURL:(NSString *) baodanURL baodanCallbackID:(NSString *) baodanCallbackID;

-(void)intoFAQ;
-(void)beginChat;
-(void)beginBaoDanChat;
@end
