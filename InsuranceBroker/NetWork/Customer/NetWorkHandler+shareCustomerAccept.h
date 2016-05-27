//
//  NetWorkHandler+shareCustomerAccept.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/20.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (shareCustomerAccept)

+ (void) requestToAcceptCustomer:(NSString *) objectId Completion:(Completion)completion;

@end