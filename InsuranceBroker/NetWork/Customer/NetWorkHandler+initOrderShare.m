//
//  NetWorkHandler+initOrderShare.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/21.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+initOrderShare.h"
#import "define.h"

@implementation NetWorkHandler (initOrderShare)

+ (void) requestToInitOrderShare:(NSString *) orderId Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    
    [Util setValueForKeyWithDic:pramas value:orderId key:@"orderId"];
    
    [handle postWithMethod:@"/web/insurance/initOrderShare.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
