//
//  NetWorkHandler+queryForProductAttrPageList.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/22.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+queryForProductAttrPageList.h"
#import "define.h"
#import "SBJson.h"

@implementation NetWorkHandler (queryForProductAttrPageList)

- (void) requestToQueryForProductAttrPageList:(NSInteger) offset
                                        limit:(NSInteger) limit
                                      filters:(NSDictionary *) filters
                                       userId:(NSString *) userId
                                         uuid:(NSString *) uuid
                                insuranceType:(NSString *) insuranceType
                                   completion:(Completion)completion
{
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInteger:offset] key:@"offset"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInteger:limit] key:@"limit"];
    [Util setValueForKeyWithDic:pramas value:uuid key:@"uuid"];
    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
    [Util setValueForKeyWithDic:pramas value:insuranceType key:@"insuranceType"];
    
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *filtersStr = [writer stringWithObject:filters];
    
    [Util setValueForKeyWithDic:pramas value:filtersStr key:@"filters"];
    
    [self postWithMethod:@"/web/insurance/queryForProductAttrPageList.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
