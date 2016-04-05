//
//  NetWorkHandler+queryForProductList.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/1.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (queryForProductList)

+ (void) requestToQueryForProductList:(NSString *) insuranceType
                                    Completion:(Completion)completion;

@end
