//
//  NetWorkHandler+updateCustomerHeadImg.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/22.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+updateCustomerHeadImg.h"
#import "define.h"

@implementation NetWorkHandler (updateCustomerHeadImg)

+ (void) requestToUpdateCustomerHeadImg:(NSString *)customerId headImg:(NSString *) headImg Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    
    [Util setValueForKeyWithDic:pramas value:customerId key:@"customerId"];
    [Util setValueForKeyWithDic:pramas value:headImg key:@"headImg"];
    
    [handle postWithMethod:@"web/customer/updateCustomerHeadImg.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
