//
//  InsuredInfoModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

typedef enum : NSUInteger {
    InsuredType1,//从用户进去选择个险投保
    InsuredType2,//先选择产品，在选择投保人
} InsuredType;

@interface InsuredInfoModel : BaseModel

@property (nonatomic, copy) NSString *customerId;//客户id
@property (nonatomic, copy) NSString *insuredId;//被保人id
@property (nonatomic, assign) InsuredType type;

@end
