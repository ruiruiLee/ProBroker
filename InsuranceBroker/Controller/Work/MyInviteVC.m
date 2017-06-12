//
//  MyInviteVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/12.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "MyInviteVC.h"
#import "NetWorkHandler+queryBeiYaoQingRen.h"
#import "define.h"
#import "BeiYaoQingRenModel.h"
#import "InviteListsTableViewCell.h"

@interface MyInviteVC ()

@end

@implementation MyInviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的邀请人";
    
    [self.pulltable registerNib:[UINib nibWithNibName:@"InviteListsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

//- (void) initSubViews
//{
//    self.pulltable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 580) style:UITableViewStyleGrouped];
//    [self.view addSubview:self.pulltable];
//    self.pulltable.delegate = self;
//    self.pulltable.dataSource = self;
//    self.pulltable.pullDelegate = self;
//    self.pulltable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.pulltable.translatesAutoresizingMaskIntoConstraints = NO;
//    self.pulltable.backgroundColor = [UIColor whiteColor];
//    
//    self.pulltable.tableFooterView = [[UIView alloc] init];
//    self.pulltable.tableFooterView.backgroundColor = [UIColor whiteColor];
//    
//    UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 20);
//    self.pulltable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.pulltable.separatorColor = SepLineColor;
//    if ([self.pulltable respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.pulltable setSeparatorInset:insets];
//    }
//    if ([self.pulltable respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.pulltable setLayoutMargins:insets];
//    }
//    
//    //弹出下拉刷新控件刷新数据
//    self.pulltable.pullTableIsRefreshing = YES;
//    PullTableView *pulltable = self.pulltable;
//    NSDictionary *views = NSDictionaryOfVariableBindings(pulltable);
//    
//    self.vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pulltable]-0-|" options:0 metrics:nil views:views];
//    [self.view addConstraints:self.vConstraints];
//    
//    self.hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pulltable]-0-|" options:0 metrics:nil views:views];
//    [self.view addConstraints:self.hConstraints];
//    
//    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
//    self.searchbar.placeholder = @"搜索";
//    self.searchbar.showsCancelButton = YES;
//    self.searchbar.returnKeyType = UIReturnKeySearch;
//    self.searchbar.delegate = self;
//    self.pulltable.tableHeaderView = self.searchbar;
//    
//    [self.pulltable registerNib:[UINib nibWithNibName:@"InviteListsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadDataInPages:(NSInteger)page
{
    [NetWorkHandler requestToQueryBeiYaoQingRen:[UserInfoModel shareUserInfoModel].uuid offset:page limit:LIMIT keyValue:self.filterString Completion:^(int code, id content) {
        [self refreshTable];
        [self loadMoreDataToTable];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            if(page == 0){
                [self.data removeAllObjects];
            }
            [self.data addObjectsFromArray:[BeiYaoQingRenModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]]];
            self.total = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
            self.lbAmount.text = [NSString stringWithFormat:@"共%ld人", (long)self.total];
            [self.pulltable reloadData];
        }

    }];
}

#pragma UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.data count] == 0){
        if(!self.addview){
            self.addview = [[BackGroundView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 2 / 5, ScreenWidth, 100)];
            self.addview.delegate = self;
            self.addview.lbTitle.text = @"暂无邀请，赶快邀请好友进来吧！";
            [self.addview.btnAdd setTitle:@"立即邀请" forState:UIControlStateNormal];
        }else{
            [self.addview removeFromSuperview];
        }
        [self.pulltable addSubview:self.addview];
    }
    else{
        [self.addview removeFromSuperview];
    }
    
    return [self.data count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    InviteListsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"InviteListsTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BrokerInfoModel *model = [self.data objectAtIndex:indexPath.row];
    
    UIImage *image = ThemeImage(@"list_user_head");
//    if(model.userSex == 2)
//    {
//        image = ThemeImage(@"list_user_famale");
//    }
    CGSize size = cell.photoImage.frame.size;
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:FormatImage(model.headerImg, (int)size.width, (int)size.height)] placeholderImage:image];
    
    cell.lbPhone.text = model.phone;
    cell.lbName.text = [Util getUserNameWithModel:model];//mode
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
