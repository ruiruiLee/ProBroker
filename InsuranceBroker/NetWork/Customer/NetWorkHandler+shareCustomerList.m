//
//  NetWorkHandler+shareCustomerList.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/20.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+shareCustomerList.h"
#import "define.h"

@implementation NetWorkHandler (shareCustomerList)

+ (void) requestToShareCustomerList:(NSString *) userId Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
    [Util setValueForKeyWithDic:pramas value:@"4" key:@"appType"];
    
    [handle postWithMethod:@"/api/customer/share/customer/list" BaseUrl:SERVER_ADDRESS Params:pramas Completion:completion];
}

@end
