//
//  ProductRadioModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/5.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface ProductRadioModel : BaseModel

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *productLogo;
@property (nonatomic, strong) NSString *productMaxRatio;
@property (nonatomic, strong) NSString *productMinRatio;
@property (nonatomic, strong) NSString *productName;

@end
