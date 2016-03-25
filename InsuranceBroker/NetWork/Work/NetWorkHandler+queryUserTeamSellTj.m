//
//  NetWorkHandler+queryUserTeamSellTj.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+queryUserTeamSellTj.h"
#import "define.h"

@implementation NetWorkHandler (queryUserTeamSellTj)

+ (void) requestToQueryUserTeamSellTj:(NSString *) userId Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
    
    [handle postWithMethod:@"/web/user/queryUserTeamSellTj.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
