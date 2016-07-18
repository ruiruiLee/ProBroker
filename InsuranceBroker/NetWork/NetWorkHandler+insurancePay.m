//
//  NetWorkHandler+insurancePay.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/7/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+insurancePay.h"
#import "define.h"

@implementation NetWorkHandler (insurancePay)

+ (void) requestToInsurancePay:(NSString *) orderId insuranceType:(NSString *) insuranceType planOfferId:(NSString *) planOfferId payType:(NSString *) payType helpInsure:(NSString *) helpInsure Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:orderId key:@"orderId"];
    [Util setValueForKeyWithDic:pramas value:insuranceType key:@"insuranceType"];
    [Util setValueForKeyWithDic:pramas value:planOfferId key:@"planOfferId"];
    [Util setValueForKeyWithDic:pramas value:payType key:@"payType"];
    [Util setValueForKeyWithDic:pramas value:helpInsure key:@"helpInsure"];
    
    [handle postWithMethod:@"/web/pay/insurancePay.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
