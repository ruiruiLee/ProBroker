//
//  BrokerInfoModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/13.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface BrokerInfoModel : BaseModel

@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, assign) NSInteger userType;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *headerImg;
@property (nonatomic, strong) NSString *userName;
//@property (nonatomic, strong) NSString *monthOrderEarn;
@property (nonatomic, assign) NSInteger userSex;
//@property (nonatomic, assign) NSInteger orderSuccessNums;
//@property (nonatomic, assign) NSInteger nowMonthOrderSuccessNums;
@property (nonatomic, strong) NSString *userId;
//@property (nonatomic, assign) CGFloat nowMonthOrderSellEarn;
//@property (nonatomic, assign) CGFloat dayOrderTotalSellEarn;
@property (nonatomic, assign) NSInteger cardVerifiy;
@property (nonatomic, strong) NSString *remarkName;

//@property (nonatomic, assign) NSInteger dayOrderTotalOfferNums;
//@property (nonatomic, assign) NSInteger dayOrderTotalTrtbNums;


@property (nonatomic, assign) NSInteger car_day_zbjcs;//": "0",//车险天报价次数
@property (nonatomic, assign) double car_day_zcgddbf;//": "0.00",//车险天保费
@property (nonatomic, assign) NSInteger  car_day_ztbcs;//: "0",//车险天投保次数
@property (nonatomic, assign) NSInteger  car_month_zbjcs;//": "0",//车险月报价次数
@property (nonatomic, assign) double car_month_zcgddbf;//": "0.00",//车险月保费
@property (nonatomic, assign) NSInteger car_month_ztbcs;//": "0",//车险月投保次数

@property (nonatomic, assign) NSInteger day_zbjcs;//": "0",//天报价次数
@property (nonatomic, assign) double day_zcgddbf;//": "0.00",//天保费
@property (nonatomic, assign) NSInteger day_ztbcs;//": "0",//天投保次数
@property (nonatomic, assign) NSInteger month_zbjcs;//": "0",//月报价次数
@property (nonatomic, assign) double month_zcgddbf;//": "0.00",//月保费
@property (nonatomic, assign) NSInteger month_ztbcs;//": "0",//月报价次数

@property (nonatomic, assign) NSInteger nocar_day_zbjcs;//": "0",////非车险天报价次数
@property (nonatomic, assign) double nocar_day_zcgddbf;//": "0.00",//非车险天保费
@property (nonatomic, assign) NSInteger nocar_day_ztbcs;//": "0",//非车险天投保次数
@property (nonatomic, assign) NSInteger nocar_month_zbjcs;//": "0",//非车险月报价次数
@property (nonatomic, assign) double nocar_month_zcgddbf;//": "0.00",//非车险月保费
@property (nonatomic, assign) NSInteger nocar_month_ztbcs;//": "0",//非车险月投保次数
@property (nonatomic, assign) NSInteger userDoType;//": "0",
@property (nonatomic, assign) NSInteger userLevel;//": "0",

@property (nonatomic, strong) NSString *yqrRealName;



@end
