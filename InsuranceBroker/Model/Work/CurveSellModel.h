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
@property (nonatomic, assign) CGFloat monthOrderTotalSellEarn;
@property (nonatomic, assign) NSInteger monthOrderTotalSuccessNums;

@end
