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
                                         sidx:(NSString *) sidx
                                         sord:(NSString *) sord
                                      filters:(NSDictionary *) filters
                                        userId:(NSString *) userId
                                insuranceType:(NSString*) insuranceType
                                   completion:(Completion)completion;

@end
