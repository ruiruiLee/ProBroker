//
//  QuickQuoteVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/29.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "QuickQuoteVC.h"
#import "SBJsonParser.h"
#import "define.h"
#import "OrderManagerVC.h"

@interface QuickQuoteVC ()

@end

@implementation QuickQuoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(self.title == nil)
        self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self performSelector:@selector(addShutButton) withObject:nil afterDelay:0.01];
    
    return YES;
}

#pragma MyJSInterfaceDelegate
//跳转车险列表
- (void) notifyToOrderList:(NSString *) string
{
    [self page2CarOrderList];
}

- (void) NotifyShareWindowWithPrama:(NSDictionary *)dic
{
    //这里暂不分享
}

@end
