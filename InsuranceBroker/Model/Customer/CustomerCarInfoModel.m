//
//  CustomerCarInfoModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "CustomerCarInfoModel.h"
#import "define.h"

@implementation CustomerCarInfoModel

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    CustomerCarInfoModel *model = [[CustomerCarInfoModel alloc] init];
    
    model.pageType = [[dictionary objectForKey:@"pageType"] integerValue];
    model.userId = [dictionary objectForKey:@"userId"];
    model.carNo = [dictionary objectForKey:@"carNo"];
    model.carOwnerName = [dictionary objectForKey:@"carOwnerName"];
    model.carOwnerCard = [dictionary objectForKey:@"carOwnerCard"];
    model.carShelfNo = [dictionary objectForKey:@"carShelfNo"];
    model.carBrandName = [dictionary objectForKey:@"carBrandName"];
    model.carTypeNo = [dictionary objectForKey:@"carTypeNo"];
    model.carEngineNo = [dictionary objectForKey:@"carEngineNo"];
    model.carRegTime = [BaseModel dateFromString:[dictionary objectForKey:@"carRegTime"]];
    model.customerId = [dictionary objectForKey:@"customerId"];
    model.customerCarId = [dictionary objectForKey:@"customerCarId"];
    model.resultStatus = [[dictionary objectForKey:@"resultStatus"] integerValue];
    model.carTradeStatus = [[dictionary objectForKey:@"carTradeStatus"] integerValue];
    if([dictionary objectForKey:@"carTradeStatus"] == nil)
        model.carTradeStatus = 1;
    model.travelCard1 = [dictionary objectForKey:@"travelCard1"];
    model.carTradeTime = [BaseModel dateFromString:[dictionary objectForKey:@"carTradeTime"]];
    
    return model;
}

@end
