//
//  NetWorkHandler+setSpecialtyUserProductRatio.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/19.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+setSpecialtyUserProductRatio.h"
#import "define.h"

@implementation NetWorkHandler (setSpecialtyUserProductRatio)

+ (void) requestToSetSpecialtyUserProductRatio:(NSString *) userId productId:(NSString *) productId productRatio:(CGFloat) productRatio Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
    [Util setValueForKeyWithDic:pramas value:productId key:@"productId"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithFloat:productRatio] key:@"productRatio"];
    
    
    [handle postWithMethod:@"/web/specialty/setSpecialtyUserProductRatio.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
