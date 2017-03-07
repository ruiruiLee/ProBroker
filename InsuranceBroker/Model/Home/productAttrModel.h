//
//  productAttrModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface productAttrModel : BaseModel

@property (nonatomic, strong) NSString *productStatus;
@property (nonatomic, strong) NSString *clickAddr;//点击链接
@property (nonatomic, strong) NSString *insuranceType;
@property (nonatomic, strong) NSString *productLogo;//logo
@property (nonatomic, strong) NSString *productSellNums;//销售量,没有不显示
@property (nonatomic, strong) NSString *productIntro;//描述
@property (nonatomic, strong) NSString *productName;//标题
@property (nonatomic, strong) NSString *seqNo;
@property (nonatomic, strong) NSString *showPrice;//价格
@property (nonatomic, strong) NSString *productMaxRatio;
@property (nonatomic, strong) NSString *compCode;
@property (nonatomic, strong) NSString *uniqueFlag;
@property (nonatomic, strong) NSString *insuranceTypeName;
@property (nonatomic, strong) NSString *productId;

@end
