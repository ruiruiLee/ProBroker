//
//  WebViewController.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/16.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "WebViewController.h"
#import "define.h"
#import "NetWorkHandler+initOrderShare.h"
#import "EGOCache.h"
#import "KGStatusBar.h"
#import "IQKeyboardManager.h"
#import "RootViewController.h"
#import "SBJsonParser.h"
#import "OrderManagerVC.h"
#import "OnlinePayVC.h"
#import <MapKit/MapKit.h>

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize popview;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.type = enumShareTypeNo;
        self.shareType = enumNeedInitShareInfoNo;
        NSMutableArray *icon = [[NSMutableArray alloc] init];
        NSString *iconStr = [App_Delegate appIcon];
        if(iconStr)
            [icon addObject:iconStr];
        self.shareImgArray = icon;
        _isLoad = false;
        
    }
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) loginAndRefresh:(NSNotification *) notify
{
    self.shareUrl = [NSString stringWithFormat:@"%@?userId=%@&appShare=1&uuid=%@", self.urlpath, [UserInfoModel shareUserInfoModel].userId, [UserInfoModel shareUserInfoModel].uuid];
    self.urlpath = [NSString stringWithFormat:@"%@?userId=%@&uuid=%@", self.urlpath, [UserInfoModel shareUserInfoModel].userId, [UserInfoModel shareUserInfoModel].uuid];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePaySuccess) name:Notify_Pay_Success object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAndRefresh:) name:Notify_Login object:nil];
    
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
    self.webview.delegate = self;
    
    if(self.type == enumShareTypeShare || self.type == enumShareTypeToCustomer){
        [self setRightBarButtonWithImage:ThemeImage(@"btn_share")];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_progressView removeFromSuperview];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [self loadWebString];
}

- (void) handleLeftBarButtonClicked:(id)sender
{
    if([self.webview canGoBack]){
        [self.webview goBack];
        [self performSelector:@selector(addShutButton) withObject:nil afterDelay:0.01];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) handleCloseButtonClicked:(id) handle
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma MyJSInterfaceDelegate
- (void) NotifyShareWindowWithPrama:(NSDictionary *)dic
{
    [self handleRightBarButtonClicked:nil];
}

- (void) NotifyCloseWindow
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) NotifyLastUpdateTime:(long long) time category:(NSString *)category
{
    [[AppContext sharedAppContext]UpdateNewsTipTime:time category: [category integerValue]];
}

- (void) NotifyToSelectCustomer//获取用户信息
{}

- (void) NotifyToSelectInsured;//获取被保人信息
{}

- (void) NotifyToInitCustomerInfo//初始化数据
{}

- (void) NotifyToSelectCustomerForCar:(NSString *) productAttrId
{}

//返回上一页
- (void) NotifyWebCanReturnPrev:(BOOL)flag
{
//    _isReturnPrevWeb = flag;
}

- (void) notifyWebViewLoadFinished:(NSString *) string
{
    self.title =  [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void) notifyToOrderList:(NSString *) string
{
    
}

//支付接口
- (void) NotifyToPay:(NSString *) orderId insuranceType:(NSString *) insuranceType planOfferId:(NSString *) planOfferId titleName:(NSString *)titleName totalFee:(NSString *)totalFee companyLogo:(NSString *)companyLogo createdAt:(NSString *)createdAt payDesc:(NSString *)payDesc
{
    OnlinePayVC *vc = [[OnlinePayVC alloc] initWithNibName:@"OnlinePayVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    vc.orderId = orderId;
    vc.insuranceType = insuranceType;
    vc.planOfferId = planOfferId;
    vc.totalFee = totalFee;
    vc.titleName = titleName;
    vc.payDesc = payDesc;
    vc.createdAt = createdAt;
    vc.companyLogo = companyLogo;
}

- (void) NotifyToReSubmitCarInfo:(NSString *) orderId customerId:(NSString *) customerId customerCarId:(NSString *) customerCarId
{
    _isLoad = YES;
    
    AutoInsuranceInfoEditVC *vc = [IBUIFactory CreateAutoInsuranceInfoEditViewController];
    vc.insType = enumReInsurance;
    vc.customerId = customerId;
    vc.orderId = orderId;
    
    CustomerDetailModel *model = [[CustomerDetailModel alloc] init];
    model.carInfo = [[CarInfoModel alloc] init];
    model.carInfo.customerCarId = customerCarId;
    model.carInfo.customerId = customerId;
    model.customerId = customerId;
    vc.customerModel = model;
    vc.carInfo = model.carInfo;
    vc.hidesBottomBarWhenPushed = YES;
    [[App_Delegate root].selectVC.navigationController pushViewController:vc animated:YES];
}

- (void) notifyOpenMap:(NSDictionary *)coordinate
{
    NSString *address = [coordinate objectForKey:@"address"];
    NSString *name = [coordinate objectForKey:@"name"];
    CGFloat scale = [[coordinate objectForKey:@"scale"] floatValue];
    double latitude = [[coordinate objectForKey:@"latitude"] doubleValue];
    double longitude = [[coordinate objectForKey:@"longitude"] doubleValue];
    
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(latitude, longitude);
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];
    currentLocation.name =address;
    
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    
    NSArray *items = [NSArray arrayWithObjects:currentLocation, nil];
    //打开苹果自身地图应用，并呈现特定的item
    
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

- (void) loadWebString
{
    if(!_isLoad){
        if(_urlpath != nil){
            
//            id cacheDatas =[[EGOCache globalCache] objectForKey:[Util md5Hash:self.urlpath]];
//            if (cacheDatas !=nil) { // 直接加在缓存
//                NSString *datastr = [[NSString alloc] initWithData:cacheDatas encoding:NSUTF8StringEncoding];
//                [ _webview loadHTMLString:datastr baseURL:[NSURL URLWithString:self.urlpath]];
//            }
//            else{  //请求服务器资源
            
                NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlpath]];
                [self addWebCache:request]; // 加缓存并加载
//            }
            
            _isLoad = YES;
        }
    }
}

- (void)addWebCache:(NSURLRequest *)request{
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse: &response error:&error];
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
          if ((([httpResponse statusCode]/100) == 2)) {
              // 加缓存
              [[EGOCache globalCache] setObject:responseData forKey: [Util md5Hash:self.urlpath]];
              dispatch_async(dispatch_get_main_queue(), ^{
                   [_webview loadData:responseData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:self.urlpath]];
              });
           }
          else{
                NSLog(@"%ld---%@",(long)[error code],[error localizedDescription]);
              NSString *msg = [NSString stringWithFormat:@"(%ld)%@",(long)[error code],[error localizedDescription]];
                dispatch_async(dispatch_get_main_queue(), ^{
                     [KGStatusBar showErrorWithStatus:msg];
                    });
              }
           } );

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self handlePaySuccess];
    [self.view addSubview:_progressView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_progressView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_progressView(2)]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressView)]];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(self.title == nil)
        self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSString *url = webView.request.URL.absoluteString;
    if(![url isEqualToString:self.urlpath])
        self.shareUrl = [NSString stringWithFormat:@"%@&userId=%@&appShare=1", url, [UserInfoModel shareUserInfoModel].userId];
    
    
    [self performSelector:@selector(addShutButton) withObject:nil afterDelay:0.01];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *uri = url.absoluteString;
    if([uri rangeOfString:@"lastpage=true"].length > 0 && ![uri isEqualToString:self.urlpath]){
        WebViewController *vc = [IBUIFactory CreateWebViewController];
        [self.navigationController pushViewController:vc animated:YES];
        [vc loadHtmlFromUrl:uri];
        return NO;
    }
    
    return YES;
}

//web增加关闭按钮
- (void) addShutButton
{
    if([self.webview canGoBack]){
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(handleLeftBarButtonClicked:)];
        UIImage *image = [ThemeImage(@"arrow_left") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        backItem.image = image;
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 32)];
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:_COLOR(0xff, 0x66, 0x19) forState:UIControlStateNormal];
        button.titleLabel.font = _FONT(16);
        UIBarButtonItem *closeItem=[[UIBarButtonItem alloc] initWithCustomView:button];
        [button addTarget:self action:@selector(handleCloseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *array = [NSArray arrayWithObjects:backItem, closeItem, nil];
        [[self navigationItem] setLeftBarButtonItems:array];
    }else{
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(handleLeftBarButtonClicked:)];
        UIImage *image = [ThemeImage(@"arrow_left") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        backItem.image = image;

        UIBarButtonItem *closeItem=[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
        
         NSArray *array = [NSArray arrayWithObjects:backItem, closeItem, nil];
        
        [[self navigationItem] setLeftBarButtonItems:array];
    }
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

#pragma set webUrl
- (void) loadHtmlFromUrlWithUserId:(NSString *) url
{
    if([UserInfoModel shareUserInfoModel].userId == nil){
        self.urlpath = url;
        self.shareUrl =  url;
    }
    else{
        self.urlpath = [NSString stringWithFormat:@"%@?userId=%@&uuid=%@", url, [UserInfoModel shareUserInfoModel].userId, [UserInfoModel shareUserInfoModel].uuid];
        self.shareUrl = [NSString stringWithFormat:@"%@?userId=%@&appShare=1&uuid=%@", url, [UserInfoModel shareUserInfoModel].userId, [UserInfoModel shareUserInfoModel].uuid];
    }
    
    if(self.webview){
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlpath]]];
        _isLoad = YES;
    }
}

- (void) loadHtmlFromUrlWithUuId:(NSString *) url
{
    if([UserInfoModel shareUserInfoModel].uuid == nil){
        self.urlpath = url;
        self.shareUrl =  url;
    }
    else{
        self.urlpath = [NSString stringWithFormat:@"%@?uuid=%@", url, [UserInfoModel shareUserInfoModel].uuid];
        self.shareUrl = [NSString stringWithFormat:@"%@?uuid=%@&appShare=1", url, [UserInfoModel shareUserInfoModel].uuid];
    }
    
    if(self.webview){
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlpath]]];
        _isLoad = YES;
    }
}

- (void) loadHtmlFromUrl:(NSString *) url
{
    self.urlpath = url;
    self.shareUrl = url;
    if(self.webview){
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlpath]]];
        _isLoad = YES;
    }
}

- (void) loadHtmlFromUrlWithAppId:(NSString *)url
{
    self.urlpath = url;
    self.shareUrl = [NSString stringWithFormat:@"%@%@", url, @"&appShare=1"];
    if(self.webview){
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlpath]]];
        _isLoad = YES;
    }
}

- (void) handleRightBarButtonClicked:(id)sender
{
    if(![self login])
        return;
    if(self.type == enumShareTypeShare)
        [self showPopView];
    else if(self.type == enumShareTypeToCustomer)
        [self showPopView1];
}

//普通分享
- (void) showPopView
{
    if(!popview){
        popview = [[PopView alloc] initWithImageArray:@[@"wechat", @"moments", @"qq", @"qzone"] nameArray:@[@"微信好友", @"朋友圈", @"QQ好友", @"QQ空间"]];
        [self.view.window addSubview:popview];
        popview.delegate = self;
    }
    
    [popview show];
}

//保单分享
- (void) showPopView1
{
    if(!popview){
        popview = [[PopView alloc] initWithImageArray:@[@"wechat", @"share_message"] nameArray:@[@"微信好友", @"手机短信"]];
        [self.view.window addSubview:popview];
        popview.delegate = self;
    }
    
    [popview show];
}


#pragma delegate
- (void) HandleItemSelect:(PopView *) view selectImageName:(NSString *)imageName
{
    if([imageName isEqualToString:@"wechat"])
        [self simplyShare:SSDKPlatformSubTypeWechatSession];
    else if ([imageName isEqualToString:@"moments"]){
        [self simplyShare:SSDKPlatformSubTypeWechatTimeline];
    }
    else if ([imageName isEqualToString:@"qq"]){
        [self simplyShare:SSDKPlatformSubTypeQQFriend];
    }
    else if ([imageName isEqualToString:@"qzone"]){
        [self simplyShare:SSDKPlatformSubTypeQZone];
    }
    else if ([imageName isEqualToString:@"share_message"])
        [self simplyShare:SSDKPlatformTypeSMS];
}

/**
 *  简单分享
 */
- (void)simplyShare:(SSDKPlatformType) type
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    //创建分享参数
    
    NSString *url = [self getshareUrlWithType:type];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    if(self.shareImgArray == nil || [self.shareImgArray count] == 0)
    {
        NSMutableArray *icon = [[NSMutableArray alloc] init];
        NSString *iconStr = [App_Delegate appIcon];
        if(iconStr)
            [icon addObject:iconStr];
        self.shareImgArray = icon;
    }
    
    
    if (self.shareImgArray) {
        
        [shareParams SSDKSetupShareParamsByText:self.shareContent
                                         images:self.shareImgArray
                                            url:[NSURL URLWithString:url]
                                          title:self.shareTitle
                                           type:SSDKContentTypeAuto];
        
        //进行分享
        [ShareSDK share:type
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             
             switch (state) {
                 case SSDKResponseStateSuccess:
                 {
                     [KGStatusBar showSuccessWithStatus:@"分享成功"];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     [KGStatusBar showSuccessWithStatus:@"分享失败"];
                     break;
                 }
                 default:
                     break;
             }
         }];
    }
}

- (NSString *) getshareUrlWithType:(SSDKPlatformType) plattype
{
    NSString *addtype = @"";
    if(plattype == SSDKPlatformSubTypeWechatSession){
        addtype = @"&shareType=3";
    }else if (plattype == SSDKPlatformSubTypeWechatTimeline){
        addtype = @"&shareType=9";
    }
    else if (plattype == SSDKPlatformSubTypeQQFriend ){
        addtype = @"&shareType=4";
    }
    else if (plattype == SSDKPlatformSubTypeQZone){
        addtype = @"&shareType=4";
    }
    
    return [NSString stringWithFormat:@"%@%@", self.shareUrl, addtype];
}

- (NSDictionary *) getShareInfo
{
    NSString *str = [self.webview stringByEvaluatingJavaScriptFromString:@"getShareInfo();"];
    SBJsonParser *_parser = [[SBJsonParser alloc] init];
    NSDictionary *dic = [_parser objectWithString:str];
    return dic;
}

//支付成功后刷新
- (void) handlePaySuccess
{
    [self.webview stringByEvaluatingJavaScriptFromString:@"paySuccess();"];
}

//提交报价成功后跳转
- (void) page2CarOrderList
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

@end
