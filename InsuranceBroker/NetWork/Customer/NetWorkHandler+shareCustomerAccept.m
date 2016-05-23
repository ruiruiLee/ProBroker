//
//  NetWorkHandler+shareCustomerAccept.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/20.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+shareCustomerAccept.h"
#import "define.h"

@implementation NetWorkHandler (shareCustomerAccept)

+ (void) requestToAcceptCustomer:(NSString *) objectId Completion:(Completion)completion;
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:objectId key:@"objectId"];
    
    [handle postWithMethod:@"/api/customer/share/customer/accept" BaseUrl:SERVER_ADDRESS Params:pramas Completion:completion];
}

@end
