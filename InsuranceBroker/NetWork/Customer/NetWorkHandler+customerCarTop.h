//
//  NetWorkHandler+customerCarTop.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/9/14.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (customerCarTop)

+ (void) requestToQueueCustomerCarTop:(NSString *) customerCarId Completion:(Completion)completion;

@end
