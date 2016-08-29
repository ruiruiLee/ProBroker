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
#import "NetWorkHandler+privateLetter.h"
#import "MyTeamsVC.h"
#import <MessageUI/MessageUI.h>
#import "UUInputAccessoryView.h"
#import "IQKeyboardManager.h"


@interface UserDetailVC ()<MFMessageComposeViewControllerDelegate, PickViewDelegate>
{
    PickView *_datePicker;
}

@property (nonatomic, strong) UserInfoModel *userinfo;
@property (nonatomic, strong) NSArray *productList;

@end

@implementation UserDetailVC
@synthesize userinfo;

- (void) handleLeftBarButtonClicked:(id)sender
{
    [_datePicker remove];
    [super handleLeftBarButtonClicked:sender];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.userinfo =  [[UserInfoModel alloc] initWithUserId:self.brokerInfo.userId];
    UIImage *placeholderImage = ThemeImage(@"head_male");
//    [self.photo sd_setImageWithURL:[NSURL URLWithString:self.brokerInfo.headerImg] placeholderImage:placeholderImage];
    CGSize size = self.photo.frame.size;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:FormatImage(self.brokerInfo.headerImg, (int)size.width, (int)size.height)] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    }];
    
    self.scHConstraint.constant = ScreenWidth;
    self.scVConstraint.constant = SCREEN_HEIGHT - 64;
    self.photo.layer.cornerRadius = 27.5;
    self.photo.clipsToBounds = YES;
    [self.tableview registerNib:[UINib nibWithNibName:@"CommissionSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableview.scrollEnabled = NO;
    [self  loadData];
//    [self loadCommissionInfo];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 16, 0, 16);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableview.separatorColor = SepLineColor;
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:insets];
    }
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableview setLayoutMargins:insets];
    }
    
    //去掉设置产品折扣
    self.tableVConstraint.constant = 0;
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

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.gradientView setGradientColor:_COLOR(0xff, 0x8c, 0x19) end:_COLOR(0xff, 0x66, 0x19)];
}

- (void) resetViews
{
    self.lbName.text = [Util getUserName:self.userinfo];//self.userinfo.nickname;
    self.lbMobile.text = self.userinfo.phone;
    self.lbSubNum.text = [NSString stringWithFormat:@"%@人", [[NSNumber numberWithLongLong:self.userinfo.ztdrs] stringValue]];
    if(self.userinfo.ztdrs > 0)
        self.rightArraw.hidden = NO;
    else
        self.rightArraw.hidden = YES;
//    [self.photo sd_setImageWithURL:[NSURL URLWithString:self.userinfo.headerImg] placeholderImage:Normal_Image];
    
    UIImage *placeholderImage = ThemeImage(@"head_male");
    if(self.userinfo.sex == 2)
        placeholderImage = ThemeImage(@"head_famale");
//    [self.photo sd_setImageWithURL:[NSURL URLWithString:self.brokerInfo.headerImg] placeholderImage:placeholderImage];
    CGSize size = self.photo.frame.size;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:FormatImage(self.brokerInfo.headerImg, (int)size.width, (int)size.height)] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    }];
    
    UserInfoModel *model = self.userinfo;
    
    self.lbMonthOrderSuccessNums.text = [Util getDecimalStyle:model.car_now_zcgddbf];//[NSString stringWithFormat:@"%.2f", model.car_now_zcgddbf];//车险本月保费
    self.lbTotalOrderSuccessNums.text = [NSString stringWithFormat:@"本月单量：%d单", model.car_now_zcgdds];//车险本月单量
    self.lbPersonalMonthOrderSuccessNums.text = [Util getDecimalStyle:model.nocar_now_zcgddbf];//[NSString stringWithFormat:@"%.2f", model.nocar_now_zcgddbf];//个险本月保费
    self.lbPersonalTotalOrderSuccessNums.text = [NSString stringWithFormat:@"本月单量：%d单", model.nocar_now_zcgdds];//个险本月单量
    
    self.lbMonthOrderEarn.text = [NSString stringWithFormat:@"%.2f", model.now_zcgddsy];//本月收益
    self.lbOrderEarn.text = [NSString stringWithFormat:@"%.2f", model.zsy];//累计收益
    self.lbTotalOrderCount.text = [[NSNumber numberWithLongLong:model.zcgdds] stringValue];//累计订单数
}

- (void) loadData
{
    [NetWorkHandler requestToQueryUserInfo:self.brokerInfo.userId Completion:^(int code, id content) {
        [self  handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            [self.userinfo setDetailContentWithDictionary1:[content objectForKey:@"data"]];
//            self.userinfo.userId = [[content objectForKey:@"data"] objectForKey:@"userId"];
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
    if(self.userinfo.ztdrs > 0){
        MyTeamsVC *vc = [[MyTeamsVC alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userid = self.brokerInfo.userId;
        vc.title = [NSString stringWithFormat:@"%@的团队", [Util getUserNameWithModel:self.brokerInfo]];
        vc.total = self.userinfo.ztdrs;
        vc.toptitle = @"他的队员";
        vc.name = [Util getUserNameWithModel:self.brokerInfo];//self.brokerInfo.userName;
        [self.navigationController pushViewController:vc animated:YES];
    }
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

//发送私信
- (IBAction) doBtnEmail:(UIButton *)sender
{
//    NSArray *array = [NSArray arrayWithObject:self.userinfo.phone];
//    [self showMessageView:array title:@"" body:@""];
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
         [NetWorkHandler requestToPostPrivateLetter:self.userinfo.userId title:title content:contentStr senderId:model.userId senderName:senderName Completion:^(int code, id content) {
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
    vc.saleType = EnumSalesTypeCar;
    vc.userId = self.brokerInfo.userId;
    vc.title = [NSString stringWithFormat:@"%@的车险销售统计", self.brokerInfo.userName];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doSalesNoCar:(id)sender
{
    SalesStatisticsVC *vc = [IBUIFactory CreateSalesStatisticsViewController];
    vc.hidesBottomBarWhenPushed = YES;
    vc.saleType = EnumSalesTypeNoCar;
    vc.userId = self.brokerInfo.userId;
    vc.title = [NSString stringWithFormat:@"%@的个险销售统计", self.brokerInfo.userName];
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
    _datePicker.lbTitle.text = [NSString stringWithFormat:@"%@,推广费范围(%d%@－%d%@)", model.productName, (int)model.productMinRatio, @"%", (int)model.productMaxRatio, @"%"];
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
