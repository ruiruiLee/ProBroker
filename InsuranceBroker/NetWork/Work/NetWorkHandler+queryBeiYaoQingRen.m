//
//  NetWorkHandler+queryBeiYaoQingRen.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/12.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+queryBeiYaoQingRen.h"
#import "define.h"

@implementation NetWorkHandler (queryBeiYaoQingRen)

+ (void) requestToQueryBeiYaoQingRen:(NSString *) uuid offset:(NSInteger) offset limit:(NSInteger) limit keyValue:(NSString *)keyValue Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:uuid key:@"uuid"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInteger:offset] key:@"offset"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInteger:limit] key:@"limit"];
    [Util setValueForKeyWithDic:pramas value:keyValue key:@"keyValue"];
    
    [handle postWithMethod:@"/web/user/queryBeiYaoQingRen.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
