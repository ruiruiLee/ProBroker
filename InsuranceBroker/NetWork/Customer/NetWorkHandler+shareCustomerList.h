//
//  NetWorkHandler+shareCustomerList.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/20.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (shareCustomerList)

+ (void) requestToShareCustomerList:(NSString *) userId Completion:(Completion)completion;

@end
