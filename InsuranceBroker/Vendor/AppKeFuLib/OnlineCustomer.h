//
//  OnlineCustomer.h
//  AppKeFuDemo7
//
//  Created by forrestLee on 5/3/16.
//  Copyright © 2016 appkefu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>
@interface OnlineCustomer : NSObject{
    NSString *studentName;
    NSInteger age;
}
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *returnMsg;
@property (nonatomic, assign) Boolean online;

-(instancetype)initWithDict:(NSString *)groupName;
-(void)beginChat:(UINavigationController *)nav
                   KefuAvatarImage:(NSString *)KefuAvatarImage
                   UserAvatarImage:(UIImage *)UserAvatarImage;
@end
