//
//  NetWorkHandler+queryCustomerInsuredInfo.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+queryCustomerInsuredInfo.h"
#import "define.h"

@implementation NetWorkHandler (queryCustomerInsuredInfo)

+ (void) requestToQueryCustomerInsuredInfoInsuredId:(NSString *) insuredId
                                         Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:insuredId key:@"insuredId"];
    
    [handle postWithMethod:@"/web/customer/queryCustomerInsuredInfo.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
