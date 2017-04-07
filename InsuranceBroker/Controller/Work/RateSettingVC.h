//
//  RateSettingVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/4/1.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"

@interface RateSettingVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
