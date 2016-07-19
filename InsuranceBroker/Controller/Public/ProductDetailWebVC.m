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
#import "SelectCustomerForCarVC.h"
#import "RootViewController.h"

@interface ProductDetailWebVC ()<SelectInsuredVCDelegate, SelectCustomerVCDelegate>

@end

@implementation ProductDetailWebVC

- (void) handleRightBarButtonClicked:(id)sender
{
    [self showPopView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
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
    if(!self.customerDetail){
        [Util showAlertMessage:@"请先选择投保人！"];
        return;
    }
    SelectInsuredVC *vc = [[SelectInsuredVC alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    vc.customerId = self.customerDetail.customerId;
    if(self.infoModel)
        [vc setSelectedInsuredId:self.infoModel.insuredId];
    vc.title = [NSString stringWithFormat:@"%@的被保人列表", self.customerDetail.customerName];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyToInitCustomerInfo
{
    if(self.customerDetail){
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
    NSString *uuid = [UserInfoModel shareUserInfoModel].uuid;
    if([UserInfoModel shareUserInfoModel].userId == nil){
        self.urlpath = [NSString stringWithFormat:@"%@?productAttrId=%@&uuid=%@", url, productId, uuid];;
        self.shareUrl =  [NSString stringWithFormat:@"%@?appShare=1&productAttrId=%@&uuid=%@", url,  productId, uuid];
    }
    else{
        self.urlpath = [NSString stringWithFormat:@"%@?userId=%@&productAttrId=%@&uuid=%@", url, [UserInfoModel shareUserInfoModel].userId, productId, uuid];
        self.shareUrl = [NSString stringWithFormat:@"%@?userId=%@&appShare=1&productAttrId=%@&uuid=%@", url, [UserInfoModel shareUserInfoModel].userId, productId, uuid];
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

#pragma delegate

- (void) NotifyToSelectCustomerForCar:(NSString *) productAttrId
{
    SelectCustomerForCarVC *vc = [[SelectCustomerForCarVC alloc] initWithNibName:nil bundle:nil];
    vc.selectProModel = self.selectProModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) NotifyCloseWindow
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Refresh_OrderList object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Add_NewCustomer object:nil];
//    [self performSelector:@selector(turnToCustomerPage) withObject:nil afterDelay:0.1];
}

- (void) turnToCustomerPage
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.root.selectedIndex = 1;
}

#pragma MyJSInterfaceDelegate
- (void) NotifyShareWindowWithPrama:(NSDictionary *)dic
{
    if(dic == nil){
        [self handleRightBarButtonClicked:nil];
    }else{
        NSString *shareRange = [dic objectForKey:@"shareRange"];
        NSArray *array = [shareRange componentsSeparatedByString:@","];
        if(array == nil || [array count] == 0)
            [self handleRightBarButtonClicked:nil];
        
        NSMutableArray *imgArray = [[NSMutableArray alloc] init];
        NSMutableArray *nameArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [array count]; i++) {
            NSInteger num = [[array objectAtIndex:i] integerValue];
            if(num == 3){
                [imgArray addObject:@"wechat"];
                [nameArray addObject:@"微信好友"];
            }
            else if (num == 9){
                [imgArray addObject:@"moments"];
                [nameArray addObject:@"朋友圈"];
            }
            else if (num == 4){
                [imgArray addObject:@"qq"];
                [nameArray addObject:@"QQ好友"];
                [imgArray addObject:@"qzone"];
                [nameArray addObject:@"QQ空间"];
            }
        }
        
        if(!self.popview){
            self.popview = [[PopView alloc] initWithImageArray:imgArray nameArray:nameArray];
            [self.view.window addSubview:self.popview];
            self.popview.delegate = self;
        }
        
        [self.popview show];
    }
}

/**
 *  简单分享
 */
- (void)simplyShare:(SSDKPlatformType) type
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    //创建分享参数
    
    NSDictionary *object = [self getShareInfo];
    if(object == nil){
        [super simplyShare:type];
    }else{
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        NSString *url = [object objectForKey:@"url"];
        url = [NSString stringWithFormat:@"%@&userId=%@&appShare=1&uuid=%@", url, [UserInfoModel shareUserInfoModel].userId, [UserInfoModel shareUserInfoModel].uuid];
        NSMutableArray *imgArray = [[NSMutableArray alloc] init];
        NSString *flagImg = [object objectForKey:@"flagImg"];
        if(flagImg)
            [imgArray addObject:flagImg];
        
        if(imgArray == nil || [imgArray count] == 0)
        {
            AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
            if(appdelegate.appIcon)
                [imgArray addObject:appdelegate.appIcon];
        }
        
        
        if (self.shareImgArray) {
            
            NSString *content = [object objectForKey:@"content"];
            NSString *title = [object objectForKey:@"title"];
            NSURL *Uri = [NSURL URLWithString:url];
            [shareParams SSDKSetupShareParamsByText:content
                                             images:imgArray
                                                url:Uri
                                              title:title
                                               type:SSDKContentTypeAuto];
            
            //进行分享
            [ShareSDK share:type
                 parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         [KGStatusBar showSuccessWithStatus:@"分享成功"];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         [KGStatusBar showSuccessWithStatus:@"分享失败"];
                         break;
                     }
                     default:
                         break;
                 }
             }];
        }
    }
}

@end
