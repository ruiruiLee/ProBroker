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

@interface PayTypeSelectedVC ()\
{
    NSInteger selectedIdx;
}

@property (nonatomic, strong) NSArray *data;

@end

@implementation PayTypeSelectedVC
@synthesize tableview;
@synthesize btnPay;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择支付方式";
    selectedIdx = 0;
    
    [self loadData];
    [self initSubViews];
}

- (void) loadData
{
    [ProgressHUD show:nil];
    [NetWorkHandler requestToQueryPayConfList:1 payConfType:@"2" deviceType:nil Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            self.data = [PayConfDataModel modelArrayFromArray:[content objectForKey:@"data"]];
            self.tableHeight.constant = [self.data count] * 50;
        }
        
        [tableview reloadData];
        
        [ProgressHUD dismiss];
    }];
}

- (void) initSubViews
{
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
    
    NSDictionary *views = NSDictionaryOfVariableBindings(tableview, btnPay);
    
    self.hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.hConstraints];
    self.vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableview]-60-[btnPay(40)]->=0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.vConstraints];
    self.tableHeight = [NSLayoutConstraint constraintWithItem:tableview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.view addConstraint:self.tableHeight];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[btnPay]-20-|" options:0 metrics:nil views:views]];
}

#pragma UITableViewDataSource UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
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
        if([model.payValue integerValue] == 2){
            [ProgressHUD show:nil];
            [NetWorkHandler requestToInsurancePay:self.orderId insuranceType:self.insuranceType planOfferId:self.planOfferId payType:model.payValue helpInsure:@"1" Completion:^(int code, id content) {
                [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
                if(code == 200){
                    //                NSDictionary *dic = [content objectForKey:@"data"];
                    if([model.payValue integerValue] == 2){
                        //WEIXIN
                        NSString *totalFee = [[content objectForKey:@"data"] objectForKey:@"totalFee"];
                        NSString *body = [[content objectForKey:@"data"] objectForKey:@"body"];
                        NSInteger payOrderType = [[[content objectForKey:@"data"] objectForKey:@"payOrderType"] integerValue];
                        NSString *outTradeNo = [[content objectForKey:@"data"] objectForKey:@"outTradeNo"];
                        NSString *baseUrl = [[content objectForKey:@"data"] objectForKey:@"unifyPayInitUrl"];
                        
                        [NetWorkHandler requestToInitWechatConfig:@"appPay" payOrderType:payOrderType outTradeNo:outTradeNo openId:nil totalFee:totalFee body:body baseUrl:baseUrl Completion:^(int code, id content) {
                            //                        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
                            if([[content objectForKey:@"state"] integerValue] == 1){
                                // 添加调起数据
                                NSDictionary *dict = [content objectForKey:@"data"];
                                //WEIXIN
                                [self payInWX:dict];
                                
                            }
                            
                            [ProgressHUD dismiss];
                        }];
                    }
                    //                else if ([model.payValue integerValue] == 3){
                    //                    //ZHI FU BAO
                    ////                    [self payInAli:dic];
                    //                    [Util showAlertMessage:@"暂不支持支付宝支付！"];
                    //                    [ProgressHUD dismiss];
                    //                }else{
                    //                    [ProgressHUD dismiss];
                    //                }
                }
                else{
                    [ProgressHUD dismiss];
                }
            }];
        }else if ([model.payValue integerValue] == 3){
            [Util showAlertMessage:@"暂不支持支付宝支付！"];
        }
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
    req.timeStamp           = [[dict objectForKey:@"timestamp"] integerValue];
//    DataMD5 *md5 = [[DataMD5 alloc] init];
//    req.sign=[md5 createMD5SingForPay:WeChatAppID partnerid:req.partnerId prepayid:req.prepayId package:req.package noncestr:req.nonceStr timestamp:req.timeStamp];
    
    // 调起客户端
    [WXApi sendReq:req];
}

- (void) payInAli:(NSDictionary *) dict
{
    
    NSString *totalFee = [[dict objectForKey:@"data"] objectForKey:@"totalFee"];
    NSString *body = [[dict objectForKey:@"data"] objectForKey:@"body"];
//    NSInteger payOrderType = [[[dict objectForKey:@"data"] objectForKey:@"payOrderType"] integerValue];
//    NSString *outTradeNo = [[dict objectForKey:@"data"] objectForKey:@"outTradeNo"];
//    NSString *baseUrl = [[dict objectForKey:@"data"] objectForKey:@"unifyPayInitUrl"];
    
    // 添加商品信息
    Product *product = [Product new];
    product.orderId = self.orderId;
    product.subject = @"PayDemo_AliPayTest_subject";
    product.body = body;
    product.price = [totalFee integerValue];
    
    
    // 调起支付宝客户端
    [[AlipayHelper shared] alipay:product block:^(NSDictionary *result) {
        // 返回结果
        NSString *message = @"";
        switch([[result objectForKey:@"resultStatus"] integerValue])
        {
            case 9000:message = @"订单支付成功";break;
            case 8000:message = @"正在处理中";break;
            case 4000:message = @"订单支付失败";break;
            case 6001:message = @"用户中途取消";break;
            case 6002:message = @"网络连接错误";break;
            default:message = @"未知错误";
        }
        
        UIAlertController *aalert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [aalert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:aalert animated:YES completion:nil];
    }];
}

@end
