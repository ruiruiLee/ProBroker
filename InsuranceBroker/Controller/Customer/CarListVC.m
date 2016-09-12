//
//  CarListVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/9/9.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "CarListVC.h"

@implementation CarListVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"车辆列表";
}


#pragma  UITableViewDataSource, UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.f;
}

@end
