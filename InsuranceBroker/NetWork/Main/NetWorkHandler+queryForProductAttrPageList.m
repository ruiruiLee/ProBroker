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
                                         sidx:(NSString *) sidx
                                         sord:(NSString *) sord
                                      filters:(NSDictionary *) filters
                                   completion:(Completion)completion
{
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInt:offset] key:@"offset"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInt:limit] key:@"limit"];
    [Util setValueForKeyWithDic:pramas value:sord key:@"sord"];
    [Util setValueForKeyWithDic:pramas value:sidx key:@"sidx"];
    
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *filtersStr = [writer stringWithObject:filters];
    
    [Util setValueForKeyWithDic:pramas value:filtersStr key:@"filters"];
    
    [self postWithMethod:@"/web/insurance/queryForProductAttrPageList.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
