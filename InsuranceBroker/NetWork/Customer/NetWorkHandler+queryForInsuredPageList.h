//
//  NetWorkHandler+queryForInsuredPageList.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/17.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (queryForInsuredPageList)

+ (void) requestToQueryForInsuredPageListOffset:(NSInteger) offset
                                          limit:(NSInteger) limit
                                        filters:(NSDictionary *) filters
                                     customerId:(NSString *) customerId
                                     Completion:(Completion)completion;

@end
