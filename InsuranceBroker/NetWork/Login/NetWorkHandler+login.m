//
//  NetWorkHandler+login.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/3.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+login.h"
#import "define.h"

@implementation NetWorkHandler (login)

+ (void) loginWithPhone:(NSString *)phone
                 openId:(NSString *)openId
                    sex:(NSInteger) sex
               nickname:(NSString *)nickname
              privilege:(NSArray *)privilege
                unionid:(NSString*)unionid
               province:(NSString*)province
               language:(NSString*)language
             headimgurl:(NSString *)headimgurl
                   city:(NSString *)city
                country:(NSString *)country
                 smCode:(NSString *)smCode
             Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:params value:phone key:@"phone"];
    [Util setValueForKeyWithDic:params value:openId key:@"openid"];
    [Util setValueForKeyWithDic:params value:[NSNumber numberWithInteger:sex] key:@"sex"];
    [Util setValueForKeyWithDic:params value:nickname key:@"nickname"];
    [Util setValueForKeyWithDic:params value:privilege key:@"privilege"];
    [Util setValueForKeyWithDic:params value:unionid key:@"unionid"];
    [Util setValueForKeyWithDic:params value:province key:@"province"];
    [Util setValueForKeyWithDic:params value:language key:@"language"];
    [Util setValueForKeyWithDic:params value:headimgurl key:@"headimgurl"];
    [Util setValueForKeyWithDic:params value:city key:@"city"];
    [Util setValueForKeyWithDic:params value:country key:@"country"];
    [Util setValueForKeyWithDic:params value:smCode key:@"smsCode"];
    [Util setValueForKeyWithDic:params value:@"H5" key:@"codeDemo"];
    
    [handle postWithMethod:@"/api/user/login" BaseUrl:SERVER_ADDRESS Params:params Completion:completion];
}

+ (void) loginWithPhone:(NSString *)phone
                 openId:(NSString *)openId
                    sex:(NSInteger) sex
               nickname:(NSString *)nickname
              privilege:(NSArray *)privilege
                unionid:(NSString*)unionid
               province:(NSString*)province
               language:(NSString*)language
             headimgurl:(NSString *)headimgurl
                   city:(NSString *)city
                country:(NSString *)country
                 smCode:(NSString *)smCode
            parentPhone:(NSString *)parentPhone
             Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:params value:phone key:@"phone"];
    [Util setValueForKeyWithDic:params value:openId key:@"openid"];
    [Util setValueForKeyWithDic:params value:[NSNumber numberWithInteger:sex] key:@"sex"];
    [Util setValueForKeyWithDic:params value:nickname key:@"nickname"];
    [Util setValueForKeyWithDic:params value:privilege key:@"privilege"];
    [Util setValueForKeyWithDic:params value:unionid key:@"unionid"];
    [Util setValueForKeyWithDic:params value:province key:@"province"];
    [Util setValueForKeyWithDic:params value:language key:@"language"];
    [Util setValueForKeyWithDic:params value:headimgurl key:@"headimgurl"];
    [Util setValueForKeyWithDic:params value:city key:@"city"];
    [Util setValueForKeyWithDic:params value:country key:@"country"];
    [Util setValueForKeyWithDic:params value:smCode key:@"smsCode"];
//    [Util setValueForKeyWithDic:params value:Default_User_Type key:@"userType"];
    [Util setValueForKeyWithDic:params value:parentPhone key:@"parentPhone"];
    [Util setValueForKeyWithDic:params value:@"H5" key:@"codeDemo"];
    
    [handle postWithMethod:@"/api/user/login" BaseUrl:SERVER_ADDRESS Params:params Completion:completion];
}

@end
