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
}
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *returnMsg;
@property (nonatomic, assign) Boolean online;

-(instancetype)initWithGroup:(NSString *)groupName;

-(void)userInfoInit:(NSString *)userName sex:(NSString *)sex Province:(NSString *)Province City:(NSString *)City phone:(NSString *)phone headImage:(UIImage *)headImage;

-(void)beginChat:(UINavigationController *)nav;
@end
