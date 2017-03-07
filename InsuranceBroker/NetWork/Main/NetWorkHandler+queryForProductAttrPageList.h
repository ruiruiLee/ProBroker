//
//  NetWorkHandler+queryForProductAttrPageList.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/22.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (queryForProductAttrPageList)

- (void) requestToQueryForProductAttrPageList:(NSInteger) offset
                                        limit:(NSInteger) limit
                                      filters:(NSDictionary *) filters
                                       userId:(NSString *) userId
                                         uuid:(NSString *) uuid
                                insuranceType:(NSString *) insuranceType
                                   completion:(Completion)completion;

@end
