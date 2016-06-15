//
//  NetWorkHandler+newUser.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/6/14.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+newUser.h"
#import "define.h"

@implementation NetWorkHandler (newUser)

+ (void) requestToRequestNewUser:(NSString *) userId nickName:(NSString *) nickName Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
    [Util setValueForKeyWithDic:pramas value:nickName key:@"nickName"];
    
    [handle postWithMethod:@"/api/news/notice/newUser" BaseUrl:SERVER_ADDRESS Params:pramas Completion:completion];
}

@end
