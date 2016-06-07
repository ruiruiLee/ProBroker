//
//  SelectInsuredVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/26.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "SelectInsuredVC.h"
#import "define.h"
#import "InsureInfoListTableViewCell.h"
#import "NetWorkHandler+queryForInsuredPageList.h"

#define CELL_HEIGHT  56

@interface SelectInsuredVC ()
{
    NSInteger _selectIdx;
}

@end

@implementation SelectInsuredVC
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setRightBarButtonWithImage:ThemeImage(@"add")];
    
    [self.pulltable registerNib:[UINib nibWithNibName:@"InsureInfoListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyRefreshInsuredList:) name:Notify_Refresh_Insured_list object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) NotifyRefreshInsuredList:(NSNotification *) notify
{
    [self refresh2Loaddata];
}

- (void) handleRightBarButtonClicked:(id)sender
{
    InsuredUserInfoEditVC *vc = [IBUIFactory CreateInsuredUserInfoEditVC];
    vc.title = @"被保人信息";
    vc.customerId = self.customerId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) setSelectedInsuredId:(NSString *) insuredId
{
    _insuredId = insuredId;
    [self initSelectedIndex];
}

- (void) initSelectedIndex
{
    _selectIdx = 0;
    for (int i = 0 ; i < [self.data count]; i++) {
        InsuredUserInfoModel *model = [self.data objectAtIndex:i];
        if(_insuredId && [_insuredId isEqualToString:model.insuredId]){
            _selectIdx = i;
        }
    }
    
    [self.pulltable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadDataInPages:(NSInteger)page
{
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    [rules addObject:[self getRulesByField:@"customerId" op:@"cn" data:self.customerId]];
    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    [NetWorkHandler requestToQueryForInsuredPageListOffset:0 limit:1000 filters:filters customerId:self.customerId Completion:^(int code, id content) {
        [self refreshTable];
        [self loadMoreDataToTable];
        [ProgressHUD dismiss];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            if(page == 0){
                [self.data removeAllObjects];
            }
            NSArray *array = [InsuredUserInfoModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]];
            [self.data addObjectsFromArray:array];
            self.total = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
            
            [self initSelectedIndex];
        }
        
        [self.pulltable reloadData];
    }];
}

- (NSDictionary *) getRulesByField:(NSString *) field op:(NSString *) op data:(NSString *) data
{
    NSMutableDictionary *rule = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:rule value:field key:@"field"];
    [Util setValueForKeyWithDic:rule value:op key:@"op"];
    [Util setValueForKeyWithDic:rule value:data key:@"data"];
    
    return rule;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell1";
    InsureInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"InsureInfoListTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSInteger row = indexPath.row;
    if(_selectIdx == row){
        cell.btnSelected.selected = YES;
    }else{
        cell.btnSelected.selected = NO;
    }
    cell.btnSelected.tag = 100 + row;
    cell.btnSelected.userInteractionEnabled = NO;
    
    InsuredUserInfoModel *model = [self.data objectAtIndex:row];
    cell.lbName.text = model.insuredName;
    cell.lbRelation.text = model.relationTypeName;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _selectIdx = indexPath.row;
    [self.pulltable reloadData];
    
    if(delegate && [delegate respondsToSelector:@selector(NotifyInsuredSelectedWithModel:vc:)]){
        InsuredUserInfoModel *model = [self.data objectAtIndex:indexPath.row];
        [delegate NotifyInsuredSelectedWithModel:model vc:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
