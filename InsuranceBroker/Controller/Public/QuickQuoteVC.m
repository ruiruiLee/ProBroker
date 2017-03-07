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
    
//    [self SetRightBarButtonWithTitle:@"分享" color:_COLORa(0xff, 0x66, 0x19, 1) action:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleRightBarButtonClicked:(id)sender
{
    [self showPopView];
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
- (void) notifyToOrderList:(NSString *) string
{
    OrderManagerVC *orderVC = [[OrderManagerVC alloc] initWithNibName:nil bundle:nil];
    orderVC.insuranceType = @"1";
    [orderVC setViewTitle:@"车险"];
    [orderVC initMapTypesForCar];
    
    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
    [array removeLastObject];
    [array addObject:orderVC];
    [self.navigationController setViewControllers:array animated:YES];
}

- (void) NotifyShareWindowWithPrama:(NSDictionary *)dic
{
    [self showPopView];
}

- (void) HandleItemSelect:(PopView *) view selectImageName:(NSString *)imageName
{

    NSString *jsonstr = [self getShareContent];
    SBJsonParser *_parser = [[SBJsonParser alloc] init];
    NSDictionary *dic = [_parser objectWithString:jsonstr];
    if([dic objectForKey:@"url"]){
        self.shareUrl = [NSString stringWithFormat:@"%@&appShare=1", [dic objectForKey:@"url"]];
    }
    
    if([dic objectForKey:@"content"]){
        self.shareContent = [dic objectForKey:@"content"];
    }
    
//    if([dic objectForKey:@"image"]){
//        self.shareImgArray = [NSArray arrayWithObject:[dic objectForKey:@"image"]];
//    }
    
    if([dic objectForKey:@"title"]){
        self.shareTitle = [dic objectForKey:@"title"];
    }
    
    [super HandleItemSelect:view selectImageName:imageName];
}

- (NSString *) getShareContent
{
    NSString *str = [self.webview stringByEvaluatingJavaScriptFromString:@"getShareContent();"];
    return str;
}

@end
