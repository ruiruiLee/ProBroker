//
//  NetWorkHandler+queryForCustomerInsurPageList.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/11.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+queryForCustomerInsurPageList.h"
#import "define.h"

@implementation NetWorkHandler (queryForCustomerInsurPageList)

+ (void) requestToQueryForCustomerInsurPageList:(NSString *) insuranceType
                                         offset:(NSInteger) offset
                                          limit:(NSInteger) limit
                                           sord:(NSString *) sord
                                        filters:(NSDictionary *) filters
                                     gxbzStatus:(NSString *) gxbzStatus
                                     Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:insuranceType key:@"insuranceType"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInteger:offset] key:@"offset"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInteger:limit] key:@"limit"];
    [Util setValueForKeyWithDic:pramas value:[NetWorkHandler objectToJson:filters] key:@"filters"];
    [Util setValueForKeyWithDic:pramas value:@"P_InsuranceOrders.updatedAt" key:@"sidx"];
    [Util setValueForKeyWithDic:pramas value:gxbzStatus key:@"gxbzStatus"];
    [Util setValueForKeyWithDic:pramas value:sord key:@"sord"];
    
    [handle postWithMethod:@"/web/insurance/queryForInsurancePageList.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
