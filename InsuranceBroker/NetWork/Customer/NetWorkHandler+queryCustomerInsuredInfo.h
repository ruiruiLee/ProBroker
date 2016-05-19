//
//  NetWorkHandler+queryCustomerInsuredInfo.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (queryCustomerInsuredInfo)

+ (void) requestToQueryCustomerInsuredInfoInsuredId:(NSString *) insuredId
                                     Completion:(Completion)completion;

@end
