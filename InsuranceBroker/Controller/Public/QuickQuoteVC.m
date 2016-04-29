//
//  QuickQuoteVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/29.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "QuickQuoteVC.h"

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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    self.shareUrl = webView.request.URL.absoluteString;
    NSString *url = webView.request.URL.absoluteString;
    if(![url isEqualToString:self.urlpath])
        self.shareUrl = url;
}

- (void) handleRightBarButtonClicked:(id)sender
{
    [self showPopView];
}

- (void) HandleItemSelect:(PopView *) view withTag:(NSInteger) tag
{

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

@end
