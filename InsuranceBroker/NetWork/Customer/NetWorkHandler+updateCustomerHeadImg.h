//
//  NetWorkHandler+updateCustomerHeadImg.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/22.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (updateCustomerHeadImg)

+ (void) requestToUpdateCustomerHeadImg:(NSString *)customerId headImg:(NSString *) headImg Completion:(Completion)completion;

@end
