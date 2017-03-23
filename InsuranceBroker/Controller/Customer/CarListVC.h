//
//  CarListVC.h
//  InsuranceBroker
//  车辆列表
//  Created by LiuZach on 16/9/9.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BasePullTableVC.h"
#import "BackGroundView.h"
#import "CustomerDetailModel.h"

@interface CarListVC : BasePullTableVC<BackGroundViewDelegate>
{
    BackGroundView *_addview;
}

@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) CustomerDetailModel *customerModel;

@end
