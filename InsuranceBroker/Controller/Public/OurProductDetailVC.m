//
//  OurProductDetailVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/1/19.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "OurProductDetailVC.h"
#import "define.h"
#import "SBJson.h"
#import "SelectCustomerVC.h"
#import "SelectInsuredVC.h"
#import "RootViewController.h"
#import "THSegmentedPager.h"
#import "SBJson.h"
#import "NetWorkHandler.h"
#import "NSString+URL.m"

@interface OurProductDetailVC () <SelectInsuredVCDelegate, SelectCustomerVCDelegate>

@end

@implementation OurProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) handleCloseButtonClicked:(UIButton *) sender
//{
//    NSArray *vcarray = self.navigationController.viewControllers;
//    UIViewController *vc = nil;
//    for (int i = 0; i < [vcarray count]; i++) {
//        UIViewController *temp = [vcarray objectAtIndex:i];
//        if([temp isKindOfClass:[THSegmentedPager class]]){
//            vc = temp;
//            break;
//        }
//    }
//    
//    if(vc)
//        [self.navigationController popToViewController:vc animated:YES];
//    else
//        [self.navigationController popViewControllerAnimated:YES];
//}


- (void) loadWebString
{
    if(!_isLoad){
        if(self.urlpath != nil){
            
            [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlpath]]];
            
            _isLoad = YES;
        }
    }
}

- (void) handleRightBarButtonClicked:(id)sender
{
    [self showPopView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{ 
    if(self.title == nil)
        self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSString *jsonstr = [self isFirstLoad];
    
    if([jsonstr isEqualToString:@"true"]){
        [self NotifyToInitCustomerInfo];
    }
    
    [self performSelector:@selector(addShutButton) withObject:nil afterDelay:0.01];
}

//选择客户
- (void) NotifyToSelectCustomer
{
    SelectCustomerVC *vc = [[SelectCustomerVC alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//
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
        self.urlpath = [NSString stringWithFormat:@"%@?productId=%@&uuid=%@", url, productId, uuid];
        self.shareUrl =  [NSString stringWithFormat:@"%@?appShare=1&productId=%@&uuid=%@", url,  productId, uuid];
    }
    else{
        self.urlpath = [NSString stringWithFormat:@"%@?userId=%@&productId=%@&uuid=%@", url, [UserInfoModel shareUserInfoModel].userId, productId, uuid];
        self.shareUrl = [NSString stringWithFormat:@"%@?userId=%@&appShare=1&productId=%@&uuid=%@", url, [UserInfoModel shareUserInfoModel].userId, productId, uuid];
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

- (void) NotifyCloseWindow
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Refresh_OrderList object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Add_NewCustomer object:nil];
    [self handleCloseButtonClicked:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *uri = url.absoluteString;
    if([uri rangeOfString:@"lastpage=true"].length > 0 && ![uri isEqualToString:self.urlpath]){
//        //适应文档式说明;
//        OurProductDetailVC *vc = [IBUIFactory CreateOurProductDetailVC];
//        [self.navigationController pushViewController:vc animated:YES];
//        [vc loadHtmlFromUrl:uri];
//        [vc performSelector:@selector(initCloseButton) withObject:nil afterDelay:0.2];
//        return NO;
    }
    return YES;
}

//- (void) initCloseButton
//{
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(handleLeftBarButtonClicked:)];
//    UIImage *image = [ThemeImage(@"arrow_left") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    backItem.image = image;
//    [backItem setTarget:self];
//    
//    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 32)];
//    [button setTitle:@"关闭" forState:UIControlStateNormal];
//    [button setTitleColor:_COLOR(0xff, 0x66, 0x19) forState:UIControlStateNormal];
//    button.titleLabel.font = _FONT(16);
//    UIBarButtonItem *closeItem=[[UIBarButtonItem alloc] initWithCustomView:button];
//    [button addTarget:self action:@selector(handleCloseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    NSArray *array = [NSArray arrayWithObjects:backItem, closeItem, nil];
//    [[self navigationItem] setLeftBarButtonItems:array];
//}

#pragma MyJSInterfaceDelegate
//分享按钮
- (void) NotifyShareWindowWithPrama:(NSDictionary *)dic
{
    if(dic == nil){
        [self handleRightBarButtonClicked:nil];
    }else{
        NSString *shareRange = [dic objectForKey:@"shareRange"];
        NSArray *array = [shareRange componentsSeparatedByString:@","];
        if(array == nil || [array count] == 0)
            [self handleRightBarButtonClicked:nil];
        
        NSString *title = [dic objectForKey:@"title"];
        if(title)
            self.shareTitle = title;
//        NSString *imgUrl = [dic objectForKey:@"ImgUrl"];
        NSString *flagImg = [dic objectForKey:@"flagImg"];
        if(flagImg)
            self.shareImgArray = [NSArray arrayWithObject:flagImg];
        NSString *content = [dic objectForKey:@"content"];
        if(content)
            self.shareContent = content;
        NSString *url = [dic objectForKey:@"url"];
        if(url)
            self.shareUrl = url;
        
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
    
//    NSDictionary *object = [self getShareInfo];
//    if(object == nil){
//        [super simplyShare:type];
//    }
//    else
//    {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        NSString *url = self.shareUrl;
//        if([url rangeOfString:@"?"].length > 0)
//            url = [NSString stringWithFormat:@"%@&appShare=1", url];
//        else
//            url = [NSString stringWithFormat:@"%@?appShare=1", url];
    
        if(self.shareImgArray == nil || [self.shareImgArray count] == 0)
        {
            NSString *iconStr = [App_Delegate appIcon];
            if(iconStr)
                self.shareImgArray = [NSArray arrayWithObject:iconStr];
        }
        
        
        if (self.shareImgArray) {
            NSURL *Uri = [NSURL URLWithString:url];
            [shareParams SSDKSetupShareParamsByText:self.shareContent
                                             images:self.shareImgArray
                                                url:Uri
                                              title:self.shareTitle
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
//    }
}


@end
