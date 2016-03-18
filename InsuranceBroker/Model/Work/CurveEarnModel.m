//
//  CurveEarnModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "CurveEarnModel.h"

@implementation CurveEarnModel

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[CurveEarnModel modelFromDictionary:dic]];
    }
    
    return result;
}

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    CurveEarnModel *model = [[CurveEarnModel alloc] init];
    
    model.monthStr = [dictionary objectForKey:@"monthStr"];
    model.monthOrderTotalSuccessEarn = [[dictionary objectForKey:@"monthOrderTotalSuccessEarn"] floatValue];
    
    return model;
}

@end
