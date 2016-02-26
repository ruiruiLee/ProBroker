//
//  NetWorkHandler+queryUserTeamInfo.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+queryUserTeamInfo.h"
#import "define.h"

@implementation NetWorkHandler (queryUserTeamInfo)

+ (void) requestToQueryUserTeamInfo:(NSString *) userId Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
    
    [handle postWithMethod:@"/web/user/queryUserTeamInfo.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
