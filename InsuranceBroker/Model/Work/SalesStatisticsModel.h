//
//  SalesStatisticsModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/4.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface SalesStatisticsModel : BaseModel


@property (nonatomic, assign) double car_now_zcgddbf;//": "0",//当前月车险总成功订单保费
@property (nonatomic, assign) long long car_now_zcgdds;//": "0",//当前月车险总成功订单数
@property (nonatomic, assign) double car_now_zcgddsy;//": "0",//当前月车险总成功订单收益
@property (nonatomic, assign) double car_now_zcgddxse;//": "0",//当前月车险总成功订单销售额
@property (nonatomic, assign) double nocar_now_zcgddbf;//": "0",//当前月非车险总成功订单保费
@property (nonatomic, assign) long long nocar_now_zcgdds;//": "0",//当前月非车险总成功订单数
@property (nonatomic, assign) double nocar_now_zcgddsy;//": "0",//当前月非车险总成功订单收益
@property (nonatomic, assign) double nocar_now_zcgddxse;//": "0",//当前月非车险总成功订单销售额
@property (nonatomic, assign) double now_zcgddbf;//": "0",//当前月总成功订单保费
@property (nonatomic, assign) long long now_zcgdds;//": "0",//当前月总成功订单数
@property (nonatomic, assign) double now_zcgddsy;//": "0",//当前月总成功订单收益
@property (nonatomic, assign) double now_zcgddxse;//": "0",//当前月总成功订单销售额
@property (nonatomic, assign) double now_zsy;//": "0",//当前月总收益
@property (nonatomic, assign) long long now_ztdrs;//": "0",//当前月团队人数
@property (nonatomic, strong) NSString *userId;//": "126",
@property (nonatomic, assign) double zcgddbf;//": "0",//总成功订单保费
@property (nonatomic, assign) long long zcgdds;//": "5",//总成功订单数
@property (nonatomic, assign) double zcgddsy;//": "0",//总成功订单收益
@property (nonatomic, assign) double zsy;//": "2130.00",//总收益
@property (nonatomic, assign) long long ztdrs;//": "0"//团队人数

@property (nonatomic, assign) double month_zcgddsy;////历史月总成功订单收益
@property (nonatomic, assign) double month_ztcsy;//历史月总提成收益
@property (nonatomic, assign) double month_zgljtsy;//历史月总管理津贴收益
@property (nonatomic, assign) double month_zhbsy;//历史月总红包收益
@property (nonatomic, assign) double month_othersy;//历史月总其它收益

@property (nonatomic, assign) CGFloat now_zcgddbf_jbl;//当前月总成功订单保费击败率
@property (nonatomic, assign) CGFloat car_now_zcgddbf_jbl;////当前月车险总成功订单保费击败率
@property (nonatomic, assign) CGFloat nocar_now_zcgddbf_jbl;////当前月非车险总成功订单保费击败率
@property (nonatomic, assign) CGFloat now_zcgddsy_jbl;////当前月总成功订单收益击败率
@property (nonatomic, assign) CGFloat car_now_zcgddsy_jbl;////当前月车险总成功订单收益击败率
@property (nonatomic, assign) CGFloat nocar_now_zcgddsy_jbl;////当前月非车险总成功订单收益击败率

@property (nonatomic, assign) double zcgddxse;// = 0.0;//总成功订单销售额
@property (nonatomic, assign) double car_zcgddxse;// = 0.0;//当前月车险总成功订单销售额
@property (nonatomic, assign) double nocar_zcgddxse; //= 0.0;//当前月非车险总成功订单销售额

@end
