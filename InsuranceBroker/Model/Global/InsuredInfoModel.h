//
//  InsuredInfoModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"


@class InsuredUserInfoModel;

typedef enum : NSUInteger {
    InsuredType1,//从用户进去选择个险投保
    InsuredType2,//先选择产品，在选择投保人
} InsuredType;

@interface InsuredInfoModel : BaseModel

@property (nonatomic, copy) NSString *customerId;//客户id
@property (nonatomic, copy) NSString *insuredId;//被保人id
@property (nonatomic, copy) NSString *productId;//产品id
@property (nonatomic, assign) InsuredType type;

@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *insuredEmail;
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

+ (InsuredInfoModel *) initFromInsuredUserInfoModel:(InsuredUserInfoModel *) insuredUserInfo;

+ (NSDictionary *) dictionaryFromeModel:(InsuredInfoModel *) model;

@end
