//
//  PayConfDataModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/7/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "PayConfDataModel.h"

@implementation PayConfDataModel

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    PayConfDataModel *model = [[PayConfDataModel alloc] init];
    
    model.deviceType = [[dictionary objectForKey:@"deviceType"] integerValue];
    model.orderNo = [dictionary objectForKey:@"orderNo"];
    model.payDefault = [dictionary objectForKey:@"payDefault"];
    model.payId = [dictionary objectForKey:@"payId"];
    model.payIntro = [dictionary objectForKey:@"payIntro"];
    model.payLogo = [dictionary objectForKey:@"payLogo"];
    model.payName = [dictionary objectForKey:@"payName"];
    model.payStatus = [[dictionary objectForKey:@"payStatus"] integerValue];
    model.payConfType = [[dictionary objectForKey:@"payConfType"] integerValue];
    model.payValue = [dictionary objectForKey:@"payValue"];
    
    return model;
}

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[PayConfDataModel modelFromDictionary:dic]];
    }
    
    return result;
}

@end
