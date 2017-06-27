//
//  NetWorkHandler+VerifySMSCode.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/27.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+VerifySMSCode.h"
#import "define.h"

@implementation NetWorkHandler (VerifySMSCode)

+ (void) requestToVerifySMSCode:(NSString *) phone  smsCode:(NSString *) smsCode Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:phone key:@"phone"];
    [Util setValueForKeyWithDic:pramas value:smsCode key:@"smsCode"];
    
    [handle postWithMethod:@"/api/sms/verify" BaseUrl:SERVER_ADDRESS Params:pramas Completion:completion];
}

@end
