//
//  NetWorkHandler+querySpecialtyUserInfo.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/19.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+querySpecialtyUserInfo.h"
#import "define.h"

@implementation NetWorkHandler (querySpecialtyUserInfo)

+ (void) requestToQuerySpecialtyUserInfo:(NSString *) userId Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
    
    
    [handle postWithMethod:@"/web/specialty/querySpecialtyUserInfo.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
