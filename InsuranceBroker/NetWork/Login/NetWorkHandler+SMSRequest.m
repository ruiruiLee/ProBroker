//
//  NetWorkHandler+SMSRequest.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/27.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+SMSRequest.h"
#import "define.h"

@implementation NetWorkHandler (SMSRequest)

+ (void) requestToShortMsg:(NSString *) phone
                  template:(NSString *) temp
                      sign:(NSString *) sign
                     other:(NSString *) other
                Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:phone key:@"phone"];
    [Util setValueForKeyWithDic:pramas value:temp key:@"temp"];
    [Util setValueForKeyWithDic:pramas value:sign key:@"sign"];
    [Util setValueForKeyWithDic:pramas value:other key:@"other"];
    
    [handle postWithMethod:@"/api/sms/send" BaseUrl:SERVER_ADDRESS Params:pramas Completion:completion];
}

@end
