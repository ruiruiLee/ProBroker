//
//  NetWorkHandler+queryUserTeamInfo.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (queryUserTeamInfo)

+ (void) requestToQueryUserTeamInfo:(NSString *) userId Completion:(Completion)completion;

@end
