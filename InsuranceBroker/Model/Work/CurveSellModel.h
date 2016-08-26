//
//  CurveSellModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface CurveSellModel : BaseModel

@property (nonatomic, strong) NSString *monthStr;
@property (nonatomic, strong) NSString *monthStr_;
//@property (nonatomic, assign) CGFloat monthOrderTotalSellEarn;
//@property (nonatomic, assign) NSInteger monthOrderTotalSuccessNums;
@property (nonatomic, assign) double car_month_zcgddbf;//历史月车险总成功订单保费
@property (nonatomic, assign) long long car_month_zcgdds;//历史月车险总成功订单数
@property (nonatomic, assign) double car_month_zcgddsy;//历史月车险总成功订单收益
@property (nonatomic, assign) double month_zcgddbf;//历史月总成功订单保费
@property (nonatomic, assign) long long month_zcgdds;//历史月总成功订单数
@property (nonatomic, assign) double month_zcgddsy;//历史月总成功订单收益
@property (nonatomic, assign) double nocar_month_zcgddbf;//历史月非车险总成功订单保费
@property (nonatomic, assign) long long nocar_month_zcgdds;//历史月非车险总成功订单数
@property (nonatomic, assign) double nocar_month_zcgddsy;//历史月非车险总成功订单收益

@end
