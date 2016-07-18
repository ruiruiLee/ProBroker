//
//  PayTypeSelectedVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/7/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"

@interface PayTypeSelectedVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *hConstraints;
@property (nonatomic, strong) NSArray *vConstraints;
@property (nonatomic, strong) NSLayoutConstraint *tableHeight;

@property (nonatomic, strong) UIButton *btnPay;

@property (nonatomic, strong) NSString *orderId;//订单id
@property (nonatomic, strong) NSString *insuranceType;//险种
@property (nonatomic, strong) NSString *planOfferId;//报价

@end
