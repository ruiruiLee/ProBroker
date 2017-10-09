//
//  MyTeamInfoVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "MyTeamInfoVC.h"
#import "TeamListTableViewCell.h"
#import "TeamItemTableViewCell.h"
#import "BrokerInfoModel.h"
#import "ParentInfoModel.h"
#import "ProductInfoModel.h"
#import "UIImageView+WebCache.h"
#import "define.h"
#import "NetWorkHandler+queryUserTeamInfo.h"
#import "ProductSettingTableViewCell.h"
#import "NetWorkHandler+updateUserRemarkName.h"
#import "HMPopUpView.h"
#import "UUInputAccessoryView.h"
#import "NetWorkHandler+privateLetter.h"
#import "IQKeyboardManager.h"
#import "LeftImgButton.h"

@interface MyTeamInfoVC () <HMPopUpViewDelegate>
{
    UIImageView *iconview;
    HMPopUpView *hmPopUp;
}

@property (nonatomic, strong) ParentInfoModel *parentModel;
@property (nonatomic, strong) NSLayoutConstraint *headerTableVConstraint;
@property (nonatomic, strong) NSLayoutConstraint *footTableVConstraint;

@end

@implementation MyTeamInfoVC
@synthesize filterString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.inviteUser
//    [self.pulltable registerNib:[UINib nibWithNibName:@"TeamItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    
    UIButton *btnDetail = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
    [btnDetail setTitle:@"了解更多" forState:UIControlStateNormal];
    btnDetail.layer.cornerRadius = 12;
    btnDetail.layer.borderWidth = 0.5;
    btnDetail.layer.borderColor = _COLOR(0xff, 0x66, 0x19).CGColor;
    [btnDetail setTitleColor:_COLOR(0xff, 0x66, 0x19) forState:UIControlStateNormal];
    btnDetail.titleLabel.font = _FONT(12);
    [self setRightBarButtonWithButton:btnDetail];
    
    filterString = nil;
}

//此函数不能删
- (void) initHeaderView
{
    
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
    self.pulltable.backgroundColor = [UIColor whiteColor];
    
    self.pulltable.tableFooterView = [[UIView alloc] init];
    self.pulltable.tableFooterView.backgroundColor = [UIColor whiteColor];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 20);
    self.pulltable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.pulltable.separatorColor = SepLineColor;
    if ([self.pulltable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.pulltable setSeparatorInset:insets];
    }
    if ([self.pulltable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.pulltable setLayoutMargins:insets];
    }
    
    //弹出下拉刷新控件刷新数据
    self.pulltable.pullTableIsRefreshing = YES;
    PullTableView *pulltable = self.pulltable;
    NSDictionary *views = NSDictionaryOfVariableBindings(pulltable);
    
    self.vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pulltable]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.vConstraints];
    
    self.hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pulltable]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.hConstraints];
    
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    self.searchbar.placeholder = @"搜索";
    self.searchbar.showsCancelButton = YES;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    self.searchbar.delegate = self;
    self.pulltable.tableHeaderView = self.searchbar;
    
    [self.pulltable registerNib:[UINib nibWithNibName:@"TeamListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (BOOL) resignFirstResponder
{
    [hmPopUp.txtField resignFirstResponder];
    [hmPopUp hide];
    
    return [super resignFirstResponder];
}

- (void) handleLeftBarButtonClicked:(id)sender
{
    [self resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) handleRightBarButtonClicked:(id)sender
{
    [self resignFirstResponder];
//    [super handleRightBarButtonClicked:sender];
    WebViewController *web = [IBUIFactory CreateWebViewController];
    web.title = @"了解更多";
    NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", ABOUT_TEAM];
    [web loadHtmlFromUrl:url];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

#pragma UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.data count] == 0){
        if(!self.addview){
            self.addview = [[BackGroundView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 2 / 5, ScreenWidth, 100)];
            self.addview.delegate = self;
            self.addview.lbTitle.text = @"暂无队员，邀请好友组建你的团队吧";
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
    return 88;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    TeamListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"TeamListTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    BrokerInfoModel *model = [self.data objectAtIndex:indexPath.row];
    
    UIImage *image = ThemeImage(@"list_user_head");
    if(model.userSex == 2)
    {
        image = ThemeImage(@"list_user_famale");
    }
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
    
    if(model.status == 2){
        cell.logoImage.hidden = NO;
        cell.logoImage.image = ThemeImage(@"my_invited");
    }
    
    cell.lbPhone.text = model.phone;
    cell.lbName.text = [Util getUserNameWithModel:model];//model.userName;
    cell.lbStatus.textColor = _COLOR(0x75, 0x75, 0x75);
    cell.lbStatus.font = _FONT(10);
    cell.lbStatus.attributedText = [self getOrderDetailString:model.month_zcgddbf orderValue:model.day_zcgddbf];
    cell.lbSubStatus.textColor = _COLOR(0x75, 0x75, 0x75);
    cell.lbSubStatus.font = _FONT(10);
    cell.lbSubStatus.attributedText = [self getOrderAmount:model.month_zbjcs offer:model.day_zbjcs];
//    cell.btnRemark.hidden = NO;
    cell.btnRemark.tag = 100 + indexPath.row;
//    cell.lbSubStatus.hidden = NO;
    if(model.remarkName != nil && [model.remarkName length] > 0)
        [cell.btnRemark setTitle:[NSString stringWithFormat:@"（%@）", model.remarkName] forState:UIControlStateNormal];
    else
        [cell.btnRemark setTitle:@"（备注）" forState:UIControlStateNormal];
    
    cell.lbSource.text = [NSString stringWithFormat:@"来源：%@", model.yqrRealName];
    
    [cell.btnRemark addTarget:self action:@selector(doBtnModifyRemarkName:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BrokerInfoModel *model = [self.data objectAtIndex:indexPath.row];
    if(model.status ==2){
        [Util showAlertMessage:@"该用户还未加入优快保，赶快联系他吧!"];
        return;
    }
    UserDetailVC *vc = [IBUIFactory CreateUserDetailVC];
    
//            vc.userId = model.userId;
//            vc.userHeadImg = model.headerImg;
    vc.brokerInfo = model;
    vc.title = [NSString stringWithFormat:@"%@的队员", self.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    view.backgroundColor = _COLOR(0xf5, 0xf5, 0xf5);
    
    UIImageView *imgV = [[UIImageView alloc] init];
    [view addSubview:imgV];
    imgV.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *lbTitle = [ViewFactory CreateLabelViewWithFont:_FONT(15) TextColor:_COLOR(0x21, 0x21, 0x21)];
    [view addSubview:lbTitle];
    lbTitle.text = self.toptitle;
    
    UILabel *lbAmount = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0x75, 0x75, 0x75)];
    [view addSubview:lbAmount];
    lbAmount.textAlignment = NSTextAlignmentRight;
    
    LeftImgButton *button = [[LeftImgButton alloc] initWithFrame:CGRectZero];
    [button setImage:ThemeImage(@"add_icon") forState:UIControlStateNormal];
    [button setTitle:@"邀请" forState:UIControlStateNormal];
    [button setTitleColor:_COLOR(0x21, 0x21, 0x21) forState:UIControlStateNormal];
    button.titleLabel.font = _FONT(15);
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:button];
    [button addTarget:self action:@selector(doBtnInvite:) forControlEvents:UIControlEventTouchUpInside];
    
    lbTitle.text = @"人员数量";
    imgV.image = ThemeImage(@"my_team");
    lbAmount.text = [NSString stringWithFormat:@"(共%ld人)", (long)self.total];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(lbTitle, lbAmount, imgV, button);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[imgV(25)]-4-[lbTitle]-6-[lbAmount]->=10-[button(56)]-20-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[button(40)]->=0-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbTitle(40)]->=0-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imgV(18)]->=0-|" options:0 metrics:nil views:views]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:lbAmount attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:imgV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    return view;
}

- (void) doBtnInvite:(UIButton *)sender
{
    [self resignFirstResponder];
    [super handleRightBarButtonClicked:sender];
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

- (void) doBtnChat:(id) sender
{
    //TODO
    UIKeyboardType type = UIKeyboardTypeDefault;
    NSString *content = @"";
    
    [UUInputAccessoryView showKeyboardType:type
                                   content:content
                                     Block:^(NSString *contentStr)
     {
         if (contentStr.length == 0) return ;
         UserInfoModel *model = [UserInfoModel shareUserInfoModel];
         NSString *senderName = [Util getUserName:model];
         if(!senderName)
             senderName = model.phone;
         NSString *title = [NSString stringWithFormat:@"%@给你发了一条私信", senderName];
         [NetWorkHandler requestToPostPrivateLetter:self.parentModel.parentUserId title:title content:contentStr senderId:model.userId senderName:senderName Completion:^(int code, id content) {
             [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
             if(code == 200){
                 
                 long long datenew = [[content objectForKey:@"lastNewsDt"] longLongValue];
                 
                 // 加入本地文件
                 [[AppContext sharedAppContext]UpdateNewsTipTime:datenew category: [[content objectForKey:@"category"] integerValue]];
                 [self performSelector:@selector(showMessageSuccess) withObject:nil afterDelay:0.5];
             }
             else{
                 [self performSelector:@selector(showMessageFail) withObject:nil afterDelay:0.5];
             }
         }];
     }];
}

- (void) showMessageSuccess
{
    [Util showAlertMessage:@"消息发送成功！"];
}

- (void) showMessageFail
{
    [Util showAlertMessage:@"消息发送失败！"];
}

- (void) doBtnModifyRemarkName:(UIButton *) sender
{
    NSInteger idx = sender.tag - 100;
    if(idx >= 0 && idx < [self.data count]){
        BrokerInfoModel *model = [self.data objectAtIndex:idx];
        hmPopUp = [[HMPopUpView alloc] initWithTitle:@"修改备注" okButtonTitle:@"确定" cancelButtonTitle:@"取消" delegate:self];
        hmPopUp.transitionType = HMPopUpTransitionTypePopFromBottom;
        hmPopUp.dismissType = HMPopUpDismissTypeFadeOutTop;
        [hmPopUp showInView:self.view];
        hmPopUp.txtField.placeholder = @"输入备注名";
        hmPopUp.txtField.text = model.remarkName;
        hmPopUp.tag = sender.tag;
    }
}

#pragma HMPopUpViewDelegate
- (void) popUpView:(HMPopUpView *)view accepted:(BOOL)accept inputText:(NSString *)text

{
    if(!accept)
        return;
    
    if([text length] == 0){
        return;
    }
    
    NSInteger idx = view.tag - 100;
    BrokerInfoModel *model = [self.data objectAtIndex:idx];
    [NetWorkHandler requestToUpdateUserRemarkName:model.userId remarkName:text Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            model.remarkName = text;
            [self.pulltable reloadData];
        }
    }];
}

- (void) notifyToAddNewCustomer:(BackGroundView *) view
{
    [self doBtnInvite:nil];
}

#pragma UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchbar resignFirstResponder];
    filterString = self.searchbar.text;
    self.pageNum = 0;
    [self loadDataInPages:self.pageNum];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchbar resignFirstResponder];
    self.searchbar.text = @"";
    filterString = @"";
    self.pageNum = 0;
    [self loadDataInPages:self.pageNum];
}

@end
