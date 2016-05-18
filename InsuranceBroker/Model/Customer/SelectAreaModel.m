//
//  SelectAreaModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "SelectAreaModel.h"

@implementation SelectAreaModel

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    SelectAreaModel *model = [[SelectAreaModel alloc] init];
    
    model.liveProvinceId = [dictionary objectForKey:@"liveProvinceId"];
    model.liveProvince = [dictionary objectForKey:@"liveProvince"];
    model.liveCityId = [dictionary objectForKey:@"liveCityId"];
    model.liveCity = [dictionary objectForKey:@"liveCity"];
    
    return model;
}

@end
