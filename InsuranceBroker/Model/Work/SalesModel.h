//
//  SalesModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/4.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface SalesModel : BaseModel

@property (nonatomic, strong) NSString *dayStr;
@property (nonatomic, strong) NSString *dayStr_;
@property (nonatomic, assign) double car_day_zcgddbf;//历史天车险总成功订单保费
@property (nonatomic, assign) double day_zcgddbf;//历史天总成功订单保费
@property (nonatomic, assign) double nocar_day_zcgddbf;//历史天非车险总成功订单保费
//@property (nonatomic, assign) NSInteger totalIn;
//@property (nonatomic, assign) CGFloat dayOrderTotalSellEarn;

@end
