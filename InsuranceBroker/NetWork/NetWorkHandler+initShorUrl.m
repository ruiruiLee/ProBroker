//
//  NetWorkHandler+initShorUrl.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/5.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+initShorUrl.h"
#import "define.h"

@implementation NetWorkHandler (initShorUrl)

+ (void) requestToInitShorUrl:(NSString *) url Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:url key:@"longurl"];
    
    [handle postWithMethod:@"/web/common/initShorUrl.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
