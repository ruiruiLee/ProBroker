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
    model.monthOrderTotalSuccessNums = [[dictionary objectForKey:@"monthOrderTotalSuccessNums"] integerValue];
    model.monthOrderTotalSellEarn = [[dictionary objectForKey:@"monthOrderTotalSellEarn"] integerValue];
    
    return model;
}

@end
