//
//  OrderWebVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/22.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "OrderWebVC.h"
#import "MyJSInterface.h"
#import "define.h"
#import "RootViewController.h"

@interface OrderWebVC ()<MyJSInterfaceDelegate, UIWebViewDelegate>

@end

@implementation OrderWebVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    MyJSInterface* interface = [MyJSInterface new];
    interface.delegate = self;
    [self.webview addJavascriptInterfaces:interface WithName:@"appClient"];
    for (UIScrollView* view in self.webview.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            view.bounces = NO;
        }
    }
    self.webview.backgroundColor = [UIColor clearColor];
    [self.webview setOpaque:NO];
//    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlpath]]];
//    self.webview.delegate = self;
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webview.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

- (void) loadHtmlFromUrl:(NSString *) url
{
    NSLog(@"%@", url);
    self.urlpath = url;
    if(self.webview)
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlpath]]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.urlpath != nil){
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlpath]];
        [_webview loadRequest:request];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:_progressView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_progressView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_progressView(2)]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressView)]];
}

- (void) NotifyCloseWindow
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Refresh_OrderList object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Add_NewCustomer object:nil];
    [self performSelector:@selector(turnToCustomerPage) withObject:nil afterDelay:0.1];
}

- (void) NotifyShareWindowWithPrama:(NSDictionary *)dic
{
    [self handleRightBarButtonClicked:nil];
}

- (void) NotifyToReSubmitCarInfo:(NSString *) orderId customerId:(NSString *) customerId customerCarId:(NSString *) customerCarId
{
    
}

- (void) turnToCustomerPage
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.root.selectedIndex = 1;
}

@end
