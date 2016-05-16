//
//  CustomerCitySelectVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "CitySelectedVC.h"
#import "SelectAreaModel.h"
#import "CustomerInfoEditVC.h"

@interface CustomerCitySelectVC : CitySelectedVC

@property (nonatomic, strong) SelectAreaModel *selectArea;
@property (nonatomic, weak) CustomerInfoEditVC *_edit;

@end
