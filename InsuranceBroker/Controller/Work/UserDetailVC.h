//
//  UserDetailVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "GradientView.h"
#import "PickView.h"
#import "BrokerInfoModel.h"

@interface UserDetailVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *scHConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *scVConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tableVConstraint;
@property (nonatomic, strong) IBOutlet GradientView *gradientView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UILabel *lbName;
@property (nonatomic, strong) IBOutlet UILabel *lbMobile;
@property (nonatomic, strong) IBOutlet UIImageView *photo;
@property (nonatomic, strong) IBOutlet UILabel *lbSubNum;
@property (nonatomic, strong) IBOutlet UILabel *lbMonthOrderSuccessNums;//车险本月保费
@property (nonatomic, strong) IBOutlet UILabel *lbTotalOrderSuccessNums;//车险本月单量
@property (nonatomic, strong) IBOutlet UILabel *lbPersonalMonthOrderSuccessNums;//个险本月保费
@property (nonatomic, strong) IBOutlet UILabel *lbPersonalTotalOrderSuccessNums;//个险本月单量
//@property (nonatomic, strong) IBOutlet UILabel *lbTotalOrderCount;//总订单数

@property (nonatomic, strong) IBOutlet UILabel *lbMonthOrderEarn;//总订单收益;
@property (nonatomic, strong) IBOutlet UILabel *lbOrderEarn;//总订单收益;
@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet UIImageView *rightArraw;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *rightArrowWidth;

@property (nonatomic, strong) IBOutlet UILabel *lbTotalCarSuccessNums;
@property (nonatomic, strong) IBOutlet UILabel *lbTotalNoCarSuccessNums;

@property (nonatomic, strong) BrokerInfoModel *brokerInfo;

@end
