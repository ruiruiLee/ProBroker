//
//  NetWorkHandler+querySpecialtyUserInfo.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/19.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (querySpecialtyUserInfo)

+ (void) requestToQuerySpecialtyUserInfo:(NSString *) userId Completion:(Completion)completion;

@end
