//
//  NetWorkHandler+redMoneyList.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/16.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (redMoneyList)

+ (void) requestToRedMoneyList:(NSString *) userId
                     isManager:(BOOL) isManager
                        offset:(NSInteger) offset
                         limit:(NSInteger) limit
                      keyValue:(NSString *)keyValue
                          memo:(NSString *) memo
                     orderUuId:(NSString *) orderUuId
                       orderNo:(NSString *)orderNo
                         carNo:(NSString *)carNo
                       orderBy:(NSString *) orderBy
                    Completion:(Completion)completion;

@end
