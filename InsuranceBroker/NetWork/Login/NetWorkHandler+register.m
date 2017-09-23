//
//  NetWorkHandler+register.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/9/13.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+register.h"
#import "define.h"

@implementation NetWorkHandler (register1)

+ (void) requestToRegister:(NSString *) teamLeaderPhone
                     phone:(NSString *) phone
                   smsCode:(NSString *)smsCode
                  userName:(NSString *)userName
                    action:(NSString *)action
                Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:phone key:@"phone"];
    [Util setValueForKeyWithDic:pramas value:smsCode key:@"smsCode"];
    [Util setValueForKeyWithDic:pramas value:teamLeaderPhone key:@"teamLeaderPhone"];
    [Util setValueForKeyWithDic:pramas value:userName key:@"userName"];
    [Util setValueForKeyWithDic:pramas value:action key:@"action"];
    
    [handle postWithMethod:@"/api/user/login" BaseUrl:SERVER_ADDRESS Params:pramas Completion:completion];
}

@end
