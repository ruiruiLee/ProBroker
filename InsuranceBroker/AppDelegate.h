//
//  AppDelegate.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/14.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewUserModel.h"
@class RootViewController;
@class ZWIntroductionViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) RootViewController *root;
@property (nonatomic, strong) ZWIntroductionViewController *introductionView;

@property (nonatomic,strong) NewUserModel *customerBanner;
@property (nonatomic, strong) NewUserModel *workBanner;
@property (nonatomic, strong) NewUserModel *inviteBanner;

@property (nonatomic, strong) NSString *chexianimg;
@property (nonatomic, strong) NSString *appIcon;
@property (nonatomic, strong) NSString *lineCustomer;
@property (nonatomic, strong) NSString *exactQuoteNewsId;
@property (nonatomic, strong) NSString *quoteUrl;


- (void)loadAppNotifyInfo;

@end

