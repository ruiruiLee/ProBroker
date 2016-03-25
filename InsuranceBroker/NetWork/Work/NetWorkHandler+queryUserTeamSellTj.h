//
//  NetWorkHandler+queryUserTeamSellTj.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (queryUserTeamSellTj)

+ (void) requestToQueryUserTeamSellTj:(NSString *) userId Completion:(Completion)completion;

@end
