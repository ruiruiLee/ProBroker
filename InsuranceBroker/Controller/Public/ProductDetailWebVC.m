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
#import "RootViewController.h"
#import "THSegmentedPager.h"
#import "SBJson.h"
#import "NetWorkHandler.h"
#import "NSString+URL.m"

@interface ProductDetailWebVC ()

@end

@implementation ProductDetailWebVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self SetRightBarButtonWithTitle:@"分享" color:_COLORa(0xff, 0x66, 0x19, 1) action:YES];
}

- (void) loadWebString
{
    if(!_isLoad){
        if(self.urlpath != nil){
            
            [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlpath]]];
            
            _isLoad = YES;
        }
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.webview stringByEvaluatingJavaScriptFromString:@"paySuccess();"];
}

- (void) handleRightBarButtonClicked:(id)sender
{
    [self showPopView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(self.title == nil)
        self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [self performSelector:@selector(addShutButton) withObject:nil afterDelay:0.01];
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
    
    [self getRc4String:type];
        
}

- (void) getRc4String:(SSDKPlatformType) type
{
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
    [mdic setObject:@{@"userId": [UserInfoModel shareUserInfoModel].userId} forKey:@"extraInfo"];
    
    SBJsonWriter *_writer = [[SBJsonWriter alloc] init];
    NSString *dataString = [_writer stringWithObject:mdic];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    
    NSString *url = [NSString stringWithFormat:@"http://118.123.249.87:8783/UKB.AgentNew/web/security/encryRC4.xhtml?"];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [pramas setObject:dataString forKey:@"dataString"];
    
    [[NetWorkHandler shareNetWorkHandler] getWithUrl:url Params:pramas Completion:^(int code, id content) {
        self.view.userInteractionEnabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(code == 1){
            NSString *bizContent =  (NSString *) content;
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            NSString *url = [NSString stringWithFormat:@"%@&bizContent=%@", self.selectProModel.clickAddr, bizContent];
            NSMutableArray *imgArray = [[NSMutableArray alloc] init];
            NSString *flagImg = self.selectProModel.productLogo;
            if(flagImg)
                [imgArray addObject:flagImg];
            
            if(imgArray == nil || [imgArray count] == 0)
            {
                NSString *iconStr = [App_Delegate appIcon];
                if(iconStr)
                    [imgArray addObject:iconStr];
            }
            
            
            if (self.shareImgArray) {
                
                NSString *content = self.selectProModel.productIntro;
                NSString *title = self.selectProModel.productName;
                NSURL *uri = [NSURL URLWithString:url];
                [shareParams SSDKSetupShareParamsByText:content
                                                 images:imgArray
                                                    url:uri
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
    }];
}



@end
