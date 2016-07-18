//
//  NetWorkHandler+InitWechatConfig.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/7/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+InitWechatConfig.h"
#import "define.h"

@implementation NetWorkHandler (InitWechatConfig)

+ (void) requestToInitWechatConfig:(NSString *) initType
                      payOrderType:(NSInteger) payOrderType
                        outTradeNo:(NSString *) outTradeNo
                            openId:(NSString *) openId
                          totalFee:(NSString *) totalFee
                              body:(NSString *) body
                           baseUrl:(NSString *) baseUrl
                        Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:initType key:@"initType"];
    [Util setValueForKeyWithDic:pramas value:body key:@"body"];
    [Util setValueForKeyWithDic:pramas value:totalFee key:@"totalFee"];
    [Util setValueForKeyWithDic:pramas value:openId key:@"openId"];
    [Util setValueForKeyWithDic:pramas value:outTradeNo key:@"outTradeNo"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInt:payOrderType] key:@"payOrderType"];
    
    [handle postWithMethod:baseUrl BaseUrl:@"" Params:pramas Completion:completion];
}

@end
