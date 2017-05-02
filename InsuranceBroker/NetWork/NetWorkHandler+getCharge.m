//
//  NetWorkHandler+getCharge.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/4/24.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+getCharge.h"
#import "define.h"

@implementation NetWorkHandler (getCharge)

+ (void) requestToGetCharge:(NSString *)channel
                     amount:(NSString *) amount
                    orderNo:(NSString *) orderNo
                productDesc:(NSString *) productDesc
                productName:(NSString *) productName
                 systemName:(NSString *) systemName
                 Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:channel key:@"channel"];
    [Util setValueForKeyWithDic:pramas value:amount key:@"amount"];
    [Util setValueForKeyWithDic:pramas value:orderNo key:@"orderId"];
    [Util setValueForKeyWithDic:pramas value:productDesc key:@"productDesc"];
    [Util setValueForKeyWithDic:pramas value:productName key:@"productName"];
    [Util setValueForKeyWithDic:pramas value:systemName key:@"businessModule"];
    
    [handle postWithMethod:@"/web/pay/getCharge.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
