//
//  RatioMapsModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "RatioMapsModel.h"

@implementation RatioMapsModel

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    RatioMapsModel *model = [[RatioMapsModel alloc] init];
    
    model.nowMonthTeamSellTj = [dictionary objectForKey:@"nowMonthTeamSellTj"];
    model.nowDayTeamSellTj = [dictionary objectForKey:@"nowDayTeamSellTj"];
    model.tjTime = [dictionary objectForKey:@"tjTime"];
    
    return model;
}

@end
