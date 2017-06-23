//
//  NetWorkHandler+queryBeiYaoQingRen.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/12.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (queryBeiYaoQingRen)

+ (void) requestToQueryBeiYaoQingRen:(NSString *) uuid offset:(NSInteger) offset limit:(NSInteger) limit keyValue:(NSString *)keyValue Completion:(Completion)completion;

@end
