//
//  BillDetailInfoWithdrawVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/2.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BillDetailInfoWithdrawVC.h"

@implementation BillDetailInfoWithdrawVC

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) initData
{
    [self setDataForWithdraw];
    self.lbTotalAmount.text = [NSString stringWithFormat:@"%@",self.billInfo.billMoney];
}

@end
