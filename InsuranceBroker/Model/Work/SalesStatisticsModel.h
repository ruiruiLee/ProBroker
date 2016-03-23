//
//  SalesStatisticsModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/4.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface SalesStatisticsModel : BaseModel

//@property (nonatomic, strong) NSString *statisticsId;//":1; //统计ID
//@property (nonatomic, strong) NSString *userId;//":1; //经纪人ID
//@property (nonatomic, strong) NSDate *beginTime;//":"visitType"; //统计开始时间
//@property (nonatomic, strong) NSDate *endTime;//":"电话"; //统计结束时间
//@property (nonatomic, strong) NSDate *createdAt;//":1; //统计时间
////@property (nonatomic, assign) NSInteger monthTotalIn;//":23152; //月总收益
//@property (nonatomic, assign) NSInteger monthTotalOut;//":"0"; //前端暂时不用
//@property (nonatomic, assign) NSInteger monthTotalRatio;//":60; //超过60%
//@property (nonatomic, assign) NSInteger monthInInsurance;//":"0"; //保单占比
//@property (nonatomic, assign) NSInteger monthInTeam;//":0; //团队占比
//@property (nonatomic, assign) NSInteger monthInRedPack;//":"0"; //红包占比
//@property (nonatomic, assign) NSInteger monthInLeader;//":"0"; //管理占比
////@property (nonatomic, assign) NSInteger totalIn;//":123152; //总收益
//@property (nonatomic, assign) NSInteger monthTotalInNums;
//@property (nonatomic, assign) NSInteger totalInNums;

@property (nonatomic, assign) CGFloat nowMonthOrderSellEarn;//": "0.00",//当前月成功订单销售额
@property (nonatomic, assign) CGFloat nowMonthOrderSuccessEarn;//": "0.00",//当前月成功订单收益
@property (nonatomic, assign) NSInteger nowMonthOrderSuccessNums;//": "0",//当前月成功订单数
@property (nonatomic, assign) CGFloat nowMonthSellBeatRatio;//": "0",//当前月成功订单击败率 - 销售额
@property (nonatomic, assign) CGFloat nowMonthNumsBeatRatio;//": "0",//当前月成功订单击败率 - 销售单数
@property (nonatomic, assign) CGFloat nowMonthEarnBeatRatio;//": "0",//当前月成功订单击败率 - 订单收益
@property (nonatomic, assign) CGFloat orderTotalSellEarn;//": "0.00",
@property (nonatomic, assign) CGFloat orderTotalSuccessEarn;//": "0.00",
@property (nonatomic, assign) NSInteger orderTotalSuccessNums;//": "0"
@property (nonatomic, assign) CGFloat totalSellBeatRatio;//": "0",//总成功订单击败率 - 销售额
@property (nonatomic, assign) CGFloat totalNumsBeatRatio;//": "0",//总成功订单击败率 - 销售单数
@property (nonatomic, assign) CGFloat totalEarnBeatRatio;//": "0",//总成功订单击败率 - 订单收益
@property (nonatomic, assign) CGFloat nowUserTotalMoney;//当前月收益；+直接收益+提层+管理津贴+红包
@property (nonatomic, assign) CGFloat userTotalMoney;//总收益；+直接收益+提层+管理津贴+红包
//上月收益分析饼图
@property (nonatomic, assign) CGFloat monthOrderTotalSuccessEarn;//": "0.00",//成功订单收益
@property (nonatomic, assign) CGFloat monthOrderTotalTcEarn;//": "0.00",//提层
@property (nonatomic, assign) CGFloat monthRedPackTotalEarn;//": "0.00",//红包
@property (nonatomic, assign) CGFloat monthOrderTotalGlEarn;//": "0.00",//管理津贴

@end
