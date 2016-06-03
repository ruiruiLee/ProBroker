//
//  ProductDetailWebVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ProductDetailWebVC.h"
#import "define.h"
#import "SBJson.h"
#import "SelectCustomerVC.h"
#import "SelectInsuredVC.h"

@interface ProductDetailWebVC ()<SelectInsuredVCDelegate, SelectCustomerVCDelegate>

@end

@implementation ProductDetailWebVC

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    self.shareUrl = webView.request.URL.absoluteString;
    NSString *jsonstr = [self isFirstLoad];
    
    if([jsonstr isEqualToString:@"true"]){
        [self NotifyToInitCustomerInfo];
    }
}

- (void) NotifyToSelectCustomer
{
    SelectCustomerVC *vc = [[SelectCustomerVC alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyToSelectInsured
{
    SelectInsuredVC *vc = [[SelectInsuredVC alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    vc.customerId = self.customerDetail.customerId;
    vc.title = [NSString stringWithFormat:@"%@的被保人列表", self.customerDetail.customerName];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyToInitCustomerInfo
{
    //先初始化保险人信息
    NSDictionary *dic1 = [self.customerDetail objectToDictionary];
    
    SBJsonWriter *writer1 = [[SBJsonWriter alloc] init];
    NSString *string1 = [writer1 stringWithObject:dic1];
    NSString *result1 = [NSString stringWithFormat:@"noticeCustomerInfo('%@');", string1];
    
    [self.webview stringByEvaluatingJavaScriptFromString:result1];
    
    //在初始化被保人信息
    NSDictionary *dic2 = [InsuredInfoModel dictionaryFromeModel:self.infoModel];
    SBJsonWriter *writer2 = [[SBJsonWriter alloc] init];
    NSString *string2 = [writer2 stringWithObject:dic2];
    NSString *result2 = [NSString stringWithFormat:@"noticeInsuredInfo('%@');", string2];

    [self.webview stringByEvaluatingJavaScriptFromString:result2];
}

//选择客户完成
- (void) NotifyCustomerSelectedWithModel:(CustomerDetailModel *) model vc:(SelectCustomerVC *) vc
{
    self.customerDetail = model;
    self.infoModel = nil;
    
    NSDictionary *dic = [model objectToDictionary];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *string = [writer stringWithObject:dic];
    NSString *result = [NSString stringWithFormat:@"noticeCustomerInfo('%@');", string];
    
    [self.webview stringByEvaluatingJavaScriptFromString:result];
}

//选择被保人资料
- (void) NotifyInsuredSelectedWithModel:(InsuredUserInfoModel *) model vc:(SelectInsuredVC *) vc
{
    InsuredInfoModel *insured = [InsuredInfoModel initFromInsuredUserInfoModel:model];
    self.infoModel = insured;
    NSDictionary *dic = [InsuredInfoModel dictionaryFromeModel:insured];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *string = [writer stringWithObject:dic];
    NSString *result = [NSString stringWithFormat:@"noticeInsuredInfo('%@');", string];
    
    [self.webview stringByEvaluatingJavaScriptFromString:result];
}

- (void) loadHtmlFromUrlWithUserId:(NSString *) url productId:(NSString *)productId
{
    if([UserInfoModel shareUserInfoModel].userId == nil){
        self.urlpath = [NSString stringWithFormat:@"%@?productAttrId=%@", url, productId];;
        self.shareUrl =  [NSString stringWithFormat:@"%@?appShare=1&productAttrId=%@", url,  productId];
    }
    else{
        self.urlpath = [NSString stringWithFormat:@"%@?userId=%@&productAttrId=%@", url, [UserInfoModel shareUserInfoModel].userId, productId];
        self.shareUrl = [NSString stringWithFormat:@"%@?userId=%@&appShare=1&productAttrId=%@", url, [UserInfoModel shareUserInfoModel].userId, productId];
    }
    
    if(self.webview){
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlpath]]];
        _isLoad = YES;
    }
}

- (NSString *) isFirstLoad
{
    NSString *str = [self.webview stringByEvaluatingJavaScriptFromString:@"isFirstLoad();"];
    return str;
}

@end
