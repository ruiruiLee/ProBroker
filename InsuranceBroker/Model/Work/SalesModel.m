//
//  SalesModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/4.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "SalesModel.h"

@implementation SalesModel

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[SalesModel modelFromDictionary:dic]];
    }
    
    return result;
}

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    SalesModel *model = [[SalesModel alloc] init];
    
    model.dayStr = [dictionary objectForKey:@"dayStr"];
//    model.dayOrderTotalSellEarn = [[dictionary objectForKey:@"dayOrderTotalSellEarn"] floatValue];
    model.dayStr_ = [dictionary objectForKey:@"dayStr_"];
    model.car_day_zcgddbf = [[dictionary objectForKey:@"car_day_zcgddbf"] doubleValue];
    model.day_zcgddbf = [[dictionary objectForKey:@"day_zcgddbf"] doubleValue];
    model.nocar_day_zcgddbf = [[dictionary objectForKey:@"nocar_day_zcgddbf"] doubleValue];
    
    return model;
}

@end
