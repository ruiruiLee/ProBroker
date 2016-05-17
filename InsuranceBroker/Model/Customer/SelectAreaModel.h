//
//  SelectAreaModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface SelectAreaModel : BaseModel

@property (nonatomic, strong) NSString *liveProvinceId;
@property (nonatomic, strong) NSString *liveProvince;
@property (nonatomic, strong) NSString *liveCityId;
@property (nonatomic, strong) NSString *liveCity;

@end
