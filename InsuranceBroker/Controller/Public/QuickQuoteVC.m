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
        self.shareUrl = [NSString stringWithFormat:@"%@?userId=%@&appShare=1", url, [UserInfoModel shareUserInfoModel].userId];
}

@end
