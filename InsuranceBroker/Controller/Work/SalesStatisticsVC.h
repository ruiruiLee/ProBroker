//
//  SalesStatisticsVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/17.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "GradientView.h"
#import "LineChartView.h"

typedef enum : NSUInteger {
    EnumSalesTypeCar,
    EnumSalesTypeNoCar,
} SalesType;

@interface SalesStatisticsVC : BaseViewController

@property (nonatomic, strong) UIView *explainBgView;
@property (nonatomic, strong) UIImageView *imgWithNoData;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *viewHConstraint;
@property (nonatomic, strong) IBOutlet GradientView *topView;
@property (nonatomic, strong) IBOutlet UILabel *lbIncome;
@property (nonatomic, strong) IBOutlet UILabel *lbEarnings;
@property (nonatomic, strong) IBOutlet UILabel *lbEarningsCount;
@property (nonatomic, strong) IBOutlet LineChartView *chatview;

@property (nonatomic, strong) IBOutlet LineChartView *chatview1;//近6月销售趋势
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, assign) SalesType saleType;

@end
