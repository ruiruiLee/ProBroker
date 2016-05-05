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
    UIImage *KefuAvatarImage;
    UIImage *UserAvatarImage;
    UILabel *titleView;
    BOOL openRobot;
    UINavigationController *nav;
}

@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *returnMsg;
@property (nonatomic, retain) UIButton *leftBarButtonItemButton;

//保单信息
@property (nonatomic, strong) NSString *baodanLogoUrlstring;
@property (nonatomic, strong) NSString *baodanDetail;
@property (nonatomic, strong) NSString *baodanPrice;
@property (nonatomic, strong) NSString *baodanURL;
@property (nonatomic, strong) NSString *baodanCallbackID;

-(instancetype)initWithArray:(NSArray *)array;

-(void)userInfoInit:(NSString *)userName sex:(NSString *)sex Province:(NSString *)Province City:(NSString *)City phone:(NSString *)phone headImage:(UIImage *)headImage;

-(void)intoFAQ;
@end
