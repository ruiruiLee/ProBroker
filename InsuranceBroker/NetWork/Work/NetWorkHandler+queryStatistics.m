//
//  NetWorkHandler+queryStatistics.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/22.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+queryStatistics.h"
#import "define.h"

@implementation NetWorkHandler (queryStatistics)

//+ (void) requestToQueryStatistics:(NSString *)userId Completion:(Completion)completion
//{
//    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
//    
//    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
//    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
//    
//    [handle postWithMethod:@"/web/statistics/queryStatistics.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
//}
//
//+ (void) requestToQueryStatistics:(NSString *)userId staticsType:(NSString *) staticsType Completion:(Completion)completion
//{
//    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
//    
//    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
//    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
//    [Util setValueForKeyWithDic:pramas value:staticsType key:@"statisticsType"];
//    
//    [handle postWithMethod:@"/web/statistics/queryStatistics.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
//}

+ (void) requestToQueryStatistics:(NSString *)userId
                    monthPieChart:(NSString *) monthPieChart
                  curveEarn6Month:(NSString *) curveEarn6Month
                   curveSell30Day:(NSString *) curveSell30Day
                  curveSell6Month:(NSString *) curveSell6Month
                       Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
    [Util setValueForKeyWithDic:pramas value:monthPieChart key:@"monthPieChart"];
    [Util setValueForKeyWithDic:pramas value:curveEarn6Month key:@"curveEarn6Month"];
    [Util setValueForKeyWithDic:pramas value:curveSell30Day key:@"curveSell30Day"];
    [Util setValueForKeyWithDic:pramas value:curveSell6Month key:@"curveSell6Month"];
    
    [handle postWithMethod:@"/web/statistics/queryStatistics.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
