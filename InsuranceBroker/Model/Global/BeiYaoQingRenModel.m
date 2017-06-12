//
//  BeiYaoQingRenModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/12.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "BeiYaoQingRenModel.h"

@implementation BeiYaoQingRenModel

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[BeiYaoQingRenModel modelFromDictionary:dic]];
    }
    
    return result;
}

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    BeiYaoQingRenModel *model = [[BeiYaoQingRenModel alloc] init];
    
    model.userId = [dictionary objectForKey:@"userId"];
    model.realName = [dictionary objectForKey:@"realName"];
    model.phone = [dictionary objectForKey:@"phone"];
    model.createdAt = [dictionary objectForKey:@"createdAt"];
    model.headerImg = [dictionary objectForKey:@"headerImg"];
    
    return model;
}

@end
