//
//  MyTeamsVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/31.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "MyTeamsVC.h"
#import "define.h"
#import "TeamListTableViewCell.h"
#import "PotentialPlayersVC.h"
#import "NetWorkHandler+queryForPageList.h"
#import "BrokerInfoModel.h"
#import "NetWorkHandler+queryUserTaskList.h"
#import "TasksModel.h"
#import "InviteFriendsVC.h"
#import "SelectCustomerVC.h"
#import "UIImageView+WebCache.h"
#import "SepLineLabel.h"
#import "NetWorkHandler+queryUserTeamSellTj.h"

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
        self.total = 0;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if([UserInfoModel shareUserInfoModel].possessTeamStatus)
    [self setRightBarButtonWithImage:ThemeImage(@"inviteUser")];

    [self.pulltable registerNib:[UINib nibWithNibName:@"TeamListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.pulltable.backgroundColor = [UIColor whiteColor];
    self.pulltable.tableFooterView = [[UIView alloc] init];
    self.pulltable.tableFooterView.backgroundColor = [UIColor whiteColor];
    
    [self initHeaderView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void) handleRightBarButtonClicked:(id)sender
{
    NewUserModel *model = [App_Delegate workBanner];
    if(model.isRedirect){
        WebViewController *web = [IBUIFactory CreateWebViewController];
        web.title = model.title;
        web.type = enumShareTypeShare;
        web.shareTitle = model.title;
        web.shareContent = model.content;
        [self.navigationController pushViewController:web animated:YES];
        if(model.url){
            [web loadHtmlFromUrlWithUuId:[NSString stringWithFormat:@"%@", model.url]];
        }else{
            NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", model.nid];
            [web loadHtmlFromUrlWithUuId:[NSString stringWithFormat:@"%@",url]];
        }
    }
}


- (void) initHeaderView
{
    UIView *headerview = nil;
    UIImageView *footview = nil;
    
    headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 118)];
    footview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    footview.backgroundColor = _COLOR(0xf5, 0xf5, 0xf5);
    [headerview addSubview:footview];
//    footview.image = ThemeImage(@"shadow");
    footview.userInteractionEnabled = YES;
    
    UIImageView *imgV = [[UIImageView alloc] init];
    [footview addSubview:imgV];
    imgV.image = ThemeImage(@"my_team");
    imgV.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *lbTitle = [ViewFactory CreateLabelViewWithFont:_FONT(15) TextColor:_COLOR(0x21, 0x21, 0x21)];
    [footview addSubview:lbTitle];
    lbTitle.text = self.toptitle;
    
    lbAmount = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0x75, 0x75, 0x75)];
    [footview addSubview:lbAmount];
    lbAmount.textAlignment = NSTextAlignmentRight;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(lbTitle, lbAmount, imgV);
//    [footview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbTitle]->=10-[lbAmount]-20-|" options:0 metrics:nil views:views]];
    [footview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbTitle]-0-|" options:0 metrics:nil views:views]];
    [footview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbAmount]-0-|" options:0 metrics:nil views:views]];
    [footview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[imgV(25)]-6-[lbTitle]-6-[lbAmount]-20-|" options:0 metrics:nil views:views]];
    [footview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgV(18)]->=0-|" options:0 metrics:nil views:views]];
    [footview addConstraint:[NSLayoutConstraint constraintWithItem:imgV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    if(self.total > 0)
    {
        UIView *teamview = [self createTeamTotalInfo];
        [headerview addSubview:teamview];
        headerview.frame = CGRectMake(0, 0, ScreenWidth, 118);
    }else{
        headerview.frame = CGRectMake(0, 0, ScreenWidth, 40);
    }
    
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

//- (void) handleRightBarButtonClicked:(id)sender
//{
//    PotentialPlayersVC *vc = [[PotentialPlayersVC alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void) loadDataInPages:(NSInteger)page
{
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    [rules addObject:[self getRulesByField:@"parentUserId" op:@"eq" data:self.userid]];
    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    if(page == 0)
        [self loadUserTeamSellTj];
    
    [NetWorkHandler requestUserQueryForPageList:page limit:LIMIT sord:@"desc" sidx:@"U_UserDataStatisticsNow.nowMonthOrderSuccessNums" filters:filters Completion:^(int code, id content) {
        [self refreshTable];
        [self loadMoreDataToTable];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            if(page == 0){
                [self.data removeAllObjects];
            }
            [self.data addObjectsFromArray:[BrokerInfoModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]]];
            self.total = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
            lbAmount.text = [NSString stringWithFormat:@"共%ld人", (long)self.total];
            [self.pulltable reloadData];
        }
    }];
}

- (void) loadUserTeamSellTj
{
    [NetWorkHandler requestToQueryUserTeamSellTj:self.userid Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            self.teamInfo = (RatioMapsModel*)[RatioMapsModel modelFromDictionary:[content objectForKey:@"data"]];
            
            self.lbMonth.attributedText = [Util getAttributeString:[NSString stringWithFormat:@"团队成员本月累计销售 %@元", [Util getDecimalStyle:[self.teamInfo.month_zcgddbf floatValue]]] substr:[Util getDecimalStyle:[self.teamInfo.month_zcgddbf floatValue]]];
            self.lbDay.attributedText = [Util getAttributeString:[NSString stringWithFormat:@"团队成员今日累计销售 %@元", [Util getDecimalStyle:[self.teamInfo.day_zcgddbf floatValue]]] substr:[Util getDecimalStyle:[self.teamInfo.day_zcgddbf floatValue]]];
            self.lbUpdateTime.text =  self.teamInfo.tjTime;
            
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
    return 88.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    TeamListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
//        cell = [[CustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"TeamListTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnRemark.hidden = YES;
    
    BrokerInfoModel *model = [self.data objectAtIndex:indexPath.row];
    
    UIImage *image = ThemeImage(@"list_user_head");
    if(model.userSex == 2)
    {
        image = ThemeImage(@"list_user_famale");
    }

//    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:model.headerImg] placeholderImage:image];
    CGSize size = cell.photoImage.frame.size;
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:FormatImage(model.headerImg, (int)size.width, (int)size.height)] placeholderImage:image];
    cell.logoImage.hidden = NO;
    if(indexPath.row == 0)
        cell.logoImage.image = ThemeImage(@"award_1");
    else if(indexPath.row == 1)
        cell.logoImage.image = ThemeImage(@"award_02");
    else if (indexPath.row == 2)
        cell.logoImage.image = ThemeImage(@"award_03");
    else
        cell.logoImage.hidden = YES;

    cell.lbName.text = [Util getUserNameWithModel:model];//model.userName;
//    cell.lbStatus.text = [NSString stringWithFormat:@"累计%d单", model.orderSuccessNums];
    cell.lbStatus.textColor = _COLOR(0x75, 0x75, 0x75);
    cell.lbStatus.font = _FONT(10);
    cell.lbStatus.attributedText = [self getOrderDetailString:model.month_zcgddbf orderValue:model.day_zcgddbf];
    cell.lbSubStatus.textColor = _COLOR(0x75, 0x75, 0x75);
    cell.lbSubStatus.font = _FONT(10);
    cell.lbSubStatus.attributedText = [self getOrderAmount:model.month_zbjcs offer:model.day_zbjcs];
    
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

- (NSAttributedString *) getOrderDetailString:(CGFloat) amount orderValue:(CGFloat) orderValue
{
    NSString *sub1 = [NSString stringWithFormat:@"本月销售 %@元, ", [Util getDecimalStyle:amount]];
    NSMutableAttributedString *mstring1 = [[NSMutableAttributedString alloc] initWithString:sub1];
    NSRange range = [sub1 rangeOfString:[NSString stringWithFormat:@"%@", [Util getDecimalStyle:amount]]];
    [mstring1 addAttribute:NSForegroundColorAttributeName value:_COLOR(0xff, 0x66, 0x19) range:range];
    [mstring1 addAttribute:NSFontAttributeName value:_FONT(13) range:range];
    
    NSString *sub2 = [NSString stringWithFormat:@"今日销售 %@元", [Util getDecimalStyle:orderValue]];
    NSMutableAttributedString *mstring2 = [[NSMutableAttributedString alloc] initWithString:sub2];
    range = [sub2 rangeOfString:[NSString stringWithFormat:@"%@", [Util getDecimalStyle:orderValue]]];
    [mstring2 addAttribute:NSForegroundColorAttributeName value:_COLOR(0xff, 0x66, 0x19) range:range];
    [mstring2 addAttribute:NSFontAttributeName value:_FONT(13) range:range];
    
    [mstring1 appendAttributedString:mstring2];
    
    return mstring1;
}

- (NSAttributedString *) getOrderAmount:(NSInteger) insure offer:(NSInteger) offer
{
    NSString *sub1 = [NSString stringWithFormat:@"今日报价 %ld 次, ", (long)offer];
    NSMutableAttributedString *mstring1 = [[NSMutableAttributedString alloc] initWithString:sub1];
    NSRange range = [sub1 rangeOfString:[NSString stringWithFormat:@"%ld", (long)offer]];
    [mstring1 addAttribute:NSForegroundColorAttributeName value:_COLOR(0xff, 0x66, 0x19) range:range];
    [mstring1 addAttribute:NSFontAttributeName value:_FONT(13) range:range];
    
    NSString *sub2 = [NSString stringWithFormat:@"投保 %ld 单", (long)insure];
    NSMutableAttributedString *mstring2 = [[NSMutableAttributedString alloc] initWithString:sub2];
    range = [sub2 rangeOfString:[NSString stringWithFormat:@"%ld", (long)insure]];
    [mstring2 addAttribute:NSForegroundColorAttributeName value:_COLOR(0xff, 0x66, 0x19) range:range];
    [mstring2 addAttribute:NSFontAttributeName value:_FONT(13) range:range];
    
    [mstring1 appendAttributedString:mstring2];
    
    return mstring1;
}

- (UIView *) createTeamTotalInfo
{
    UIView *teamView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 78)];
    teamView.backgroundColor = [UIColor whiteColor];
    
    UIView *total = [[UIView alloc] initWithFrame:CGRectZero];
    [teamView addSubview:total];
    total.translatesAutoresizingMaskIntoConstraints = NO;
    total.backgroundColor = _COLOR(0xff, 0x66, 0x19);
    
    self.lbUpdateTime = [ViewFactory CreateLabelViewWithFont:_FONT_B(13) TextColor:[UIColor whiteColor]];
    [total addSubview:self.lbUpdateTime];
    self.lbUpdateTime.text = @"截止统计时间：";
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
    logo.translatesAutoresizingMaskIntoConstraints = NO;
    [teamView addSubview:logo];
    logo.image = ThemeImage(@"totalimage");
    
    self.lbMonth = [ViewFactory CreateLabelViewWithFont:_FONT(13) TextColor:_COLOR(0x75, 0x75, 0x75)];
    [teamView addSubview:self.lbMonth];
    self.lbMonth.attributedText = [Util getAttributeString:[NSString stringWithFormat:@"团队成员月累计销售保费 %@元", [Util getDecimalStyle:[self.teamInfo.month_zcgddbf floatValue]]] substr:[Util getDecimalStyle:[self.teamInfo.month_zcgddbf floatValue]]];
    
    self.lbDay = [ViewFactory CreateLabelViewWithFont:_FONT(13) TextColor:_COLOR(0x75, 0x75, 0x75)];
    [teamView addSubview:self.lbDay];
    self.lbDay.attributedText = [Util getAttributeString:[NSString stringWithFormat:@"团队成员日累计销售保费 %@元", [Util getDecimalStyle:[self.teamInfo.day_zcgddbf floatValue]]] substr:[Util getDecimalStyle:[self.teamInfo.day_zcgddbf floatValue]]];
    
    SepLineLabel *lbLine = [[SepLineLabel alloc] initWithFrame:CGRectZero];
    lbLine.translatesAutoresizingMaskIntoConstraints = NO;
    [teamView addSubview:lbLine];
    
    UILabel *lbMonth = self.lbMonth;
    UILabel *lbDay = self.lbDay;
    UILabel *lbUpdateTime = self.lbUpdateTime;
    NSDictionary *views1 = NSDictionaryOfVariableBindings(logo, lbMonth, lbDay, lbLine, lbUpdateTime, total);
    
    [teamView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[total]-0-|" options:0 metrics:nil views:views1]];
    [teamView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[logo(35)]-11-[lbMonth]-16-|" options:0 metrics:nil views:views1]];
    [teamView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[logo]-11-[lbDay]-16-|" options:0 metrics:nil views:views1]];
    [teamView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[lbLine]-0-|" options:0 metrics:nil views:views1]];
    [teamView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[total(20)]-13-[logo(31)]-13-[lbLine(1)]-0-|" options:0 metrics:nil views:views1]];
    
    [teamView addConstraint:[NSLayoutConstraint constraintWithItem:lbMonth attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:logo attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [teamView addConstraint:[NSLayoutConstraint constraintWithItem:lbDay attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:logo attribute:NSLayoutAttributeBottom multiplier:1 constant:2]];
    
    [teamView addConstraint:[NSLayoutConstraint constraintWithItem:lbUpdateTime attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:teamView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-1]];
    
    [total addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbUpdateTime]-0-|" options:0 metrics:nil views:views1]];
    
    self.lbMonth.attributedText = [Util getAttributeString:[NSString stringWithFormat:@"团队成员月累计销售保费 %@元", [Util getDecimalStyle:[self.teamInfo.month_zcgddbf floatValue]]] substr:[Util getDecimalStyle:[self.teamInfo.month_zcgddbf floatValue]]];
    self.lbDay.attributedText = [Util getAttributeString:[NSString stringWithFormat:@"团队成员日累计销售保费 %@元", [Util getDecimalStyle:[self.teamInfo.day_zcgddbf floatValue]]] substr:[Util getDecimalStyle:[self.teamInfo.day_zcgddbf floatValue]]];
    self.lbUpdateTime.text =  self.teamInfo.tjTime;
    
    return teamView;
}

@end
