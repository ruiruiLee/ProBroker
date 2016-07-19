//
//  NetWorkHandler+insurancePay.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/7/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

/**
 orderId:"xxxxxxxxxxxxxxxx"//uuid（管理后台或代为投保传递orderId）
 id:"xxxxxxxxxxxxxxxx"//shareId（其它情况传递分享ID）
 insuranceType:"1"
 planOfferId:"1"//方案报价ID
 payType:"1"//1货到付款，2微信支付，3支付宝
 isManager:"1"//管理后台传1，其它渠道不传值
 helpInsure:"1"//是否代为投保；0不是，1是，2第三方投保
 */

#import "NetWorkHandler.h"

@interface NetWorkHandler (insurancePay)

+ (void) requestToInsurancePay:(NSString *) orderId insuranceType:(NSString *) insuranceType planOfferId:(NSString *) planOfferId payType:(NSString *) payType helpInsure:(NSString *) helpInsure Completion:(Completion)completion;

@end
