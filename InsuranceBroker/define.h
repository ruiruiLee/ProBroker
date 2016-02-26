//
//  define.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/14.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#ifndef define_h
#define define_h

#import "UIView+MGBadgeView.h"
#import "UINavigationBar+Awesome.h"
#import "ViewFactory.h"
#import "IBUIFactory.h"
#import "Util.h"
#import "NetWorkHandler.h"
#import "UserInfoModel.h"
#import "AppDelegate.h"
#import "AppContext.h"
#import "LocationManagerObserver.h"

/*
 服务器地址信息
 */
#define AVOSCloudAppID  @"0PyuKjNlBECHhEf3HxDB7NYX-gzGzoHsz"
#define AVOSCloudAppKey @"mOmncwQfyeroy2jcDj0ch1Q1"
//#define SERVER_ADDRESS @"http://dev.ibroker.avosapps.com"
#define SERVER_ADDRESS @"http://dev.ibroker.leanapp.cn"
#define Base_Uri @"http://118.123.249.87:8783/UKB.AgentNew"
//#define Base_Uri @"http://shuaidehen.imwork.net/UKB.AgentNew/"

//location
#define LcationInstance [LocationManagerObserver sharedInstance]

//image
#define ThemeImage(imageName)  [UIImage imageNamed:imageName]

//rgb Color
#define _COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define _COLORa(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define Subhead_Color _COLOR(0x75, 0x75, 0x75)

//Font
#define _FONT(s) [UIFont fontWithName:@"Helvetica Neue" size:(s)]
#define _FONT_B(s) [UIFont boldSystemFontOfSize:(s)]

//Screen Width
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//limit
#define LIMIT 20

#define imgLicenseSize CGSizeMake(400, 240)

#define Normal_Image ThemeImage(@"normal")
#define Normal_Logo ThemeImage(@"normal_logo")
#define Image_NoData ThemeImage(@"normal_logo")
#define FormatImage_1(imageUrl,imageWidth,imageHeight) [NSString stringWithFormat:@"%@?imageView/1/w/%d/h/%d", imageUrl,imageWidth,imageHeight]

//ids
#define ABOUT_US @"56ce5b0fc24aa800545a216d"//关于我们
#define User_Agreement @"56ce5b3e71cfe40054072829"//用户协议
#define ABOUT_TEAM @"56ce5b81128fe142471e1432"//关于团队
#define INCOME_LOW @"56ce5c10efa631df62c08493"//收益太低
#define Withdrawal_Instructions @"56ce5c29c24aa800520e1b82"//提现说明

#define Notify_Reload_CustomerDetail @"Notify_Reload_CustomerDetail"
#define Notify_Add_NewCustomer  @"Notify_Add_NewCustomer"
#define Notify_Add_BankCard @"Notify_Add_BankCard"
#define Notify_Insert_Customer @"Notify_Insert_Customer"
#define Notify_Refrush_TagList @"Notify_Refrush_TagList"

#define QR_ADDRESS @"http://ukb.weixin.car517.com/app_download/specialty_agent_app_download.html"
#define ServicePhone @"4000803939"

#endif /* define_h */
