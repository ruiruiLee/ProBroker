//
//  productAttrModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface productAttrModel : BaseModel

@property (nonatomic, strong) NSString *attrStatus;
@property (nonatomic, strong) NSString *clickAddr;//点击链接
@property (nonatomic, strong) NSString *insuranceType;
@property (nonatomic, strong) NSString *productAttrId;//
@property (nonatomic, strong) NSString *productImg;//logo
@property (nonatomic, strong) NSString *productSellNums;//销售量,没有不显示
@property (nonatomic, strong) NSString *productIntro;//描述
@property (nonatomic, strong) NSString *productTitle;//标题
@property (nonatomic, strong) NSString *seqNo;
@property (nonatomic, strong) NSString *showPrice;//价格
@property (nonatomic, strong) NSString *productMaxRatio;
@property (nonatomic, strong) NSString *compCode;

@end
