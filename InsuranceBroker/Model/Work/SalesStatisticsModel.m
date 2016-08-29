//
//  SalesStatisticsModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/4.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "SalesStatisticsModel.h"

@implementation SalesStatisticsModel

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    SalesStatisticsModel *model = [[SalesStatisticsModel alloc] init];
    
    model.userId = [dictionary objectForKey:@"userId"];
    model.car_now_zcgddbf = [[dictionary objectForKey:@"car_now_zcgddbf"] doubleValue];
    model.car_now_zcgdds = [[dictionary objectForKey:@"car_now_zcgdds"] longLongValue];
    model.car_now_zcgddsy = [[dictionary objectForKey:@"car_now_zcgddsy"] doubleValue];
    model.car_now_zcgddxse = [[dictionary objectForKey:@"car_now_zcgddxse"] doubleValue];
    model.nocar_now_zcgddbf = [[dictionary objectForKey:@"nocar_now_zcgddbf"] doubleValue];
    model.nocar_now_zcgdds = [[dictionary objectForKey:@"nocar_now_zcgdds"] longLongValue];
    model.nocar_now_zcgddsy = [[dictionary objectForKey:@"nocar_now_zcgddsy"] doubleValue];
    model.nocar_now_zcgddxse = [[dictionary objectForKey:@"nocar_now_zcgddxse"] doubleValue];
    model.now_zcgddbf= [[dictionary objectForKey:@"now_zcgddbf"] doubleValue];
    model.now_zcgdds = [[dictionary objectForKey:@"now_zcgdds"] longLongValue];
    model.now_zcgddsy = [[dictionary objectForKey:@"now_zcgddsy"] doubleValue];
    model.now_zcgddxse = [[dictionary objectForKey:@"now_zcgddxse"] doubleValue];
    model.now_zsy = [[dictionary objectForKey:@"now_zsy"] doubleValue];
    model.now_ztdrs= [[dictionary objectForKey:@"now_ztdrs"] longLongValue];
    model.zcgddbf = [[dictionary objectForKey:@"zcgddbf"] doubleValue];
    model.zcgdds = [[dictionary objectForKey:@"zcgdds"] longLongValue];
    model.zcgddsy = [[dictionary objectForKey:@"zcgddsy"] doubleValue];
    model.zcgddxse = [[dictionary objectForKey:@"zcgddxse"] doubleValue];
    model.zsy = [[dictionary objectForKey:@"zsy"] doubleValue];
    model.ztdrs = [[dictionary objectForKey:@"ztdrs"] longLongValue];
    
    model.month_zcgddsy = [[dictionary objectForKey:@"month_zcgddsy"] doubleValue];
    model.month_ztcsy = [[dictionary objectForKey:@"month_ztcsy"] doubleValue];
    model.month_zgljtsy = [[dictionary objectForKey:@"month_zgljtsy"] doubleValue];
    model.month_zhbsy = [[dictionary objectForKey:@"month_zhbsy"] doubleValue];
    model.month_othersy = [[dictionary objectForKey:@"month_othersy"] doubleValue];
    
    model.now_zcgddbf_jbl = [[dictionary objectForKey:@"now_zcgddbf_jbl"] floatValue];
    model.car_now_zcgddbf_jbl = [[dictionary objectForKey:@"car_now_zcgddbf_jbl"] floatValue];
    model.nocar_now_zcgddbf_jbl = [[dictionary objectForKey:@"nocar_now_zcgddbf_jbl"] floatValue];
    model.now_zcgddsy_jbl = [[dictionary objectForKey:@"now_zcgddsy_jbl"] floatValue];
    model.car_now_zcgddsy_jbl = [[dictionary objectForKey:@"car_now_zcgddsy_jbl"] floatValue];
    model.nocar_now_zcgddsy_jbl = [[dictionary objectForKey:@"nocar_now_zcgddsy_jbl"] floatValue];
    
    model.car_zcgddxse = [[dictionary objectForKey:@"car_zcgddxse"] doubleValue];
    model.nocar_zcgddxse = [[dictionary objectForKey:@"nocar_zcgddxse"] doubleValue];
    
    model.car_zcgddbf = [[dictionary objectForKey:@"car_zcgddbf"] doubleValue];
    model.nocar_zcgddbf = [[dictionary objectForKey:@"nocar_zcgddbf"] doubleValue];
    
    return model;
}

@end
