//
//  CitySelectedVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/30.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ProviendeModel.h"

@interface CitySelectedVC : BaseTableViewController

@property (nonatomic, assign) NSInteger selectIdx;

@property (nonatomic, strong) ProviendeModel *proviendemodel;

@property (nonatomic, strong) NSArray *data;

- (void) modifyAddress:(CityModel *)citymodel;

@end
