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

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
//        self.need = enumNotNeedIndicator;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.pulltable registerNib:[UINib nibWithNibName:@"CustomerTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.pulltable.backgroundColor = [UIColor clearColor];
    self.pulltable.tableFooterView = [[UIView alloc] init];
    
    [self initHeaderView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void) initHeaderView
{
    UIView *headerview = nil;
    UIImageView *footview = nil;
    
    headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    footview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    footview.backgroundColor = _COLOR(0xf5, 0xf5, 0xf5);
    [headerview addSubview:footview];
//    footview.image = ThemeImage(@"shadow");
    footview.userInteractionEnabled = YES;
    
    UILabel *lbTitle = [ViewFactory CreateLabelViewWithFont:_FONT(15) TextColor:_COLOR(0x21, 0x21, 0x21)];
    [footview addSubview:lbTitle];
    lbTitle.text = self.toptitle;
    
    lbAmount = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0xcc, 0xcc, 0xcc)];
    [footview addSubview:lbAmount];
    lbAmount.textAlignment = NSTextAlignmentRight;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(lbTitle, lbAmount);
    [footview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbTitle]->=10-[lbAmount]-20-|" options:0 metrics:nil views:views]];
    [footview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbTitle]-0-|" options:0 metrics:nil views:views]];
    [footview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbAmount]-0-|" options:0 metrics:nil views:views]];
    
    
    self.pulltable.tableHeaderView = headerview;
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

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BrokerInfoModel *model = [self.data objectAtIndex:indexPath.row];
    
    cell.timerWidth.constant = 0;
    
    UIImage *image = ThemeImage(@"list_user_head");
    if(model.userSex == 2)
    {
        image = ThemeImage(@"list_user_famale");
    }

    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:model.headerImg] placeholderImage:image];
    cell.logoImage.hidden = YES;
    cell.lbTimr.hidden = YES;
    cell.lbName.text = model.userName;
    cell.lbStatus.text = [NSString stringWithFormat:@"累计%d单", model.orderSuccessNums];
    cell.lbStatus.textColor = _COLOR(0x75, 0x75, 0x75);
    cell.lbStatus.font = _FONT(12);
    cell.width.constant = 16;
    cell.height.constant = 16;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    if(self.need == enumNotNeedIndicator){
//    }
//    else{
//        UserDetailVC *vc = [IBUIFactory CreateUserDetailVC];
//        BrokerInfoModel *model = [self.data objectAtIndex:indexPath.row];
//        vc.userId = model.userId;
//        vc.userHeadImg = model.headerImg;
//        vc.title = [NSString stringWithFormat:@"%@的队员", self.name];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 16, 0, 16);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:insets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:insets];
    }
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

@end
