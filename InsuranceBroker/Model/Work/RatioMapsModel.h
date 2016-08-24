//
//  RatioMapsModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface RatioMapsModel : BaseModel

//@property (nonatomic, strong) NSString *nowMonthTeamSellTj;
//@property (nonatomic, strong) NSString *nowDayTeamSellTj;
@property (nonatomic, strong) NSString *nocar_month_zcgddbf;//": "0.00",//非车险月保费
@property (nonatomic, strong) NSString *day_zcgddbf;//": "62.00",//总天保费
@property (nonatomic, strong) NSString *tjTime;//": "截止统计时间: 05-10 20:00",
@property (nonatomic, strong) NSString *month_zcgddbf;//": "0.00",总月保费
@property (nonatomic, strong) NSString *car_month_zcgddbf;//": "0.00",车险月保费
@property (nonatomic, strong) NSString *nocar_day_zcgddbf;//": "12.00",非车险天保费
@property (nonatomic, strong) NSString *car_day_zcgddbf;//": "50.00"车险天保费

@end
