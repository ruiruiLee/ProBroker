//
//  NetWorkHandler+updateUserRemarkName.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+updateUserRemarkName.h"
#import "define.h"

@implementation NetWorkHandler (updateUserRemarkName)


+ (void) requestToUpdateUserRemarkName:(NSString *) userId remarkName:(NSString *) remarkName Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:remarkName key:@"remarkName"];
    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
    
    [handle postWithMethod:@"/web/user/updateUserRemarkName.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
