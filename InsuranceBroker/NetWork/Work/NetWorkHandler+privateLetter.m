//
//  NetWorkHandler+privateLetter.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+privateLetter.h"
#import "define.h"

@implementation NetWorkHandler (privateLetter)

+ (void) requestToPostPrivateLetter:(NSString *) userId
                              title:(NSString *) title
                            content:(NSString *) content
                           senderId:(NSString *) senderId
                         senderName:(NSString *) senderName
                         Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
    [Util setValueForKeyWithDic:pramas value:title key:@"title"];
    [Util setValueForKeyWithDic:pramas value:content key:@"content"];
    [Util setValueForKeyWithDic:pramas value:senderId key:@"senderId"];
    [Util setValueForKeyWithDic:pramas value:senderName key:@"senderName"];
    
    [handle postWithMethod:@"/api/news/privateLetter" BaseUrl:SERVER_ADDRESS Params:pramas Completion:completion];
}

@end
