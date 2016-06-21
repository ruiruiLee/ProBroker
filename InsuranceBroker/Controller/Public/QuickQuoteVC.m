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

@interface QuickQuoteVC ()

@end

@implementation QuickQuoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *btnDetail = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 68, 24)];
    [btnDetail setTitle:@"精准报价?" forState:UIControlStateNormal];
    btnDetail.layer.cornerRadius = 12;
    btnDetail.layer.borderWidth = 0.5;
    btnDetail.layer.borderColor = _COLOR(0xff, 0x66, 0x19).CGColor;
    [btnDetail setTitleColor:_COLOR(0xff, 0x66, 0x19) forState:UIControlStateNormal];
    btnDetail.titleLabel.font = _FONT(12);
    [self setRightBarButtonWithButton:btnDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    self.shareUrl = webView.request.URL.absoluteString;
    NSString *url = webView.request.URL.absoluteString;
    if(![url isEqualToString:self.urlpath])
        self.shareUrl = [NSString stringWithFormat:@"%@&appShare=1", url];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // Determine if we want the system to handle it.
    NSURL *url = request.URL;
    NSString *uri = url.absoluteString;
    if([uri rangeOfString:@"userId="].length > 0){

    }else{
        NSString *newUrlString =  [NSString stringWithFormat:@"%@&userId=%@", uri, [UserInfoModel shareUserInfoModel].userId];
        url = [NSURL URLWithString:newUrlString];
        [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
        return NO;
    }

    return YES;
}

- (void) handleRightBarButtonClicked:(id)sender
{
    WebViewController *web = [IBUIFactory CreateWebViewController];
    web.hidesBottomBarWhenPushed = YES;
    web.title = @"怎样精准报价?";
    [self.navigationController pushViewController:web animated:YES];
    
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [web loadHtmlFromUrlWithUserId:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", appdelegate.exactQuoteNewsId]];
}

- (void) NotifyShareWindow
{
    [self showPopView];
}

- (void) HandleItemSelect:(PopView *) view withTag:(NSInteger) tag
{

    NSString *jsonstr = [self getShareContent];
    SBJsonParser *_parser = [[SBJsonParser alloc] init];
    NSDictionary *dic = [_parser objectWithString:jsonstr];
    if([dic objectForKey:@"url"]){
        self.shareUrl = [NSString stringWithFormat:@"%@&appShare=1", [dic objectForKey:@"url"]];;
//        self.shareUrl = [NSString stringWithFormat:@"%@?userId=%@&appShare=1", [dic objectForKey:@"url"], [UserInfoModel shareUserInfoModel].userId];
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
    
    switch (tag) {
        case 0:
        {
            [self simplyShare:SSDKPlatformSubTypeWechatSession];
        }
            break;
        case 1:
        {
            [self simplyShare:SSDKPlatformSubTypeWechatTimeline];
        }
            break;
        case 2:
        {
            [self simplyShare:SSDKPlatformSubTypeQQFriend];
        }
            break;
        case 3:
        {
            [self simplyShare:SSDKPlatformSubTypeQZone];
        }
            break;
        default:
            break;
    }
}

- (NSString *) getShareContent
{
    NSString *str = [self.webview stringByEvaluatingJavaScriptFromString:@"getShareContent();"];
    return str;
}

@end
