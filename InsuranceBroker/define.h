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
 测试服务器地址信息ß

 */
//
/*
#define SERVER_ADDRESS @"http://ykbtest.leanapp.cn"
#define Base_Uri @"http://118.123.249.87:8783/UKB.AgentNew"
#define AVOSCloudAppID  @"dwhKbFjMcY4ppGaSVvzN4577-gzGzoHsz"
#define AVOSCloudAppKey @"6ygVI6sQEL0z4vTjSLeFXD3T"
#define CHE_XIAN_BAO_JIA @"http://ukbserver.leanapp.cn/#/?appId=%@&carNo=%@"
#define CHE_XIAN_SUAN_JIA  @"http://ukbserver.leanapp.cn/#/single/choice"
*/

//正式服地址
#define SERVER_ADDRESS @"http://ibroker.leanapp.cn"
#define Base_Uri @"http://broker.ukuaibao.com"
#define AVOSCloudAppID  @"0PyuKjNlBECHhEf3HxDB7NYX-gzGzoHsz"
#define AVOSCloudAppKey @"mOmncwQfyeroy2jcDj0ch1Q1"
#define CHE_XIAN_BAO_JIA @"http://ibwx.leanapp.cn/ukbserver/#/?appId=%@&carNo=%@"
#define CHE_XIAN_SUAN_JIA  @"http://ibwx.leanapp.cn/ukbserver/#/single/choice"

// 在线客服
#define APP_KEY @"f3b9c7da5044b70c7bbf1e4a83862c6b"

//location
#define LcationInstance [LocationManagerObserver sharedInstance]

//image
#define ThemeImage(imageName)  [UIImage imageNamed:imageName]
#define Share_Icon @"http://ac-0pyukjnl.clouddn.com/4b3d8bcb59e5b9bf736f.png"
#define Peivate_Msg_Url @"http://ykbtest.leanapp.cn/news/privateLetter/details?acceptId=%@&senderId=%@"

//rgb Color
#define _COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define _COLORa(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define Subhead_Color _COLOR(0x75, 0x75, 0x75)
#define SepLine_color _COLOR(0xf5, 0xf5, 0xf5)
#define MaskColor _COLORa(230, 230, 230, 0.3)
#define SepLineColor _COLORa(0xa7, 0xa7, 0xa7, 0.6)

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
#define ABOUT_TEAM @"56ce6522efa631df62c0ca74"//关于团队
#define INCOME_LOW @"56ce5c10efa631df62c08493"//收益太低
#define Withdrawal_Instructions @"56ce5c29c24aa800520e1b82"//提现说明

#define Notify_Reload_CustomerDetail @"Notify_Reload_CustomerDetail"
#define Notify_Add_NewCustomer  @"Notify_Add_NewCustomer"
#define Notify_Add_BankCard @"Notify_Add_BankCard"
#define Notify_Insert_Customer @"Notify_Insert_Customer"
#define Notify_Refrush_TagList @"Notify_Refrush_TagList"
#define Notify_Logout @"Notify_Logout"
#define Notify_Login @"Notify_Login"
#define Notify_Refresh_OrderList @"Notify_Refresh_OrderList"//新建报价
#define Notify_Refresh_OrderList1 @"Notify_Refresh_OrderList1"//报价成功
#define Notify_Refresh_Insured_list @"Notify_Refresh_Insured_list"
#define Notify_Refresh_Car_list @"Notify_Refresh_Car_list"
#define Notify_Service_Info_Received @"Notify_Service_Info_Received"
#define Notify_Msg_Reload @"Notify_Msg_Reload"
#define Notify_Pay_Success @"Notify_Pay_Success"
#define Notify_Refresh_Home @"Notify_Refresh_Home"

#define QR_ADDRESS @"http://ukb.weixin.car517.com/app_download/specialty_agent_app_download.html"
#define ServicePhone @"4000803939"


#define FormatImage(imageUrl,imageWidth,imageHeight) [NSString stringWithFormat:@"%@?imageView/1/w/%d/h/%d", imageUrl,imageWidth * 2,imageHeight * 2]

#define CAR_INSUR_PLAN @"%@?customerCarId=%@&appId=%@&orderUuid=%@"

#define Default_Customer_Name  @"匿名"

#define How_To_Insu_Explain @"＊优快保提供以下三种报价方式\n \n 1 直接填写投保人［车牌号］快速报价，此报价需要自动匹配车辆续保资料，若系统不能匹配，可输入车架号等信息再提交报价。\n \n 2 直接上传投保人［行驶证正本］照片报价。由于需要工作人员进行照片审核，需在工作日时间范围（9:30-18:00）内报价，若非工作时间或是节假日，需要等待。\n \n 3  录入投保人［行驶证正本］明细信息，可立即快速报价。\n \n＊ 注：客户确认投保后，应保监会规定需要上传所有证件照片（行驶证正、副本，身份证正、反面）方可出单（在“客户资料”模块可上传照片）。。"

#define App_Delegate  (AppDelegate *)[UIApplication sharedApplication].delegate

#define Default_User_Type  @"4"

//邀请好友
#define IINVITE_TITLE @"相信我，只为推荐给最信任的你"
#define INVITE_CONTENT @"没有条件，加入就送现金10元，然后继续做你爱做的事，玩儿一起来赚钱"

#endif /* define_h */
