//
//  OnlinePayVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/3/31.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "OnlinePayVC.h"
#import "define.h"
#import "PayTypeSelectedVCTableViewCell.h"
#import "PayConfDataModel.h"
#import "NetWorkHandler+queryPayConfList.h"

#import "AppMethod.h"
#import "AppUtils.h"
#import "WXApi.h"
#import "CommonInfo.h"
#import "DataMD5.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UIImageView+WebCache.h"

#import "BaseLineView.h"
#import "SepLineLabel.h"

#import "NetWorkHandler+getCharge.h"

#import "OfferDetailsVC.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "Pingpp.h"


@interface OnlinePayVC ()
{
    NSInteger _selectIdx;
}

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *channel;

@end

@implementation OnlinePayVC

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"确认支付";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePaySuccess) name:Notify_Pay_Success object:nil];
    
    _selectIdx = 0;
    
    self.btnPay.layer.cornerRadius = 4;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 16, 0, 16);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:insets];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:insets];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"PayTypeSelectedVCTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.logo.layer.cornerRadius = 4;
    self.logo.layer.borderWidth = 1;
    self.logo.layer.borderColor = _COLOR(0xe9, 0xe9, 0xe9).CGColor;
    
    self.lbAmount.font = _FONT(30);
    
//    PayConfDataModel *model = [[PayConfDataModel alloc] init];
//    model.payLogo = @"Pay_img_wechat";
//    model.payName = @"微信支付";
//    model.payValue = @"2";
    
    PayConfDataModel *model1 = [[PayConfDataModel alloc] init];
    model1.payLogo = @"Pay_img_alipay";
    model1.payName = @"支付宝支付";
    model1.payValue = @"3";
    self.data = @[model1];
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma INIT DATA 
- (void) initData{
    self.lbTitle.text = self.titleName;
    self.lbAmount.text = [NSString stringWithFormat:@"¥ %@", self.totalFee];
    [self.logo sd_setImageWithURL:[NSURL URLWithString:self.companyLogo] placeholderImage:nil];
    self.lbpayContent.text = self.payDesc;
    self.createTime.text = [self.createdAt substringToIndex:10];
}

- (void) loadData
{
    [ProgressHUD show:nil];
    [NetWorkHandler requestToQueryPayConfList:1 payConfType:@"2" deviceType:nil Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            self.data = [PayConfDataModel modelArrayFromArray:[content objectForKey:@"data"]];
            self.tableHeight.constant = [self.data count] * 46.f;
        }
        
        [self.tableView reloadData];
        
        [ProgressHUD dismiss];
    }];
}

#pragma NOTIFY

- (void) handlePaySuccess
{
    NSMutableArray *vcarray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    UIViewController *vc = nil;
    for (int i = 0; i < [vcarray count]; i++) {
        UIViewController *temp = [vcarray objectAtIndex:i];
        if([temp isKindOfClass:[OfferDetailsVC class]]){
            vc = temp;
            break;
        }
    }
    
    if(vc){
        [vcarray removeObject:vc];
    }
    
    self.navigationController.viewControllers = vcarray;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableViewDelegate, UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    self.tableHeight.constant = [self.data count] * 46.f;
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    PayTypeSelectedVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"PayTypeSelectedVCTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    PayConfDataModel *model = [self.data objectAtIndex:indexPath.section];
    
    cell.logoImgV.image = ThemeImage(model.payLogo);
    cell.lbName.text = model.payName;
    if(_selectIdx == indexPath.section)
        [cell setItemSelected:YES];
    else
        [cell setItemSelected:NO];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    _selectIdx = indexPath.section;
    [self.tableView reloadData];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    SepLineLabel *v = [[SepLineLabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 1)];
    v.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:v];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[v]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(v)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[v]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(v)]];
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.f;
}


#pragma ACTION
- (IBAction) doBtnPay:(UIButton *)sender
{
    if(_selectIdx < [self.data count]){
        if (_selectIdx == 0) {
            self.channel = @"alipay";
        } else {
            return;
        }
        
        if ([self.totalFee floatValue] == 0) {
            return;
        }
        
        [ProgressHUD show:nil];
        OnlinePayVC * __weak weakSelf = self;
        NSString *systemName = @"ibrokerInsurance";
        if([self.insuranceType integerValue] > 1){
            systemName = @"personInsurance";
        }
        [NetWorkHandler requestToGetCharge:self.channel amount:self.totalFee orderNo:self.orderId productDesc:self.payDesc productName:self.titleName systemName:systemName Completion:^(int code, id content) {
            [ProgressHUD dismiss];
            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
            if(code == 200){
           
                NSLog(@"charge = %@", content);
                [Pingpp createPayment:[content objectForKey:@"data"]
                       viewController:weakSelf
                         appURLScheme:@"alipayPayIBroker"
                       withCompletion:^(NSString *result, PingppError *error) {
                           NSLog(@"completion block: %@", result);
                           if (error == nil) {
                               NSLog(@"PingppError is nil");
                           } else {
                               NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                           }
                           [Util showAlertMessage:result];
                       }];
            }else if (code == 99999){
                [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Pay_Success object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];

    }
    
}

@end
