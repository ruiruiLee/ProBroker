//
//  CurveSellModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "CurveSellModel.h"

@implementation CurveSellModel

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[CurveSellModel modelFromDictionary:dic]];
    }
    
    return result;
}

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    CurveSellModel *model = [[CurveSellModel alloc] init];
    
    model.monthStr = [dictionary objectForKey:@"monthStr"];
    model.monthStr_ = [dictionary objectForKey:@"monthStr_"];
    model.car_month_zcgddbf = [[dictionary objectForKey:@"car_month_zcgddbf"] doubleValue];
    model.car_month_zcgdds = [[dictionary objectForKey:@"car_month_zcgdds"] longLongValue];
    model.car_month_zcgddsy = [[dictionary objectForKey:@"car_month_zcgddsy"] doubleValue];
    model.month_zcgddbf = [[dictionary objectForKey:@"month_zcgddbf"] doubleValue];
    model.month_zcgdds = [[dictionary objectForKey:@"month_zcgdds"] longLongValue];
    model.month_zcgddsy = [[dictionary objectForKey:@"month_zcgddsy"] doubleValue];
    model.nocar_month_zcgddbf = [[dictionary objectForKey:@"nocar_month_zcgddbf"] doubleValue];
    model.nocar_month_zcgdds = [[dictionary objectForKey:@"nocar_month_zcgdds"] longLongValue];
    model.nocar_month_zcgddsy = [[dictionary objectForKey:@"nocar_month_zcgddsy"] doubleValue];
    
//    model.monthOrderTotalSuccessNums = [[dictionary objectForKey:@"monthOrderTotalSuccessNums"] integerValue];
//    model.monthOrderTotalSellEarn = [[dictionary objectForKey:@"monthOrderTotalSellEarn"] integerValue];
    
    return model;
}

@end
