//
//  NetWorkHandler+customerCarTop.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/9/14.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+customerCarTop.h"
#import "define.h"

@implementation NetWorkHandler (customerCarTop)

+ (void) requestToQueueCustomerCarTop:(NSString *) customerCarId Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:customerCarId key:@"customerCarId"];
    
    [handle postWithMethod:@"/web/customer/customerCarTop.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];

}

@end
