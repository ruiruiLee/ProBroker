//
//  NetWorkHandler+register.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/9/13.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (register1)

+ (void) requestToRegister:(NSString *) teamLeaderPhone
                     phone:(NSString *) phone
                   smsCode:(NSString *)smsCode
                  userName:(NSString *)userName
                    action:(NSString *)action
                Completion:(Completion)completion;

@end
