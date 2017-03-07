//
//  PrivateMsgVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/6/8.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "PrivateMsgVC.h"
#import "define.h"
#import "UUInputAccessoryView.h"
#import "NetWorkHandler+privateLetter.h"
#import "CMNavBarNotificationView.h"

@interface PrivateMsgVC ()

@end

@implementation PrivateMsgVC

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self SetRightBarButtonWithTitle:@"回复" color:_COLORa(0xff, 0x66, 0x19, 1) action:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:Notify_Msg_Reload object:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(self.title == nil)
        self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void) reloadData:(NSNotification *) notify
{
    [self.webview stringByEvaluatingJavaScriptFromString:@"loadData();"];
    
    
    NSDictionary *userinfo = notify.userInfo;
    
    NSString *userId =  [userinfo objectForKey:@"p"];
    if(![userId isEqualToString:self.toUserId]){
        [CMNavBarNotificationView notifyWithText:[[userinfo objectForKey:@"aps"] objectForKey:@"category"]
                                          detail:[[userinfo objectForKey:@"aps"] objectForKey:@"alert"]
                                           image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[App_Delegate appIcon]]]]
                                     andDuration:5.0
                                       msgparams:userinfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleRightBarButtonClicked:(id)sender
{
    //TODO
    UIKeyboardType type = UIKeyboardTypeDefault;
    NSString *content = @"";
    
    [UUInputAccessoryView showKeyboardType:type
                                   content:content
                                     Block:^(NSString *contentStr)
     {
         if (contentStr.length == 0) return ;
         
         NSString *string = [NSString stringWithFormat:@"writeLetter('%@')", contentStr];
         [self.webview stringByEvaluatingJavaScriptFromString:string];
     }];
}

- (void) loadWebString
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlpath]];
    [self addWebCache:request]; // 加缓存并加载
}

- (void) showMessageSuccess
{
    [Util showAlertMessage:@"消息发送成功！"];
}

- (void) showMessageFail
{
    [Util showAlertMessage:@"消息发送失败！"];
}


@end
