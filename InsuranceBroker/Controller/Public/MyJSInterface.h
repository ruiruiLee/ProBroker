//
//  MyJSInterface.h
//  EasyJSWebViewSample
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyJSDataFunction.h"

@protocol MyJSInterfaceDelegate <NSObject>

- (void) NotifyCloseWindow;//关闭窗口，车险下单使用
- (void) NotifyShareWindowWithPrama:(NSDictionary *) dic;//分享按钮点击试用
- (void) NotifyToReSubmitCarInfo:(NSString *) orderId customerId:(NSString *) customerId customerCarId:(NSString *) customerCarId;
- (void) NotifyToSelectCustomer;//获取用户信息
- (void) NotifyToSelectInsured;//获取被保人信息
- (void) NotifyToInitCustomerInfo;//初始化数据
- (void) NotifyToSelectCustomerForCar:(NSString *) productAttrId;
- (void) NotifyToPay:(NSString *) orderId insuranceType:(NSString *) insuranceType planOfferId:(NSString *) planOfferId titleName:(NSString *) titleName totalFee:(NSString *) totalFee;
- (void) NotifyWebCanReturnPrev:(BOOL) flag;

@end

@interface MyJSInterface : NSObject

@property (nonatomic, assign) id<MyJSInterfaceDelegate> delegate;

- (void) close;

- (void) shareUrl;

- (void) shareUrl:(NSString *) pramas;

- (void) againParamsMap:(NSDictionary *) pramas;

- (void) selectCustomer;//客户

- (void) selectInsured;//被保人

- (void) initCustomer;//数据初始化

- (void) callInsurance:(NSString *) productAttrId;//车险

- (void) pay:(NSString *) pramas;//付款

- (void) canGoBack:(BOOL) flag;//是否允许返回上一节web页面

@end
