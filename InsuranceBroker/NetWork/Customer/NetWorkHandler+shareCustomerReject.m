//
//  NetWorkHandler+shareCustomerReject.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/20.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+shareCustomerReject.h"
#import "define.h"

@implementation NetWorkHandler (shareCustomerReject)

+ (void) requestToRejectCustomer:(NSString *) objectId Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:objectId key:@"objectId"];
    
    [handle postWithMethod:@"/api/customer/share/customer/reject" BaseUrl:SERVER_ADDRESS Params:pramas Completion:completion];
}

@end
