//
//  MyTeamsVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/31.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "MyTeamsVC.h"
#import "define.h"
#import "CustomerTableViewCell.h"
#import "PotentialPlayersVC.h"
#import "NetWorkHandler+queryForPageList.h"
#import "BrokerInfoModel.h"
#import "NetWorkHandler+queryUserTaskList.h"
#import "TasksModel.h"
#import "InviteFriendsVC.h"
#import "SelectCustomerVC.h"
#import "UIImageView+WebCache.h"

@interface MyTeamsVC ()
{
    UILabel *lbAmount;
    //renwu1
    UILabel *lbTasks1;
    UIButton *btnTasks1;
    UILabel *lbtask1Title;
    //renwu2
    UILabel *lbTasks2;
    UIButton *btnTasks2;
    UILabel *lbtask2Title;
    
    NSArray *_taskArray;
}

@end

@implementation MyTeamsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
//    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
//     CGFloat h = [Util getHeightByWidth:3 height:1 nwidth:ScreenWidth];
    UIView *headerview = nil;
    UIImageView *footview = nil;

        headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        footview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [headerview addSubview:footview];
        footview.image = ThemeImage(@"shadow");
        footview.userInteractionEnabled = YES;
//    }
    
    UILabel *lbTitle = [ViewFactory CreateLabelViewWithFont:_FONT(15) TextColor:_COLOR(0x21, 0x21, 0x21)];
    [footview addSubview:lbTitle];
    lbTitle.text = self.toptitle;
    
    lbAmount = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0xcc, 0xcc, 0xcc)];
    [footview addSubview:lbAmount];
    lbAmount.textAlignment = NSTextAlignmentRight;
//    lbAmount.text = @"共3人";
    
    NSDictionary *views = NSDictionaryOfVariableBindings(lbTitle, lbAmount);
    [footview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbTitle]->=10-[lbAmount]-20-|" options:0 metrics:nil views:views]];
    [footview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbTitle]-0-|" options:0 metrics:nil views:views]];
    [footview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbAmount]-0-|" options:0 metrics:nil views:views]];
    
    
    self.pulltable.tableHeaderView = headerview;
    [self.pulltable registerNib:[UINib nibWithNibName:@"CustomerTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.pulltable.backgroundColor = [UIColor clearColor];
    self.pulltable.tableFooterView = [[UIView alloc] init];
}

- (void) doBtnInviteFriend:(UIButton *)sender
{
    if([self login]){
        InviteFriendsVC *vc = [[InviteFriendsVC alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) addTasksWithBg:(UIView *)bgview title:(NSString *) title content:(NSString *) content rect: (CGRect) rect idx:(NSInteger) idx
{
    UILabel *lbTitle = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0xff, 0xff, 0xff)];
    [bgview addSubview:lbTitle];
    lbTitle.text = title;
    lbTitle.translatesAutoresizingMaskIntoConstraints = YES;
    lbTitle.frame = CGRectMake(20, rect.origin.y, 140, rect.size.height);
    
    UIButton *btn = [[UIButton alloc] init];
    [bgview addSubview:btn];
    btn.layer.cornerRadius = 3;
    btn.frame = CGRectMake(ScreenWidth - 95, rect.origin.y, 75, rect.size.height);
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = _FONT(12);
    btn.hidden = YES;
    
    UILabel *lbContent = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0xff, 0xff, 0xff)];
    [bgview addSubview:lbContent];
    lbContent.textAlignment = NSTextAlignmentRight;
    lbContent.text = content;
    lbContent.translatesAutoresizingMaskIntoConstraints = YES;
    lbContent.frame = CGRectMake(ScreenWidth - 95 - 90, rect.origin.y, 70, rect.size.height-10);
    if(idx == 0){
        lbTasks1 = lbContent;
        btnTasks1 = btn;
        lbtask1Title = lbTitle;
        [btn addTarget:self action:@selector(doBtnShare:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        lbTasks2 = lbContent;
        btnTasks2 = btn;
        lbtask2Title = lbTitle;
        [btn addTarget:self action:@selector(doBtnOrdered:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (NSMutableAttributedString *) attstringWithString:(NSString *) string substr:(NSString *) substr font:(UIFont *) font color:(UIColor *)color
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRange range = [string rangeOfString:substr];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attributedString addAttribute:NSFontAttributeName value:font range:range];
    
    return attributedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleRightBarButtonClicked:(id)sender
{
    PotentialPlayersVC *vc = [[PotentialPlayersVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) loadDataInPages:(NSInteger)page
{
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
//    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
//    [rules addObject:[self getRulesByField:@"userId" op:@"eq" data:user.userId]];
    [rules addObject:[self getRulesByField:@"parentUserId" op:@"eq" data:self.userid]];
    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    
    [NetWorkHandler requestUserQueryForPageList:page limit:LIMIT sord:@"desc" sidx:@"U_UserDataStatistics.orderTotalSuccessNums" filters:filters Completion:^(int code, id content) {
        [self refreshTable];
        [self loadMoreDataToTable];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            if(page == 0){
                [self.data removeAllObjects];
            }
            [self.data addObjectsFromArray:[BrokerInfoModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]]];
            self.total = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
            lbAmount.text = [NSString stringWithFormat:@"共%d人", self.total];
            [self.pulltable reloadData];
        }
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

#pragma UITableViewDataSource

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
    return 68.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        cell = [[CustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    BrokerInfoModel *model = [self.data objectAtIndex:indexPath.row];
    
    cell.timerWidth.constant = 0;
    
    UIImage *image = ThemeImage(@"list_user_head");
    if(model.userSex == 2)
    {
        image = ThemeImage(@"list_user_famale");
    }
//    if(model.sex == 2)
//        image = ThemeImage(@"list_user_famale");
//    cell.photoImage.image = image;
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:model.headerImg] placeholderImage:image];
//    cell.logoImage.hidden = NO;
//    if(indexPath.row == 0)
//        cell.logoImage.image = ThemeImage(@"award_1");
//    else if(indexPath.row == 1)
//        cell.logoImage.image = ThemeImage(@"award_02");
//    else if (indexPath.row == 2)
//        cell.logoImage.image = ThemeImage(@"award_03");
//    else
        cell.logoImage.hidden = YES;
    cell.lbTimr.hidden = YES;
    cell.lbName.text = model.userName;
    cell.lbStatus.text = [NSString stringWithFormat:@"累计%d单", model.orderTotalSuccessNums];
    cell.lbStatus.textColor = _COLOR(0x75, 0x75, 0x75);
    cell.lbStatus.font = _FONT(12);
    cell.width.constant = 16;
    cell.height.constant = 16;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UserDetailVC *vc = [IBUIFactory CreateUserDetailVC];
    BrokerInfoModel *model = [self.data objectAtIndex:indexPath.row];
    vc.userId = model.userId;
    vc.title = [NSString stringWithFormat:@"%@的队员", self.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) doBtnShare:(UIButton *)sender
{
    InviteFriendsVC *vc = [[InviteFriendsVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) doBtnOrdered:(UIButton *)sender
{
    SelectCustomerVC *vc = [[SelectCustomerVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void) showNoDatasImage:(UIImage *) image
//{
//    if(!self.explainBgView){
//        self.explainBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
//        self.imgWithNoData = [[UIImageView alloc] initWithImage:image];
//        [self.explainBgView addSubview:self.imgWithNoData];
//        [self.pulltable addSubview:self.explainBgView];
//        self.explainBgView.center = CGPointMake(ScreenWidth/2, self.pulltable.frame.size.height*5/7);
//    }else{
//        self.explainBgView.center = CGPointMake(ScreenWidth/2, self.pulltable.frame.size.height*5/7);
//    }
//}

@end
