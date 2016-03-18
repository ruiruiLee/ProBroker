//
//  NetWorkHandler+queryStatistics.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/22.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (queryStatistics)

//+ (void) requestToQueryStatistics:(NSString *)userId Completion:(Completion)completion;
+ (void) requestToQueryStatistics:(NSString *)userId
                    monthPieChart:(NSString *) monthPieChart
                  curveEarn6Month:(NSString *) curveEarn6Month
                   curveSell30Day:(NSString *) curveSell30Day
                  curveSell6Month:(NSString *) curveSell6Month
                       Completion:(Completion)completion;

@end
