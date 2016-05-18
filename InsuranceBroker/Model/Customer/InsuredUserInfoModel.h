//
//  InsuredUserInfoModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface InsuredUserInfoModel : BaseModel

@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *insuredEmail;
@property (nonatomic, strong) NSString *insuredId;
@property (nonatomic, strong) NSString *insuredMemo;
@property (nonatomic, strong) NSString *insuredName;
@property (nonatomic, strong) NSString *insuredPhone;
@property (nonatomic, assign) NSInteger insuredSex;
@property (nonatomic, assign) NSInteger insuredStatus;
@property (nonatomic, strong) NSString *liveAddr;
@property (nonatomic, strong) NSString *liveAreaId;
@property (nonatomic, strong) NSString *liveAreaName;
@property (nonatomic, strong) NSString *liveCityId;
@property (nonatomic, strong) NSString *liveCityName;
@property (nonatomic, strong) NSString *liveProvinceId;
@property (nonatomic, strong) NSString *liveProvinceName;
@property (nonatomic, strong) NSString *relationType;
@property (nonatomic, strong) NSString *relationTypeName;
@property (nonatomic, strong) NSDate *updatedAt;


- (void) updateModelWithDictionary:(NSDictionary *) dictionary;

@end
