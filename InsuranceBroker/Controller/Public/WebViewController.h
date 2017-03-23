//
//  WebViewController.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/16.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "PopView.h"
#import "enumFile.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

#import "EasyJSWebView.h"
#import "EasyJSWebView+JavaScriptAlert.h"

#import "MyJSInterface.h"

@interface WebViewController : BaseViewController <PopViewDelegate, NJKWebViewProgressDelegate, UIWebViewDelegate, MyJSInterfaceDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    
    BOOL _isLoad;
//    BOOL _isReturnPrevWeb;
}

@property (nonatomic, strong) IBOutlet EasyJSWebView *webview;
@property (nonatomic, strong) PopView *popview;
@property (nonatomic, strong) NSString *urlpath;
@property (nonatomic, assign) enumShareType type;
@property (nonatomic, assign) enumNeedInitShareInfo shareType;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareContent;
@property (nonatomic, strong) NSArray *shareImgArray;
@property (nonatomic, strong) NSString *shareUrl;


- (void) loadHtmlFromUrl:(NSString *) url;
- (void) loadHtmlFromUrlWithUserId:(NSString *) url;
- (void) loadHtmlFromUrlWithUuId:(NSString *) url;
//邀请好友
- (void) loadHtmlFromUrlWithAppId:(NSString *)url;
- (void) simplyShare:(SSDKPlatformType) type;

- (void) showPopView;
- (void) showPopView1;

- (NSString *) getshareUrlWithType:(SSDKPlatformType) plattype;

- (void) loadWebString;
- (void)addWebCache:(NSURLRequest *)request;

- (NSDictionary *) getShareInfo;

- (void) handleCloseButtonClicked:(id) handle;//关闭按钮

- (void) addShutButton;

- (void) page2CarOrderList;

@end
