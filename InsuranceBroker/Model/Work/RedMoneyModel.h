//
//  RedMoneyModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/16.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface RedMoneyModel : BaseModel

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *carNo;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSString *operatId;
@property (nonatomic, strong) NSString *operatName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *orderUuId;
@property (nonatomic, strong) NSString *userMoneyLogId;
@property (nonatomic, strong) NSString *beforeMoney;
@property (nonatomic, strong) NSString *afterMoney;

@end
