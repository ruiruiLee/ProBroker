//
//  IBUIFactory.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/16.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "loginViewController.h"
#import "CustomerDetailVC.h"
#import "UserInfoEditVC.h"
#import "EditTagVC.h"
#import "TagListViewController.h"
#import "CustomerInfoEditVC.h"
#import "AddFollowUpVC.h"
#import "AutoInsuranceInfoEditVC.h"
#import "QRCodeVC.h"
#import "RealNameAuthenticationVC.h"
#import "IncomeStatisticsVC.h"
#import "OfferDetailsVC.h"
#import "IncomeWithdrawVC.h"
#import "BindBankCardVC.h"
#import "WXLoginVC.h"
#import "BindPhoneNumVC.h"
#import "ModifyPhoneNumVC.h"
#import "SalesStatisticsVC.h"
#import "NewCustomerVC.h"
#import "OrderDetailWebVC.h"
#import "UserDetailVC.h"
#import "QuickQuoteVC.h"
#import "InsuredUserInfoEditVC.h"
#import "EditInsuredUserInfoVC.h"
#import "ProductDetailWebVC.h"
#import "PrivateMsgVC.h"
#import "AutoInsuranceStep1VC.h"
#import "OurProductDetailVC.h"

@interface IBUIFactory : NSObject

+ (WebViewController *) CreateWebViewController;

+ (loginViewController *) CreateLoginViewController;

+ (CustomerDetailVC *) CreateCustomerDetailViewController;

+ (UserInfoEditVC *) CreateUserInfoEditViewController;

+ (EditTagVC *) CreateEditTagViewController;

+ (TagListViewController *) CreateTagListViewController;

+ (CustomerInfoEditVC *) CreateCustomerInfoEditViewController;

+ (AddFollowUpVC *) CreateAddFollowUpViewController;

+ (AutoInsuranceInfoEditVC *) CreateAutoInsuranceInfoEditViewController;

+ (QRCodeVC *) CreateQRCodeViewController;

+ (RealNameAuthenticationVC *) CreateRealNameAuthenticationViewController;

+ (IncomeStatisticsVC *) CreateIncomeStatisticsViewController;

+ (OfferDetailsVC *) CreateOfferDetailsViewController;

+ (IncomeWithdrawVC *) CreateIncomeWithdrawViewController;

+ (BindBankCardVC *) CreateBindBankCardViewController;

+ (WXLoginVC *) CreateWXLoginViewController;

+ (BindPhoneNumVC *) CreateBindPhoneNumViewController;

+ (ModifyPhoneNumVC *) CreateModifyPhoneNumViewController;

+ (SalesStatisticsVC *) CreateSalesStatisticsViewController;

+ (NewCustomerVC *) CreateNewCustomerViewController;

+ (OrderDetailWebVC *) CreateOrderDetailWebVC;

+ (UserDetailVC *) CreateUserDetailVC;

+ (QuickQuoteVC *) CreateQuickQuoteVC;

+ (InsuredUserInfoEditVC *) CreateInsuredUserInfoEditVC;

+ (EditInsuredUserInfoVC *) CreateEditInsuredUserInfoVC;

+ (ProductDetailWebVC *) CreateProductDetailWebVC;

+ (PrivateMsgVC *) CreatePrivateMsgVC;

+ (AutoInsuranceStep1VC *) CreateAutoInsuranceStep1VC;

//+ (MotorcycleTypeSelectedVC *) CreateMotorcycleTypeSelectedVC;

//自有非车险
+ (OurProductDetailVC *) CreateOurProductDetailVC;

@end
