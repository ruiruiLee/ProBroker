//
//  NetWorkHandler+queryForInsuredPageList.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/17.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+queryForInsuredPageList.h"
#import "define.h"

@implementation NetWorkHandler (queryForInsuredPageList)

+ (void) requestToQueryForInsuredPageListOffset:(NSInteger) offset
                                          limit:(NSInteger) limit
                                        filters:(NSDictionary *) filters
                                     customerId:(NSString *) customerId
                                     Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInteger:offset] key:@"offset"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInteger:limit] key:@"limit"];
//    [Util setValueForKeyWithDic:pramas value:[NetWorkHandler objectToJson:filters] key:@"filters"];
    [Util setValueForKeyWithDic:pramas value:customerId key:@"customerId"];
    
    [handle postWithMethod:@"/web/customer/queryForInsuredPageList.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
