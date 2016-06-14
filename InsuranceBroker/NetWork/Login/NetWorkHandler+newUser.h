//
//  NetWorkHandler+newUser.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/6/14.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (newUser)

+ (void) requestToRequestNewUser:(NSString *) userId Completion:(Completion)completion;

@end
