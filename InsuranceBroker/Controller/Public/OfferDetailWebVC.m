//
//  OfferDetailWebVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/6.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "OfferDetailWebVC.h"
#import "NetWorkHandler+initOrderShare.h"
#import "SBJson.h"
#import "MyJSInterface.h"
#import "define.h"
#import "KGStatusBar.h"
#import "OnlineCustomer.h"
#import "BaseNavigationController.h"

@interface OfferDetailWebVC ()<UIWebViewDelegate>
{
    UIButton * leftBarButtonItemButton;
    UIButton * rightBarButtonItemButton;
}

@end

@implementation OfferDetailWebVC

- (void) dealloc
{
    AppContext *context = [AppContext sharedAppContext];
    [context removeObserver:self forKeyPath:@"isBDKFHasMsg"];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        _urlPath = nil;
    }
    
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AppContext *con= [AppContext sharedAppContext];
    
    if(con.isBDKFHasMsg){
        [self showBadgeWithFlag:YES];
    }
    else{
        [self showBadgeWithFlag:NO];
    }
}

- (void) showBadgeWithFlag:(BOOL) flag
{
    if(flag)
        self.btnChat.imageView.badgeView.badgeValue = 1;
    else
        self.btnChat.imageView.badgeView.badgeValue = 0;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    AppContext *context = [AppContext sharedAppContext];
    [context addObserver:self forKeyPath:@"isBDKFHasMsg" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
//    [self setRightBarButtonWithImage:ThemeImage(@"chat")];
    self.btnChat = [[HighNightBgButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.btnChat setImage:ThemeImage(@"chat") forState:UIControlStateNormal];
    [self.btnChat addTarget:self action:@selector(handleRightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightBarButtonWithButton:self.btnChat];
    self.btnChat.clipsToBounds = NO;
    self.btnChat.imageView.clipsToBounds = NO;
    [self observeValueForKeyPath:@"isBDKFHasMsg" ofObject:nil change:nil context:nil];
}

- (void) initShareUrl:(NSString *) orderId insuranceType:(NSString *) insuranceType planOfferId:(NSString *) planOfferId
{
    _orderId = orderId;
    _insuranceType = insuranceType;
    _planOfferId = planOfferId;
}

- (void) loadUrl
{
    [NetWorkHandler requestToInitOrderShare:_orderId insuranceType:_insuranceType planOfferId:_planOfferId Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            _urlPath = [[content objectForKey:@"data"] objectForKey:@"url"];
            self.shareContent = [[content objectForKey:@"data"] objectForKey:@"content"];
            self.shareTitle = [[content objectForKey:@"data"] objectForKey:@"title"];
            self.phone = [[content objectForKey:@"data"] objectForKey:@"phone"];
            if([[content objectForKey:@"data"] objectForKey:@"imgUrl"])
                self.shareImgArray = [NSArray arrayWithObject:[[content objectForKey:@"data"] objectForKey:@"imgUrl"]];
            if(selectImgName >= 0)
                [self HandleItemSelect:nil selectImageName:selectImgName];
        }
    }];
}

//#pragma delegate
- (void) HandleItemSelect:(PopView *) view selectImageName:(NSString *) imageName
{
    selectImgName = imageName;
    if(_urlPath != nil){
        [super HandleItemSelect:view selectImageName:imageName];
    }else{
        [self loadUrl];
    }
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
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    if(self.shareImgArray == nil || [self.shareImgArray count] == 0){
        NSMutableArray *icon = [[NSMutableArray alloc] init];
        AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
        if(appdelegate.appIcon)
            [icon addObject:appdelegate.appIcon];
        self.shareImgArray = icon;
    }
    
    if (self.shareImgArray) {
        
        if(type == SSDKPlatformTypeSMS){
            NSString *jsonstr = [self getShareContent];
            SBJsonParser *_parser = [[SBJsonParser alloc] init];
            NSDictionary *dic = [_parser objectWithString:jsonstr];
            NSArray *array = nil;
            if(self.phone)
                array = [NSArray arrayWithObject:self.phone];
            NSString *content = [dic objectForKey:@"sms"];
            if(content == nil)
                content = @"";
            [shareParams SSDKSetupSMSParamsByText:content title:nil images:nil attachments:nil recipients:array type:SSDKContentTypeAuto];
        }
        else{
            [shareParams SSDKSetupShareParamsByText:self.shareContent
                                             images:self.shareImgArray
                                                url:[NSURL URLWithString:_urlPath]
                                              title:self.shareTitle
                                               type:SSDKContentTypeAuto];
        }
        
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
//                 case SSDKResponseStateCancel:
//                 {
//                     
//                     [KGStatusBar showSuccessWithStatus:@"分享已取消"];
//                     break;
//                 }
                 default:
                     break;
             }
             
         }];
    }
}

- (NSString *) getShareContent
{
    NSString *str = [self.webview stringByEvaluatingJavaScriptFromString:@"loadSmsContent();"];
    return str;
}

- (void) NotifyShareWindowWithPrama:(NSDictionary *)dic
{
    [self showPopView1];
}

-(void) kefuNavigationBar{
    // 左边按钮
    leftBarButtonItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftBarButtonItemButton setImage:[UIImage imageNamed:@"arrow_left"]
                             forState:UIControlStateNormal];
    [leftBarButtonItemButton addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 右边按钮
    rightBarButtonItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
     [rightBarButtonItemButton setImage:[UIImage imageNamed:@"garbage"] forState:UIControlStateNormal];
}

- (void) doBtnClicked:(id) sender
{
    AppContext *con= [AppContext sharedAppContext];
    con.isBDKFHasMsg = NO;
    [con saveData];
}

- (void) handleRightBarButtonClicked:(id)sender
{
    self.btnChat.imageView.badgeView.badgeValue = 0;
    
    NSString * msex =@"男";
    UIImage *placeholderImage = ThemeImage(@"head_male");
    if([UserInfoModel shareUserInfoModel].sex==2){
        msex =@"女";
        placeholderImage = ThemeImage(@"head_famale");
    }
    if([UserInfoModel shareUserInfoModel].headerImg!=nil){
        placeholderImage =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[UserInfoModel shareUserInfoModel].headerImg]]];
    }
    
    [self kefuNavigationBar];
    [OnlineCustomer sharedInstance].navTitle=bjTitle;
    [OnlineCustomer sharedInstance].groupName=bjkf;
    [ProgressHUD show:@"连接客服..."];
    
    _isLoad = YES;
    __weak OfferDetailWebVC *weakself = self;
    __weak UIButton *weakleftBarButtonItemButton = leftBarButtonItemButton;
    __weak UIButton *weakrightBarButtonItemButton = rightBarButtonItemButton;
    self.initWithUrl = ^(NSString *url){
        NSString *detail = [NSString stringWithFormat:@"车主: %@  (%@)", weakself.customerName, weakself.carNo];
        detail = [detail stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
        [[OnlineCustomer sharedInstance] userInfoInit:[UserInfoModel shareUserInfoModel].realName sex:msex Province:[UserInfoModel shareUserInfoModel].liveProvince City:[UserInfoModel shareUserInfoModel].liveCity phone:[UserInfoModel shareUserInfoModel].phone headImage:placeholderImage baodanLogoUrlstring:weakself.insModel.productLogo baodanDetail:detail baodanPrice:[NSString stringWithFormat:@"¥ %.2f",weakself.insModel.planInsuranceCompanyPrice] baodanURL:url baodanCallbackID:weakself.orderId nav:weakself.navigationController leftBtn:weakleftBarButtonItemButton rightBtn:weakrightBarButtonItemButton];
    };
    
    [self loadShortUrl:self.urlpath];
    [OnlineCustomer sharedInstance].BaodanInfoClicked = ^(NSString *sid){
        WebViewController *web = [IBUIFactory CreateWebViewController];
        web.title = @"保单详情";
        [weakself.navigationController pushViewController:web animated:YES];
        NSString *urlpath = [NSString stringWithFormat:@"%@&fxBut=0&tbBut=0", self.urlpath];
        [web loadHtmlFromUrl:urlpath];
    };
    
}

@end
