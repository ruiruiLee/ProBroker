//
//  MyTeamInfoVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "MyTeamInfoVC.h"
#import "CustomerTableViewCell.h"
#import "BrokerInfoModel.h"
#import "ParentInfoModel.h"
#import "ProductInfoModel.h"
#import "UIImageView+WebCache.h"
#import "define.h"
#import "NetWorkHandler+queryUserTeamInfo.h"
#import "ProductSettingTableViewCell.h"

@interface MyTeamInfoVC ()
{
    UIImageView *iconview;
}

@property (nonatomic, strong) ParentInfoModel *parentModel;
@property (nonatomic, strong) NSArray *productList;
@property (nonatomic, strong) UITableView *productTable;
@property (nonatomic, strong) NSLayoutConstraint *headerTableVConstraint;
@property (nonatomic, strong) NSLayoutConstraint *footTableVConstraint;

@end

@implementation MyTeamInfoVC
@synthesize productTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.pulltable registerNib:[UINib nibWithNibName:@"CustomerTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
}

- (void) initHeaderView
{
    CGFloat bannerHeight = [Util getHeightByWidth:375 height:60 nwidth:ScreenWidth];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, bannerHeight + 4)];
    UIImageView *banner = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, bannerHeight)];
    banner.image  = ThemeImage(@"refund_banner");
    banner.userInteractionEnabled = YES;
    [header addSubview:banner];
    banner.translatesAutoresizingMaskIntoConstraints = NO;
    
    iconview = [[UIImageView alloc] initWithFrame:CGRectZero];
    [banner addSubview:iconview];
    iconview.translatesAutoresizingMaskIntoConstraints = NO;
    iconview.image = ThemeImage(@"zhankai");
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [banner addSubview:btn];
    [btn addTarget:self action:@selector(doBtnShowProductInfo:) forControlEvents:UIControlEventTouchUpInside];
    btn.selected = NO;
    
    self.productTable = [[UITableView alloc] initWithFrame:CGRectZero];
    [header addSubview:self.productTable];
    self.productTable.scrollEnabled = NO;
    self.productTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.productTable registerNib:[UINib nibWithNibName:@"ProductSettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"productcell"];
    self.productTable.delegate = self;
    self.productTable.dataSource = self;
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 4)];
    foot.backgroundColor = _COLOR(0xff, 0xaa, 0x7f);
    foot.translatesAutoresizingMaskIntoConstraints = NO;
    [header addSubview:foot];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(banner, btn, productTable, foot, iconview);
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[banner]-0-|" options:0 metrics:nil views:views]];
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[productTable]-0-|" options:0 metrics:nil views:views]];
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[foot]-0-|" options:0 metrics:nil views:views]];
    [banner addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[btn]-0-|" options:0 metrics:nil views:views]];
    [banner addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[iconview]-22-|" options:0 metrics:nil views:views]];
    [banner addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[btn]-0-|" options:0 metrics:nil views:views]];
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[banner]-0-[productTable]-0-[foot]-0-|" options:0 metrics:nil views:views]];
    
//    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"" options:0 metrics:nil views:views]];
    self.headerTableVConstraint = [NSLayoutConstraint constraintWithItem:self.productTable attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [header addConstraint:self.headerTableVConstraint];
    self.footTableVConstraint = [NSLayoutConstraint constraintWithItem:foot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [header addConstraint:self.footTableVConstraint];
    
    [banner addConstraint:[NSLayoutConstraint constraintWithItem:iconview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:banner attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    self.pulltable.tableHeaderView = header;
}

- (void) initSubViews
{
    self.pulltable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 580) style:UITableViewStyleGrouped];
    [self.view addSubview:self.pulltable];
    self.pulltable.delegate = self;
    self.pulltable.dataSource = self;
    self.pulltable.pullDelegate = self;
    self.pulltable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pulltable.translatesAutoresizingMaskIntoConstraints = NO;
    self.pulltable.backgroundColor = [UIColor clearColor];
    
    self.pulltable.tableFooterView = [[UIView alloc] init];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 20);
    self.pulltable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.pulltable.separatorColor = _COLOR(0xe6, 0xe6, 0xe6);
    if ([self.pulltable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.pulltable setSeparatorInset:insets];
    }
    if ([self.pulltable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.pulltable setLayoutMargins:insets];
    }
    
    //弹出下拉刷新控件刷新数据
    self.pulltable.pullTableIsRefreshing = YES;
    //    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3];
    PullTableView *pulltable = self.pulltable;
    NSDictionary *views = NSDictionaryOfVariableBindings(pulltable);
    
    self.vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pulltable]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.vConstraints];
    
    self.hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pulltable]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.hConstraints];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doBtnShowProductInfo:(UIButton *)sender
{
    if(self.productList == nil){
        [Util showAlertMessage:@"正在获取产品信息，请稍后再试！"];
    }
    else{
        BOOL selected = sender.selected;
        CGFloat bannerHeight = [Util getHeightByWidth:375 height:60 nwidth:ScreenWidth];
        UIView *header = self.pulltable.tableHeaderView;
        if(!selected){
            self.headerTableVConstraint.constant = [self.productList count] * 60;
            self.footTableVConstraint.constant = 4;
            sender.selected = YES;
            iconview.image = ThemeImage(@"shouqi");
        }else{
            self.headerTableVConstraint.constant = 0;
            self.footTableVConstraint.constant = 0;
            sender.selected = NO;
            iconview.image = ThemeImage(@"zhankai");
        }
        
        header.frame = CGRectMake(0, 0, ScreenWidth, self.headerTableVConstraint.constant + self.footTableVConstraint.constant + bannerHeight);
        self.pulltable.tableHeaderView = header;
    }
}

#pragma UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.productTable)
        return 1;
    else
        return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.productTable)
    {
        return [self.productList count];
    }
    else{
        if(section == 1)
            return [self.data count];
        else
            return 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.productTable){
        return 60.f;
    }
    else
        return 68.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.productTable){
        NSString *deq = @"productcell";
        ProductSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
        if(!cell){
            cell = [[ProductSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ProductInfoModel *model = [self.productList objectAtIndex:indexPath.row];
        [cell.logo sd_setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:Normal_Image];
        cell.lbAccount.text = model.productName;
        //    cell.lbDetail.text = [NSString stringWithFormat:@"%.2f%@", model.productRatio, @"%"];
        if (model.productMaxRatioStr == nil ){
            cell.lbDetail.text = @"未设置";
        }
        else{
            cell.lbDetail.text = [NSString stringWithFormat:@"%d-%d%@", (int)model.productMinRatio, (int)model.productMaxRatio, @"%"];
        }
        return cell;
    }
    else{
        if(indexPath.section == 0){
            NSString *deq = @"cell1";
            CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
            if(!cell){
                cell = [[CustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIButton *btnRing = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            [btnRing setImage:ThemeImage(@"call") forState:UIControlStateNormal];
            cell.accessoryView = btnRing;
            [btnRing addTarget:self action:@selector(doBtnRing:) forControlEvents:UIControlEventTouchUpInside];
            
            ParentInfoModel *model = self.parentModel;
            cell.timerWidth.constant = 0;
            if(model == nil)
                cell.accessoryView.hidden = YES;
            else
                cell.accessoryView.hidden = NO;
            
            UIImage *image = ThemeImage(@"list_user_head");
            if(model.parentUserSex == 2)
            {
                image = ThemeImage(@"list_user_famale");
            }
            
            [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:model.parentHeaderImg] placeholderImage:image];
            cell.logoImage.hidden = YES;
            cell.lbTimr.hidden = YES;
            cell.lbName.text = model.parentUserName;
            cell.lbStatus.text = model.parentPhone;
            cell.lbStatus.textColor = _COLOR(0x75, 0x75, 0x75);
            cell.lbStatus.font = _FONT(12);
            cell.width.constant = 16;
            cell.height.constant = 16;
            
            return cell;
        }
        else{
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
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(tableView == self.pulltable){
        if(indexPath.section == 1){
            UserDetailVC *vc = [IBUIFactory CreateUserDetailVC];
            BrokerInfoModel *model = [self.data objectAtIndex:indexPath.row];
            vc.userId = model.userId;
            vc.userHeadImg = model.headerImg;
            vc.title = [NSString stringWithFormat:@"%@的队员", self.name];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.productTable){
        return 0.01;
    }
    else
        return 40.f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.productTable){
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    view.backgroundColor = _COLOR(0xf5, 0xf5, 0xf5);
    
    UILabel *lbTitle = [ViewFactory CreateLabelViewWithFont:_FONT(15) TextColor:_COLOR(0x21, 0x21, 0x21)];
    [view addSubview:lbTitle];
    lbTitle.text = self.toptitle;
    
    UILabel *lbAmount = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0xcc, 0xcc, 0xcc)];
    [view addSubview:lbAmount];
    lbAmount.textAlignment = NSTextAlignmentRight;
    if(section == 0){
        lbTitle.text = @"我的团长";
        lbAmount.text = @"";
    }
    else{
        lbTitle.text = @"我的队员";
        lbAmount.text = [NSString stringWithFormat:@"共%d人", [self.data count]];
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(lbTitle, lbAmount);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbTitle]->=10-[lbAmount]-20-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbTitle]-0-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbAmount]-0-|" options:0 metrics:nil views:views]];
    
    return view;
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

- (void) refresh2Loaddata
{
    NSLog(@"refresh2Loaddata");
    self.pageNum = 0;
    [self loadDataInPages:self.pageNum];
    [self loadUserTeamInfo];
}

- (void) loadUserTeamInfo
{
    [NetWorkHandler requestToQueryUserTeamInfo:self.userid Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            ParentInfoModel *model = (ParentInfoModel*)[ParentInfoModel modelFromDictionary:[content objectForKey:@"data"]];
            self.parentModel = model;
            NSArray *array = [ProductInfoModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"ratioMaps"]];
            self.productList = array;
            [self.pulltable reloadData];
            [self.productTable reloadData];
        }
    }];
}

- (void) doBtnRing:(id) sender
{
    if(self.parentModel == nil){
        [Util showAlertMessage:@"数据获取中，请稍后！"];
    }
    else{
        NSString *phone = self.parentModel.parentPhone;
        NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",phone]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
        
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:num];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        //记得添加到view上
        [self.view addSubview:callWebview];
    }
}

@end
