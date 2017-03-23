//
//  PayTypeSelectedVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/7/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "PayTypeSelectedVC.h"
#import "NetWorkHandler+queryPayConfList.h"
#import "PayConfDataModel.h"
#import "define.h"
#import "PayTypeSelectedVCTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NetWorkHandler+insurancePay.h"
#import "NetWorkHandler+InitWechatConfig.h"
#import "AppMethod.h"
#import "AppUtils.h"
#import "WXApi.h"
#import "CommonInfo.h"
#import "DataMD5.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import <Foundation/Foundation.h>

@interface PayTypeSelectedVC ()
{
    NSInteger selectedIdx;
}

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UILabel *lbAmount;

@end

@implementation PayTypeSelectedVC
@synthesize tableview;
@synthesize btnPay;
@synthesize lbTitle;
@synthesize lbAmount;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePaySuccess) name:Notify_Pay_Success object:nil];
    
    self.title = @"确认支付";
    selectedIdx = 0;
    
    [self loadData];
    [self initSubViews];
}

- (void) handlePaySuccess
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadData
{
    [ProgressHUD show:nil];
    [NetWorkHandler requestToQueryPayConfList:1 payConfType:@"2" deviceType:nil Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            self.data = [PayConfDataModel modelArrayFromArray:[content objectForKey:@"data"]];
            self.tableHeight.constant = [self.data count] * 52;
        }
        
        [tableview reloadData];
        
        [ProgressHUD dismiss];
    }];
}

- (void) initSubViews
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:headerView];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *lbOrderAmount = [ViewFactory CreateLabelViewWithFont:_FONT(15) TextColor:_COLOR(0x75, 0x75, 0x75)];
    [headerView addSubview:lbOrderAmount];
    lbOrderAmount.text = @"订单总价：";
    
    lbAmount = [ViewFactory CreateLabelViewWithFont:_FONT(15) TextColor:[UIColor redColor]];
    [headerView addSubview:lbAmount];
    lbAmount.text = [NSString stringWithFormat:@"%@元", self.totalFee];
    
    SepLineLabel *lbLine = [[SepLineLabel alloc] initWithFrame:CGRectZero];
    lbLine.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:lbLine];
    
    lbTitle = [ViewFactory CreateLabelViewWithFont:_FONT(15) TextColor:_COLOR(0x75, 0x75, 0x75)];
    [headerView addSubview:lbTitle];
    lbTitle.text = self.titleName;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:titleView];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbTitleText = [ViewFactory CreateLabelViewWithFont:_FONT(15) TextColor:_COLOR(0x21, 0x21, 0x21)];
    [titleView addSubview:lbTitleText];
    lbTitleText.text = @"选择支付方式";
    
    SepLineLabel *lbLine1 = [[SepLineLabel alloc] initWithFrame:CGRectZero];
    lbLine1.translatesAutoresizingMaskIntoConstraints = NO;
    [titleView addSubview:lbLine1];
    
    tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableview.translatesAutoresizingMaskIntoConstraints = NO;
    tableview.backgroundColor = [UIColor clearColor];//_COLOR(242, 242, 242);//TableBackGroundColor;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.separatorColor = SepLineColor;
    [tableview registerNib:[UINib nibWithNibName:@"PayTypeSelectedVCTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    tableview.tableFooterView = [[UIView alloc] init];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 16, 0, 16);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableview setSeparatorInset:insets];
    }
    if ([tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableview setLayoutMargins:insets];
    }
    
    btnPay = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.view addSubview:btnPay];
    btnPay.translatesAutoresizingMaskIntoConstraints = NO;
    btnPay.backgroundColor = _COLOR(0xff, 0x66, 0x19);
    [btnPay setTitle:@"付款" forState:UIControlStateNormal];
    btnPay.titleLabel.font = _FONT(15);
    [btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPay.layer.cornerRadius = 6;
    [btnPay addTarget:self action:@selector(doBtnPay:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(tableview, btnPay, lbOrderAmount, lbTitle, lbLine, lbAmount, headerView, titleView, lbTitleText, lbLine1);
    
    self.hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.hConstraints];
    self.vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerView(93)]-15-[titleView(47)]-0-[tableview]-50-[btnPay(40)]->=0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.vConstraints];
    self.tableHeight = [NSLayoutConstraint constraintWithItem:tableview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.view addConstraint:self.tableHeight];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[btnPay]-20-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[lbTitle]-20-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[lbLine]-16-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[lbOrderAmount]-6-[lbAmount]-20-|" options:0 metrics:nil views:views]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:lbAmount attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbOrderAmount attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbOrderAmount]-0-[lbOrderAmount(46)]-0-[lbLine(1)]-0-[lbTitle(46)]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleView]-0-|" options:0 metrics:nil views:views]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lbTitleText(46)]-0-[lbLine1(1)]-0-|" options:0 metrics:nil views:views]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[lbLine1]-16-|" options:0 metrics:nil views:views]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[lbTitleText]-16-|" options:0 metrics:nil views:views]];
}

#pragma UITableViewDataSource UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    PayTypeSelectedVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"PayTypeSelectedVCTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    PayConfDataModel *model = [self.data objectAtIndex:indexPath.row];
    
    [cell.logoImgV sd_setImageWithURL:[NSURL URLWithString:model.payLogo] placeholderImage:ThemeImage(@"normal_logo")];
    cell.lbName.text = model.payName;
    if(selectedIdx == indexPath.row)
        [cell setItemSelected:YES];
    else
        [cell setItemSelected:NO];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    selectedIdx = indexPath.row;
    [self.tableview reloadData];
}

- (void) doBtnPay:(UIButton *)sender
{
    if(selectedIdx < [self.data count]){
        PayConfDataModel *model = [self.data objectAtIndex:selectedIdx];
        [ProgressHUD show:nil];
        [NetWorkHandler requestToInsurancePay:self.orderId insuranceType:self.insuranceType planOfferId:self.planOfferId payType:model.payValue helpInsure:@"1" Completion:^(int code, id content) {
            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
            if(code == 99999 ){
                [self.navigationController popViewControllerAnimated:YES];
            }
            if(code == 200){
                    NSString *totalFee = [[content objectForKey:@"data"] objectForKey:@"totalFee"];
                    NSString *body = [[content objectForKey:@"data"] objectForKey:@"body"];
                    NSInteger payOrderType = [[[content objectForKey:@"data"] objectForKey:@"payOrderType"] integerValue];
                    NSString *outTradeNo = [[content objectForKey:@"data"] objectForKey:@"outTradeNo"];
                    NSString *baseUrl = [[content objectForKey:@"data"] objectForKey:@"unifyPayInitUrl"];
                    
                    [NetWorkHandler requestToInitWechatConfig:@"appPay" payOrderType:payOrderType outTradeNo:outTradeNo openId:nil totalFee:totalFee body:body baseUrl:baseUrl payType:model.payValue Completion:^(int code, id content) {
                        //                        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
                        if([[content objectForKey:@"state"] integerValue] == 1){
                            // 添加调起数据
                            NSDictionary *dict = [content objectForKey:@"data"];
                            //WEIXIN
                            if([model.payValue integerValue] == 2){
                                [self payInWX:dict];
                            }
                            else if ([model.payValue integerValue] == 3){
                                //ZHI FU BAO
                                [self payInAli:dict];
                                [ProgressHUD dismiss];
                            }else{
                                [ProgressHUD dismiss];
                            }
                            
                        }else{
                            [KGStatusBar showErrorWithStatus:[content objectForKey:@"msg"]];
                        }
                        
                        [ProgressHUD dismiss];
                    }];
            }
            else{
                [ProgressHUD dismiss];
            }
        }];
    }
}

- (void) payInWX:(NSDictionary *) dict
{
    PayReq* req             = [[PayReq alloc] init];
    req.prepayId            = [dict objectForKey:@"prepayId"];
    req.package             = [dict objectForKey:@"packagestr"];
    req.sign                = [dict objectForKey:@"paySign"];
    req.partnerId           = [dict objectForKey:@"mchId"];
    req.nonceStr            = [dict objectForKey:@"nonceStr"];
    req.timeStamp           = [[dict objectForKey:@"timestamp"] unsignedIntValue];
    
    // 调起客户端
    [WXApi sendReq:req];
}

- (void) payInAli:(NSDictionary *) dict
{
    NSString *aliSignType = [dict objectForKey:@"aliSignType"];
    NSString *aliOrderInfo = [dict objectForKey:@"aliOrderInfo"];
    NSString *privateKey = [dict objectForKey:@"aliPrivateKey"];
    
    
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:aliOrderInfo];
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                   aliOrderInfo, signedString, aliSignType];
    
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"alipayPayIBroker" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        if([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000){
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Pay_Success object:nil];
            [Util showAlertMessage:@"支付结果：成功！"];
        }
        else
            [Util showAlertMessage:@"支付失败"];
    }];
}

@end
