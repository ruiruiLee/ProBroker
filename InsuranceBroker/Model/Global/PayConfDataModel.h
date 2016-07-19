//
//  PayConfDataModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/7/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface PayConfDataModel : BaseModel

@property (nonatomic, assign) NSInteger deviceType;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *payDefault;
@property (nonatomic, strong) NSString *payId;
@property (nonatomic, strong) NSString *payIntro;
@property (nonatomic, strong) NSString *payLogo;
@property (nonatomic, strong) NSString *payName;
@property (nonatomic, assign) NSInteger payStatus;
@property (nonatomic, assign) NSInteger payConfType;
@property (nonatomic, strong) NSString *payValue;

@end
