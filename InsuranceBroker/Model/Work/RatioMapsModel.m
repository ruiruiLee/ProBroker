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
    
//    model.nowMonthTeamSellTj = [dictionary objectForKey:@"nowMonthTeamSellTj"];
//    model.nowDayTeamSellTj = [dictionary objectForKey:@"nowDayTeamSellTj"];
    model.tjTime = [dictionary objectForKey:@"tjTime"];
    model.nocar_month_zcgddbf = [dictionary objectForKey:@"nocar_month_zcgddbf"];
    model.day_zcgddbf = [dictionary objectForKey:@"day_zcgddbf"];
    model.month_zcgddbf = [dictionary objectForKey:@"month_zcgddbf"];
    model.car_month_zcgddbf = [dictionary objectForKey:@"car_month_zcgddbf"];
    model.nocar_day_zcgddbf = [dictionary objectForKey:@"nocar_day_zcgddbf"];
    model.car_day_zcgddbf = [dictionary objectForKey:@"car_day_zcgddbf"];
    
    return model;
}

@end
