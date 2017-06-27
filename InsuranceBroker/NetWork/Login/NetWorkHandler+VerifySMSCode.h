//
//  NetWorkHandler+VerifySMSCode.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/27.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (VerifySMSCode)

+ (void) requestToVerifySMSCode:(NSString *) phone  smsCode:(NSString *) smsCode Completion:(Completion)completion;

@end
