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
//    [self setRightBarButtonWithImage:ThemeImage(@"team_msg")];
    [self SetRightBarButtonWithTitle:@"回复" color:_COLORa(0xff, 0x66, 0x19, 1) action:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:Notify_Msg_Reload object:nil];
}

- (void) reloadData
{
    NSString *string = [NSString stringWithFormat:@"loadData()"];
    [self.webview stringByEvaluatingJavaScriptFromString:string];
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
         
//         UserInfoModel *model = [UserInfoModel shareUserInfoModel];
//         NSString *senderName = [Util getUserName:model];
//         if(!senderName)
//             senderName = model.phone;
//         NSString *title = [NSString stringWithFormat:@"%@给你发了一条私信", senderName];
//         [NetWorkHandler requestToPostPrivateLetter:self.toUserId title:title content:contentStr senderId:model.userId senderName:senderName Completion:^(int code, id content) {
//             [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
//             if(code == 200){
//                 [self performSelector:@selector(showMessageSuccess) withObject:nil afterDelay:0.5];
//                 NSString *string = [NSString stringWithFormat:@"writeLetter('%@')", contentStr];
//                 [self.webview stringByEvaluatingJavaScriptFromString:string];
//             }
//             else{
//                 [self performSelector:@selector(showMessageFail) withObject:nil afterDelay:0.5];
//             }
//         }];
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
//    [self loadHtmlFromUrl:self.urlpath];
}

- (void) showMessageFail
{
    [Util showAlertMessage:@"消息发送失败！"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self performSelector:@selector(scrollWebView) withObject:nil afterDelay:0.6];
}

- (void) scrollWebView
{
//    CGFloat offset = self.webview.scrollView.contentSize.height;
//    NSInteger height = [[self.webview stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] intValue];
//    NSString* javascript = [NSString stringWithFormat:@"window.scrollBy(0, %d);", height];
//    [self.webview stringByEvaluatingJavaScriptFromString:javascript];
}

@end
