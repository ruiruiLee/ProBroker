//
//  NetWorkHandler+queryPayConfList.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/7/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+queryPayConfList.h"
#import "define.h"

@implementation NetWorkHandler (queryPayConfList)

+ (void) requestToQueryPayConfList:(NSInteger) payStatus payConfType:(NSString *) payConfType deviceType:(NSString *) deviceType Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:payConfType key:@"payConfType"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInt:payStatus] key:@"payStatus"];
    
    [handle postWithMethod:@"/web/common/queryPayConfList.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
