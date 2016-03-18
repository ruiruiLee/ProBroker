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
//@property (nonatomic, assign) NSInteger totalIn;
@property (nonatomic, assign) CGFloat dayOrderTotalSellEarn;

@end
