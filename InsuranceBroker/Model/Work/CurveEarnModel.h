//
//  CurveEarnModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface CurveEarnModel : BaseModel

@property (nonatomic, strong) NSString *monthStr;
//@property (nonatomic, assign) NSInteger totalIn;
@property (nonatomic, assign) CGFloat monthOrderTotalSuccessEarn;

@end
