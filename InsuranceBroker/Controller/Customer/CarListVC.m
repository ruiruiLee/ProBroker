//
//  CarListVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/9/9.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "CarListVC.h"
#import "NetWorkHandler+queryForCustomerCarPageList.h"
#import "Util.h"
#import "define.h"
#import "CarInfoModel.h"
#import "CarListTableViewCell.h"
#import "AutoInsuranceInfoEditVC.h"
#import "UIImageView+WebCache.h"
#import "NetWorkHandler+customerCarTop.h"

@implementation CarListVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"车辆列表";
    
    [self setRightBarButtonWithImage:ThemeImage(@"add")];
    self.pulltable.backgroundColor = [UIColor whiteColor];
    self.pulltable.tableFooterView = [[UIView alloc] init];
    self.pulltable.tableFooterView.backgroundColor = [UIColor whiteColor];
    
    [self.pulltable registerNib:[UINib nibWithNibName:@"CarListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void) handleRightBarButtonClicked:(id)sender
{
    AutoInsuranceInfoAddVC *vc = [[AutoInsuranceInfoAddVC alloc] initWithNibName:@"AutoInsuranceInfoAddVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    vc.customerId = self.customerId;
    vc.customerModel = self.customerModel;
}

- (void)loadDataInPages:(NSInteger)page
{
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    [rules addObject:[self getRulesByField:@"customerId" op:@"eq" data:self.customerId]];
    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    
    [NetWorkHandler requestToQueryForCustomerCarPageList:0 limit:LIMIT sord:@"desc" filters:filters Completion:^(int code, id content) {
        [self refreshTable];
        [self loadMoreDataToTable];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            [self appendData:[[content objectForKey:@"data"] objectForKey:@"rows"]];
            self.total = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
        }
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.pulltable reloadData];
}

- (void) appendData:(NSArray *) list
{
    if(self.pageNum == 0)
        [self.data removeAllObjects];
    NSArray *array = [CarInfoModel modelArrayFromArray:list];
    [self.data addObjectsFromArray:array];
    [self.pulltable reloadData];
}

- (NSDictionary *) getRulesByField:(NSString *) field op:(NSString *) op data:(NSString *) data
{
    NSMutableDictionary *rule = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:rule value:field key:@"field"];
    [Util setValueForKeyWithDic:rule value:op key:@"op"];
    [Util setValueForKeyWithDic:rule value:data key:@"data"];
    
    return rule;
}

#pragma  UITableViewDataSource, UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.data count] == 0){
        if(!_addview){
            _addview = [[BackGroundView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 2 / 5 + 6, ScreenWidth, 100)];
            _addview.delegate = self;
            _addview.lbTitle.text = @"该客户暂无车辆，请添加";
        }else{
            [_addview removeFromSuperview];
        }
        [self.pulltable addSubview:_addview];
    }
    else{
        [_addview removeFromSuperview];
    }
    
    return [self.data count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarInfoModel *model = [self.data objectAtIndex:indexPath.row];
    if(model.carNo && [model.carNo length] > 0){
        return 45.f;
    }else{
        return 96.f;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    CarListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CarListTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    if(indexPath.row == 0)
        cell.btnSelected.selected = YES;
    else
        cell.btnSelected.selected = NO;
            
    CarInfoModel *model = [self.data objectAtIndex:indexPath.row];
    if(model.carNo && [model.carNo length] > 0){
        cell.lbCarNu.hidden = NO;
        cell.imgLisence.hidden = YES;
        cell.lbCarNu.text = model.carNo;
    }else{
        cell.lbCarNu.hidden = YES;
        cell.imgLisence.hidden = NO;
        [cell.imgLisence sd_setImageWithURL:[NSURL URLWithString:model.travelCard1] placeholderImage:ThemeImage(@"normal")];
    }
    
    cell.btnSelected.tag = 100+indexPath.row;
    [cell.btnSelected addTarget:self action:@selector(doBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    [self.navigationController popViewControllerAnimated:YES];
    CarInfoModel *model = [self.data objectAtIndex:indexPath.row];
    
    AutoInsuranceInfoEditVC *vc = [IBUIFactory CreateAutoInsuranceInfoEditViewController];
    [self.navigationController pushViewController:vc animated:YES];
    vc.customerId = self.customerId;
    vc.carInfo = model;
    vc.customerModel = self.customerModel;
}


#pragma BackGroundViewDelegate
- (void) notifyToAddNewCustomer:(BackGroundView *) view
{
    [self handleRightBarButtonClicked:nil];
}

- (void) doBtnSelected:(UIButton *) sender
{
    NSInteger tag = sender.tag - 100;
    CarInfoModel *model = [self.data objectAtIndex:tag];
    [NetWorkHandler requestToQueueCustomerCarTop:model.customerCarId Completion:^(int code, id content) {
        
    }];
    self.customerModel.carInfo = model;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
