//
//  NetWorkHandler+updateUserRemarkName.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (updateUserRemarkName)

+ (void) requestToUpdateUserRemarkName:(NSString *) userId remarkName:(NSString *) remarkName Completion:(Completion)completion;

@end
