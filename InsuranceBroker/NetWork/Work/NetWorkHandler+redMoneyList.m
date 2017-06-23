//
//  NetWorkHandler+redMoneyList.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/16.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+redMoneyList.h"
#import "define.h"
#import "Util.h"

@implementation NetWorkHandler (redMoneyList)

+ (void) requestToRedMoneyList:(NSString *) userId
                     isManager:(BOOL) isManager
                        offset:(NSInteger) offset
                         limit:(NSInteger) limit
                      keyValue:(NSString *)keyValue
                          memo:(NSString *) memo
                     orderUuId:(NSString *) orderUuId
                       orderNo:(NSString *)orderNo
                         carNo:(NSString *)carNo
                       orderBy:(NSString *) orderBy
                    Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithBool:isManager] key:@"isManager"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInteger:offset] key:@"offset"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInteger:limit] key:@"limit"];
    [Util setValueForKeyWithDic:pramas value:keyValue key:@"keyValue"];
    [Util setValueForKeyWithDic:pramas value:memo key:@"memo"];
    [Util setValueForKeyWithDic:pramas value:orderUuId key:@"orderUuId"];
    [Util setValueForKeyWithDic:pramas value:orderNo key:@"orderNo"];
    [Util setValueForKeyWithDic:pramas value:carNo key:@"carNo"];
    [Util setValueForKeyWithDic:pramas value:orderBy key:@"orderBy"];
    
    [handle postWithMethod:@"/web/promotion/redMoneyList.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
