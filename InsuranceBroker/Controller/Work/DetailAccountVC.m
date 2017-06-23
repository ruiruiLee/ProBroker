//
//  DetailAccountVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/12.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "DetailAccountVC.h"
#import "define.h"
#import "DetailAccountTableViewCell.h"
//#import "NetWorkHandler+queryUserBillPageList.h"
//#import "BillInfoModel.h"
//
//#import "BillDetailInfoVC.h"
//#import "BillDetailInfoFromLuckyVC.h"
//#import "BillDetailInfoFromOrderVC.h"
//#import "BillDetailInfoFromSubVC.h"
//#import "BillDetailInfoWithdrawVC.h"

#import "RedMoneyModel.h"
#import "NetWorkHandler+redMoneyList.h"

@implementation DetailAccountVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的红包";
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    self.pulltable.tableHeaderView = header;
    self.pulltable.backgroundColor = [UIColor clearColor];
    [self.pulltable registerNib:[UINib nibWithNibName:@"DetailAccountTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.pulltable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.pulltable.separatorColor = SepLineColor;
    if ([self.pulltable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.pulltable setSeparatorInset:insets];
    }
    if ([self.pulltable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.pulltable setLayoutMargins:insets];
    }
}

- (void) loadDataInPages:(NSInteger)page
{
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    
    [NetWorkHandler requestToRedMoneyList:user.userId isManager:0 offset:page limit:LIMIT keyValue:nil memo:nil orderUuId:nil orderNo:nil carNo:nil orderBy:@"createdAt desc" Completion:^(int code, id content) {
        
        [self refreshTable];
        [self loadMoreDataToTable];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            if(page == 0){
                [self.data removeAllObjects];
            }
            
            [self.data addObjectsFromArray:[RedMoneyModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]]];
            self.total = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
            [self.pulltable reloadData];
        }

        
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.data count] == 0){
        [self showNoDatasImage:ThemeImage(@"no_data")];
    }
    else{
        [self hidNoDatasImage];
    }
    return [self.data count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    DetailAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"DetailAccountTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    RedMoneyModel *model = [self.data objectAtIndex:indexPath.row];
    if([model.money integerValue] > 0){
        cell.logo.image = ThemeImage(@"logo_income");
        cell.lbAccount.text = [NSString stringWithFormat:@"+%@",model.money];
    }
    else{
        cell.logo.image = ThemeImage(@"logo_outcome");
        cell.lbAccount.text = [NSString stringWithFormat:@"%@",model.money];
    }

    cell.lbTypeName.text = model.money;
    cell.lbDetail.text = model.memo;
    cell.lbDate.text = [self getdate:model.createdAt];
    cell.lbTime.text = [self gettime:model.createdAt];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    BillInfoModel *model = [self.data objectAtIndex:indexPath.row];
//    BillDetailInfoVC *vc = nil;
//    ////类型 1自己的保单直接收益，2下线提成，3团队长管理津贴，4红包，5收益提现
//    if (model.billType == 1) {
//        vc = [[BillDetailInfoFromOrderVC alloc] initWithNibName:nil bundle:nil];
//    }
//    else if (model.billType == 2){
//        vc = [[BillDetailInfoFromSubVC alloc] initWithNibName:nil bundle:nil];
//    }
//    else if (model.billType == 5){
//        vc = [[BillDetailInfoWithdrawVC alloc] initWithNibName:nil bundle:nil];
//    }
//    else if (model.billType == 4){
//        vc = [[BillDetailInfoFromLuckyVC alloc] initWithNibName:nil bundle:nil];
//    }
//    else {
//        
//    }
//    vc.billInfo = model;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 10, 0, 10);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:insets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:insets];
    }
}

- (NSString *) getdate:(NSDate *) date
{
    NSDateFormatter *formatter = [self dateFormatter:@"MM月dd日"];
    return [formatter stringFromDate:date];
}

- (NSString *) gettime:(NSDate *) time
{
    NSDateFormatter *formatter = [self dateFormatter:@"HH:mm"];
    return [formatter stringFromDate:time];
}

- (NSDateFormatter *)dateFormatter:(NSString *) formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return dateFormatter;
}

@end
