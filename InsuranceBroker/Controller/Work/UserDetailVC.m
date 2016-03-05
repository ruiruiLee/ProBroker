//
//  UserDetailVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "UserDetailVC.h"
#import "define.h"
#import "NetWorkHandler+queryUserInfo.h"
#import "UIImageView+WebCache.h"
#import "NetWorkHandler+querySpecialtyUserInfo.h"
#import "ProductInfoModel.h"
#import "CommissionSetTableViewCell.h"
#import "NetWorkHandler+setSpecialtyUserProductRatio.h"
#import "MyTeamsVC.h"
#import <MessageUI/MessageUI.h>


@interface UserDetailVC ()<MFMessageComposeViewControllerDelegate, PickViewDelegate>
{
    PickView *_datePicker;
}

@property (nonatomic, strong) UserInfoModel *userinfo;
@property (nonatomic, strong) NSArray *productList;

@end

@implementation UserDetailVC
@synthesize userinfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.userinfo =  [[UserInfoModel alloc] init];
    UIImage *placeholderImage = ThemeImage(@"head_male");
    [self.photo sd_setImageWithURL:[NSURL URLWithString:self.brokerInfo.headerImg] placeholderImage:placeholderImage];
    
    self.scHConstraint.constant = ScreenWidth;
    self.photo.layer.cornerRadius = 27.5;
    self.photo.clipsToBounds = YES;
    [self.tableview registerNib:[UINib nibWithNibName:@"CommissionSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableview.scrollEnabled = NO;
    [self  loadData];
    [self loadCommissionInfo];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 16, 0, 16);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableview.separatorColor = _COLOR(0xe6, 0xe6, 0xe6);
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:insets];
    }
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableview setLayoutMargins:insets];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.gradientView setGradientColor:_COLOR(0xff, 0x8c, 0x19) end:_COLOR(0xff, 0x66, 0x19)];
}

- (void) resetViews
{
    self.lbName.text = self.userinfo.nickname;
    self.lbMobile.text = self.userinfo.phone;
    self.lbSubNum.text = [NSString stringWithFormat:@"%d人", self.userinfo.userTeamInviteNums];
//    [self.photo sd_setImageWithURL:[NSURL URLWithString:self.userinfo.headerImg] placeholderImage:Normal_Image];
    
    UIImage *placeholderImage = ThemeImage(@"head_male");
    if(self.userinfo.sex == 2)
        placeholderImage = ThemeImage(@"head_famale");
    [self.photo sd_setImageWithURL:[NSURL URLWithString:self.brokerInfo.headerImg] placeholderImage:placeholderImage];
    
    UserInfoModel *model = self.userinfo;
    
    self.lbMonthOrderSuccessNums.text = [NSString stringWithFormat:@"%d", model.nowMonthOrderSuccessNums];
    self.lbTotalOrderSuccessNums.text = [NSString stringWithFormat:@"累计订单：%d单", model.orderSuccessNums];
    self.lbMonthOrderEarn.text = [NSString stringWithFormat:@"%.2f", model.nowMonthOrderSuccessEarn];
    self.lbOrderEarn.text = [NSString stringWithFormat:@"累计收益：%.2f元", model.orderEarn];
}

- (void) loadData
{
    [NetWorkHandler requestToQueryUserInfo:self.brokerInfo.userId Completion:^(int code, id content) {
        [self  handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            [self.userinfo setDetailContentWithDictionary1:[content objectForKey:@"data"]];
            [self resetViews];
        }
    }];
}

- (void) loadCommissionInfo
{
    [NetWorkHandler requestToQuerySpecialtyUserInfo:self.brokerInfo.userId Completion:^(int code, id content) {
        [self  handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            self.productList = [ProductInfoModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"ratioMaps"]];
            self.tableVConstraint.constant = [self.productList count] * 60;
            [self.tableview reloadData];
        }
    }];
}

#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productList count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    CommissionSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CommissionSetTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ProductInfoModel *model = [self.productList objectAtIndex:indexPath.row];
    [cell.logo sd_setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:Normal_Image];
    cell.lbAccount.text = model.productName;
//    cell.lbDetail.text = [NSString stringWithFormat:@"%.2f%@", model.productRatio, @"%"];
    if (model.productRatioStr == nil ){
        cell.lbDetail.text = @"未设置";
    }
    else{
        cell.lbDetail.text = [NSString stringWithFormat:@"%d%@", (int)model.productRatio, @"%"];
    }
    cell.btnEdit.tag = indexPath.row;
    [cell.btnEdit addTarget:self action:@selector(doBtnModifyRatio:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma MFMessageComposeViewControllerDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        [Util showAlertMessage:@"该设备不支持短信功能"];
    }
}

#pragma ACTION
- (IBAction)doBtnTeams:(id)sender
{
    MyTeamsVC *vc = [[MyTeamsVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userid = self.brokerInfo.userId;
    vc.title = [NSString stringWithFormat:@"%@的团队", self.brokerInfo.userName];
    vc.toptitle = @"他的队员";
    vc.name = self.brokerInfo.userName;
    [self.navigationController pushViewController:vc animated:YES];
}

//拨打电话
- (IBAction) doBtnRing:(UIButton *)sender
{
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",self.userinfo.phone]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:num];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
    
}

- (IBAction) doBtnEmail:(UIButton *)sender
{
    NSArray *array = [NSArray arrayWithObject:self.userinfo.phone];
    [self showMessageView:array title:@"" body:@""];
}

- (IBAction) doBtnIncomeStatistics:(id)sender
{
    IncomeStatisticsVC *vc = [IBUIFactory CreateIncomeStatisticsViewController];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userId = self.brokerInfo.userId;
    vc.title = [NSString stringWithFormat:@"%@的收益统计", self.brokerInfo.userName];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doBtnSaleStatistics:(id)sender
{
    SalesStatisticsVC *vc = [IBUIFactory CreateSalesStatisticsViewController];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userId = self.brokerInfo.userId;
    vc.title = [NSString stringWithFormat:@"%@的销售统计", self.brokerInfo.userName];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) doBtnModifyRatio:(UIButton *)sender
{
    
    ProductInfoModel *model = [self.productList objectAtIndex:sender.tag];

    
    if(model.productMinRatioStr == nil || model.productMaxRatioStr == nil){
        [Util showAlertMessage:@"该产品还未设置折扣率，请联系你的上级设置！"];
        return;
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = (int)model.productMinRatio; i <= (int)model.productMaxRatio; i++) {
        [array addObject:[NSString stringWithFormat:@"%d%@", i, @"%"]];
    }
    
    [_datePicker removeFromSuperview];
    
    _datePicker = [[PickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
    _datePicker.delegate = self;
    _datePicker.lbTitle.text = [NSString stringWithFormat:@"%@,佣金范围(%d%@－%d%@)", model.productName, (int)model.productMinRatio, @"%", (int)model.productMaxRatio, @"%"];
    //    }
    [_datePicker show];
    _datePicker.tag = sender.tag;
    if(model.productRatio - model.productMinRatio < 0)
        [_datePicker setCurrentSelectIdx:0];
    else
        [_datePicker setCurrentSelectIdx:model.productRatio - model.productMinRatio];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat y = self.tableview.frame.origin.y + 50;//包含picker toolbar的50像素
        y += (sender.tag + 1) * 60;
        if(y - _datePicker.frame.origin.y > 0)
            self.scrollview.contentOffset = CGPointMake(0, y - _datePicker.frame.origin.y );
    }];
    
}

#pragma ZHPickViewDelegate

-(void)toobarDonBtnHaveClick:(PickView *)pickView resultString:(NSString *)resultString
{
    ProductInfoModel *model = [self.productList objectAtIndex:pickView.tag];
    [self submitRadio:model.productId productRatio:[resultString floatValue]];
    model.productRatio = [resultString floatValue];
    model.productRatioStr = [NSString stringWithFormat:@"%d", (int)model.productRatio];
    [self.tableview reloadData];
}

- (void) toobarDonBtnCancel:(PickView *)pickView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollview.contentOffset = CGPointMake(0, 0);
    }];
}

- (void) submitRadio:(NSString *) productId productRatio:(CGFloat) productRatio
{
    [NetWorkHandler requestToSetSpecialtyUserProductRatio:self.brokerInfo.userId productId:productId productRatio:productRatio Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
    }];
}

@end
