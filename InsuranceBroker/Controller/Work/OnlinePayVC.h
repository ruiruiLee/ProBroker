//
//  OnlinePayVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/3/31.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"

@interface OnlinePayVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIButton *btnPay;
@property (nonatomic, strong) IBOutlet UIImageView *logo;
@property (nonatomic, strong) IBOutlet UILabel *lbTitle;
@property (nonatomic, strong) IBOutlet UILabel *lbAmount;
@property (nonatomic, strong) IBOutlet UILabel *lbpayContent;//支付说明
@property (nonatomic, strong) IBOutlet UILabel *createTime;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tableHeight;

@property (nonatomic, strong) NSString *orderId;//订单id
@property (nonatomic, strong) NSString *insuranceType;//险种
@property (nonatomic, strong) NSString *planOfferId;//报价
@property (nonatomic, strong) NSString *totalFee;//总价
@property (nonatomic, strong) NSString *titleName;//产品名称
@property (nonatomic, strong) NSString *companyLogo;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *payDesc;


@end
