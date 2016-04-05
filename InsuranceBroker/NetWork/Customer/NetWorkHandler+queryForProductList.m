//
//  NetWorkHandler+queryForProductList.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/1.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+queryForProductList.h"
#import "define.h"

@implementation NetWorkHandler (queryForProductList)

+ (void) requestToQueryForProductList:(NSString *) insuranceType
                           Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    
    [Util setValueForKeyWithDic:pramas value:insuranceType key:@"insuranceType"];
    
    [handle postWithMethod:@"/web/insurance/queryForProductList.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
