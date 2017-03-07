//
//  EasyJSWebView+JavaScriptAlert.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/22.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "EasyJSWebView+JavaScriptAlert.h"
#import "SRAlertView.h"

@implementation EasyJSWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect)frame {
    
    [SRAlertView sr_showAlertViewWithTitle:@"提示信息"
                                   message:message
                           leftActionTitle:@"确 定"
                          rightActionTitle:nil
                            animationStyle:AlertViewAnimationZoom
                              selectAction:^(AlertViewActionType actionType) {
                              }];
    
}

@end
