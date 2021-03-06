//
//  BrokerInfoModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/13.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BrokerInfoModel.h"

@implementation BrokerInfoModel

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[BrokerInfoModel modelFromDictionary:dic]];
    }
    
    return result;
}

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    BrokerInfoModel *model = [[BrokerInfoModel alloc] init];
    
    model.userId = [dictionary objectForKey:@"userId"];
    model.realName = [dictionary objectForKey:@"realName"];
    model.phone = [dictionary objectForKey:@"phone"];
    model.cardNumber = [dictionary objectForKey:@"cardNumber"];
    model.userType = [[dictionary objectForKey:@"userType"] integerValue];
    model.status = [[dictionary objectForKey:@"status"] integerValue];
    model.headerImg = [dictionary objectForKey:@"headerImg"];
    model.userName = [dictionary objectForKey:@"userName"];
//    model.monthOrderEarn = [dictionary objectForKey:@"monthOrderEarn"];
    model.userSex = [[dictionary objectForKey:@"userSex"] integerValue];
//    model.orderSuccessNums = [[dictionary objectForKey:@"orderSuccessNums"] integerValue];
//    model.nowMonthOrderSuccessNums = [[dictionary objectForKey:@"nowMonthOrderSuccessNums"] integerValue];
//    model.nowMonthOrderSellEarn = [[dictionary objectForKey:@"nowMonthOrderSellEarn"] floatValue];
    model.cardVerifiy = [[dictionary objectForKey:@"cardVerifiy"] integerValue];
//    model.dayOrderTotalSellEarn = [[dictionary objectForKey:@"dayOrderTotalSellEarn"] floatValue];
    model.remarkName = [dictionary objectForKey:@"remarkName"];
    
//    model.dayOrderTotalTrtbNums = [[dictionary objectForKey:@"dayOrderTotalTrtbNums"] integerValue];
//    model.dayOrderTotalOfferNums = [[dictionary objectForKey:@"dayOrderTotalOfferNums"] integerValue];
    
    model.car_day_zbjcs = [[dictionary objectForKey:@"car_day_zbjcs"] integerValue];
    model.car_day_zcgddbf = [[dictionary objectForKey:@"car_day_zcgddbf"] doubleValue];
    model.car_day_ztbcs = [[dictionary objectForKey:@"car_day_ztbcs"] integerValue];
    model.car_month_zbjcs = [[dictionary objectForKey:@"car_month_zbjcs"] integerValue];
    model.car_month_zcgddbf = [[dictionary objectForKey:@"car_month_zcgddbf"] doubleValue];
    model.car_month_ztbcs = [[dictionary objectForKey:@"car_month_ztbcs"] integerValue];
    
    model.day_zbjcs = [[dictionary objectForKey:@"day_zbjcs"] integerValue];
    model.day_zcgddbf = [[dictionary objectForKey:@"day_zcgddbf"] doubleValue];
    model.day_ztbcs = [[dictionary objectForKey:@"day_ztbcs"] integerValue];
    model.month_zbjcs = [[dictionary objectForKey:@"month_zbjcs"] integerValue];
    model.month_zcgddbf = [[dictionary objectForKey:@"month_zcgddbf"] doubleValue];
    model.month_ztbcs = [[dictionary objectForKey:@"month_ztbcs"] integerValue];
    
    model.nocar_day_zbjcs = [[dictionary objectForKey:@"nocar_day_zbjcs"] integerValue];
    model.nocar_day_zcgddbf = [[dictionary objectForKey:@"nocar_day_zcgddbf"] doubleValue];
    model.nocar_day_ztbcs = [[dictionary objectForKey:@"nocar_day_ztbcs"] integerValue];
    model.nocar_month_zbjcs = [[dictionary objectForKey:@"nocar_month_zbjcs"] integerValue];
    model.nocar_month_zcgddbf = [[dictionary objectForKey:@"nocar_month_zcgddbf"] doubleValue];
    model.nocar_month_ztbcs = [[dictionary objectForKey:@"nocar_month_ztbcs"] integerValue];
    model.userDoType = [[dictionary objectForKey:@"userDoType"] integerValue];
    model.userLevel = [[dictionary objectForKey:@"userLevel"] integerValue];
    
    model.yqrRealName = [dictionary objectForKey:@"yqrRealName"];
    
    return model;
}

@end
