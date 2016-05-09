//
//  HomeVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/18.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "HomeVC.h"
#import "define.h"
#import "NoticeListVC.h"
#import "InviteFriendsVC.h"
#import "AgentStrategyViewController.h"
#import "NetWorkHandler+index.h"
#import "PosterModel.h"
#import "HaedlineModel.h"
#import "UIButton+WebCache.h"
#import "WebViewController.h"
#import "SelectCustomerVC.h"
#import "AppDelegate.h"
#import "MyTeamInfoVC.h"
#import "ProductListVC.h"
#import "RootViewController.h"
#import "UITabBar+badge.h"
#import "CustomerServiceVC.h"
#import "PopView.h"
#import "OnlineCustomer.h"

@interface HomeVC ()<MJBannnerPlayerDeledage, PopViewDelegate>
{
    AppDelegate *appdelegate;

    UIButton * leftBarButtonItemButton;
    UIButton * rightBarButtonItemButton;

}

@property (nonatomic, strong) NSString *customerService;
@property (nonatomic, strong) NSArray *infoArray;
@end

@implementation HomeVC

@synthesize scrollview;
@synthesize headline;
@synthesize btnBroker;
@synthesize btnProduct;
@synthesize btnPlan;
@synthesize btnService;
@synthesize btnNewUser;
@synthesize btnDetail;
@synthesize btnMessage;
@synthesize imgBroker;
@synthesize imgService;
@synthesize btnCarLife;

- (void) dealloc
{
    AppContext *context = [AppContext sharedAppContext];
    [context removeObserver:self forKeyPath:@"isNewMessage"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AppContext *con= [AppContext sharedAppContext];
    if(con.isNewMessage)
    {
        self.btnMessage.imageView.badgeView.badgeValue = 1;
        [self.tabBarController.tabBar showBadgeOnItemIndex:0];
    }else{
        self.btnMessage.imageView.badgeView.badgeValue = 0;
        [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appdelegate = [UIApplication sharedApplication].delegate;
    AppContext *context = [AppContext sharedAppContext];
    [context addObserver:self forKeyPath:@"isNewMessage" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:ThemeImage(@"logo")];
    self.navigationItem.titleView = logoView;
    [self setLeftBarButtonWithImage:nil];

    [self initSubViews];
    
    self.headline.delegate = self;
    self.headline.imgTitle.image = ThemeImage(@"Hot");
    self.headline.backgroundColor = [UIColor whiteColor];//_COLOR(0xd8, 0xd8, 0xd8);
    
    self.btnMessage = [[HighNightBgButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    [self.btnMessage setImage:ThemeImage(@"user_message2") forState:UIControlStateNormal];
    [self setRightBarButtonWithButton:self.btnMessage];
    [self.btnMessage addTarget:self action:@selector(doBtnNoticeList:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnMessage.imageView.clipsToBounds = NO;
//    [self config];
    
    [self loadDatas];
    
}

- (void) initSubViews
{
    UIImage *imgNormal = nil;
    
    //整个视图的
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:scroll];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    
    //
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectZero];
    [scroll addSubview:bgview];
    bgview.translatesAutoresizingMaskIntoConstraints = NO;
    
    //banner的bg
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [bgview addSubview:scrollview];
    scrollview.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *titleBg = [[UIView alloc] initWithFrame:CGRectZero];
    titleBg.translatesAutoresizingMaskIntoConstraints = NO;
    [bgview addSubview:titleBg];
    titleBg.backgroundColor = [UIColor whiteColor];
    
    //快速算价
    HighNightBgButton *btnCalculate = [ViewFactory CreateButtonWithzFont:nil TextColor:nil image:ThemeImage(@"calculate")];
    [titleBg addSubview:btnCalculate];
    [btnCalculate addTarget:self action:@selector(doBtnQuote:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *sepView1 = [ViewFactory CreateView];
    [titleBg addSubview:sepView1];
    //我的团队
    HighNightBgButton *btnTeams = [ViewFactory CreateButtonWithzFont:nil TextColor:nil image:ThemeImage(@"my_teams")];
    [titleBg addSubview:btnTeams];
    [btnTeams addTarget:self action:@selector(doBtnMyTeams:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *sepView2 = [ViewFactory CreateView];
    [titleBg addSubview:sepView2];
    //邀请好友
    HighNightBgButton *btnInvite = [ViewFactory CreateButtonWithzFont:nil TextColor:nil image:ThemeImage(@"invite")];
    [titleBg addSubview:btnInvite];
    [btnInvite addTarget:self action:@selector(doBtnInvite:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *sepView3 = [ViewFactory CreateView];
    [titleBg addSubview:sepView3];
    sepView3.backgroundColor = SepLineColor;
    //我的客服
    HighNightBgButton *btnMyService = [ViewFactory CreateButtonWithzFont:nil TextColor:nil image:ThemeImage(@"service")];
    [titleBg addSubview:btnMyService];
    [btnMyService addTarget:self action:@selector(doBtnMyService:) forControlEvents:UIControlEventTouchUpInside];
    
    headline = [[HeadlineView alloc] initWithFrame:CGRectZero];
    headline.translatesAutoresizingMaskIntoConstraints = NO;
    [bgview addSubview:headline];
    
    UIView *contenBg = [[UIView alloc] initWithFrame:CGRectZero];
    contenBg.translatesAutoresizingMaskIntoConstraints = NO;
    [bgview addSubview:contenBg];
    
    btnProduct = [ViewFactory CreateButtonWithImage:ThemeImage(@"product")];
    [contenBg addSubview:btnProduct];
    [btnProduct setSepLineType:NO right:NO top:YES bottom:NO];
    [btnProduct addTarget:self action:@selector(doBtnProductSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    btnPlan = [ViewFactory CreateButtonWithImage:ThemeImage(@"jihuashu")];
    [contenBg addSubview:btnPlan];
    [btnPlan setSepLineType:NO right:NO top:YES bottom:NO];
    [btnPlan addTarget:self action:@selector(doBtnJiHuaShu:) forControlEvents:UIControlEventTouchUpInside];
    
    imgBroker = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgBroker.translatesAutoresizingMaskIntoConstraints = NO;
    [contenBg addSubview:imgBroker];
    imgBroker.backgroundColor = SepLineColor;
    
    btnBroker = [ViewFactory CreateButtonWithImage:imgNormal];
    [contenBg addSubview:btnBroker];
    [btnBroker setSepLineType:NO right:NO top:YES bottom:NO];
    [btnBroker addTarget:self action:@selector(doBtnAgentStrategy:) forControlEvents:UIControlEventTouchUpInside];
    
    imgService = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgService.translatesAutoresizingMaskIntoConstraints = NO;
    [contenBg addSubview:imgService];
    imgService.backgroundColor = SepLineColor;
    
    btnService = [ViewFactory CreateButtonWithImage:imgNormal];
    [contenBg addSubview:btnService];
    [btnService setSepLineType:NO right:NO top:YES bottom:NO];
    [btnService addTarget:self action:@selector(doBtnFuWuZhiCheng:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *newUserBg = [[UIView alloc] initWithFrame:CGRectZero];
    [bgview addSubview:newUserBg];
    newUserBg.translatesAutoresizingMaskIntoConstraints = NO;
    
    btnNewUser = [ViewFactory CreateButtonWithImage:imgNormal];
    [newUserBg addSubview:btnNewUser];
    [btnNewUser setSepLineType:NO right:NO top:YES bottom:NO];
    [btnNewUser addTarget:self action:@selector(doBtnNewUser:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *infoBg = [[UIView alloc] initWithFrame:CGRectZero];
    infoBg.translatesAutoresizingMaskIntoConstraints = NO;
    [bgview addSubview:infoBg];
    infoBg.backgroundColor = SepLineColor;
    
    btnDetail = [ViewFactory CreateButtonWithImage:imgNormal];
    [infoBg addSubview:btnDetail];
    [btnDetail setSepLineType:NO right:NO top:YES bottom:NO];
    [btnDetail addTarget:self action:@selector(doBtnDuSheBaoXian:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCarLife = [ViewFactory CreateButtonWithImage:imgNormal];
    [infoBg addSubview:btnCarLife];
    [btnCarLife setSepLineType:NO right:NO top:YES bottom:NO];
    [btnCarLife addTarget:self action:@selector(doBtnCarLife:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(scroll, bgview, scrollview, titleBg, headline, contenBg, newUserBg, infoBg, btnCalculate, btnTeams, btnInvite, btnMyService, sepView1, sepView2, sepView3, btnProduct, btnPlan, btnBroker, btnService, btnNewUser, btnDetail, imgBroker, imgService, btnCarLife);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scroll]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scroll]-0-|" options:0 metrics:nil views:views]];
    
    [scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bgview]-0-|" options:0 metrics:nil views:views]];
    [scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bgview]-0-|" options:0 metrics:nil views:views]];
    [scroll addConstraint:[NSLayoutConstraint constraintWithItem:bgview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:ScreenWidth]];
    
    [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollview]-0-|" options:0 metrics:nil views:views]];
    [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleBg]-0-|" options:0 metrics:nil views:views]];
    [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headline]-0-|" options:0 metrics:nil views:views]];
    [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contenBg]-0-|" options:0 metrics:nil views:views]];
    [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[newUserBg]-0-|" options:0 metrics:nil views:views]];
    [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[infoBg]-0-|" options:0 metrics:nil views:views]];
    [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollview]-0-[headline(40)]-0-[titleBg(100)]-0-[contenBg]-0-[newUserBg]-0-[infoBg]-0-|" options:0 metrics:nil views:views]];
    
    [bgview addConstraint:[NSLayoutConstraint constraintWithItem:scrollview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[Util getHeightByWidth:750 height:320 nwidth:ScreenWidth]]];
    [bgview addConstraint:[NSLayoutConstraint constraintWithItem:newUserBg attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[Util getHeightByWidth:750 height:180 nwidth:ScreenWidth]]];
    [bgview addConstraint:[NSLayoutConstraint constraintWithItem:infoBg attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[Util getHeightByWidth:750 height:440 nwidth:ScreenWidth]]];
    
    [titleBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[btnCalculate]-0-[sepView1]-0-[btnTeams]-0-[sepView2]-0-[btnInvite]-0-[sepView3]-0-[btnMyService]-10-|" options:0 metrics:nil views:views]];
    [titleBg addConstraint:[NSLayoutConstraint constraintWithItem:btnCalculate attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:titleBg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [titleBg addConstraint:[NSLayoutConstraint constraintWithItem:sepView1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:titleBg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [titleBg addConstraint:[NSLayoutConstraint constraintWithItem:btnTeams attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:titleBg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [titleBg addConstraint:[NSLayoutConstraint constraintWithItem:sepView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:titleBg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [titleBg addConstraint:[NSLayoutConstraint constraintWithItem:btnInvite attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:titleBg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [titleBg addConstraint:[NSLayoutConstraint constraintWithItem:sepView3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:titleBg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [titleBg addConstraint:[NSLayoutConstraint constraintWithItem:btnMyService attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:titleBg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [titleBg addConstraint:[NSLayoutConstraint constraintWithItem:sepView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:sepView1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [titleBg addConstraint:[NSLayoutConstraint constraintWithItem:sepView3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:sepView1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [contenBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[btnProduct]-0-[btnPlan]-0-|" options:0 metrics:nil views:views]];
    [contenBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imgBroker]-0-[imgService]-0-|" options:0 metrics:nil views:views]];
    [contenBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[btnProduct]-0-[imgBroker]-0-|" options:0 metrics:nil views:views]];
    [contenBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[btnPlan]-0-[imgService]-0-|" options:0 metrics:nil views:views]];
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnProduct attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:btnPlan attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnBroker attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:btnService attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnProduct attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[Util getHeightByWidth:750 height:180 nwidth:ScreenWidth]]];
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnPlan attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[Util getHeightByWidth:750 height:180 nwidth:ScreenWidth]]];
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnBroker attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[Util getHeightByWidth:750 height:440 nwidth:ScreenWidth]]];
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnService attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[Util getHeightByWidth:750 height:440 nwidth:ScreenWidth]]];
    
    
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnBroker attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imgBroker attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnBroker attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:imgBroker attribute:NSLayoutAttributeRight multiplier:1 constant:-0.5]];
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnBroker attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imgBroker attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnBroker attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imgBroker attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnService attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imgService attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnService attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:imgService attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnService attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imgService attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [contenBg addConstraint:[NSLayoutConstraint constraintWithItem:btnService attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imgService attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [newUserBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[btnNewUser]-0-|" options:0 metrics:nil views:views]];
    [newUserBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[btnNewUser]-0-|" options:0 metrics:nil views:views]];
    
    [infoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[btnDetail]-0.5-[btnCarLife]-0-|" options:0 metrics:nil views:views]];
    [infoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[btnDetail]-0-|" options:0 metrics:nil views:views]];
    [infoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[btnCarLife]-0-|" options:0 metrics:nil views:views]];
    [infoBg addConstraint:[NSLayoutConstraint constraintWithItem:btnDetail attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:btnCarLife attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
}

# pragma mark - Custom view configuration

- (void) config
{
    self.scrollview.delegate = self;
    /* Refresh View */
    refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    refreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    refreshView.delegate = self;
    [self.scrollview addSubview:refreshView];
    
}



- (void) loadDatas
{
    [NetWorkHandler requestToIndex:^(int code, id content) {
        [refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollview];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            NSDictionary *d = [content objectForKey:@"data"];
            _adArray = [PosterModel modelArrayFromArray:[d objectForKey:@"poster"]];
            _headlineArray = [HeadlineModel modelArrayFromArray:[d objectForKey:@"headlines"]];
            _newUserModel = (NewUserModel*)[NewUserModel modelFromDictionary:[d objectForKey:@"newUser"]];
//            _liPeiChuXian = (AnnouncementModel*)[AnnouncementModel modelFromDictionary:[d objectForKey:@"liPeiChuXian"]];
            _jiHuaShu = (AnnouncementModel*)[AnnouncementModel modelFromDictionary:[d objectForKey:@"jiHuaShu"]];
//            _duSheBaoXian = (AnnouncementModel*)[AnnouncementModel modelFromDictionary:[d objectForKey:@"duSheBaoXian"]];
//            _chengGongZhiLu = (AnnouncementModel*)[AnnouncementModel modelFromDictionary:[d objectForKey:@"chengGongZhiLu"]];
            _quoteUrl = [d objectForKey:@"quoteUrl"];
            appdelegate.customerBanner = (NewUserModel*)[NewUserModel modelFromDictionary:[d objectForKey:@"customerBanner"]];
            appdelegate.workBanner = (NewUserModel*)[NewUserModel modelFromDictionary:[d objectForKey:@"workBanner"]];
            appdelegate.inviteBanner = (NewUserModel*)[NewUserModel modelFromDictionary:[d objectForKey:@"friendBanner"]];
            self.customerService = [d objectForKey:@"customerService"];
            self.infoArray = [AnnouncementModel modelArrayFromArray:[d objectForKey:@"gongLue"]];
            [self initData];
        }
    }];
}


- (void) initData
{
     NSMutableArray * mArray  =  [[NSMutableArray alloc]init];
     for (int i = 0; i < _adArray.count; i++) {
          PosterModel *item = [_adArray objectAtIndex:i];
          [mArray addObject:item.imgUrl];
     }

    [MJBannnerPlayer initWithUrlArray:mArray
                                addTarget:self.scrollview
                                 delegate:self
                                 withSize:CGRectMake(0, 0, self.view.frame.size.width, [Util getHeightByWidth:375 height:160 nwidth:ScreenWidth])
                         withTimeInterval:4.f];
    
   
    UIImage *normal = nil;
    [self.headline reloadData];
    [self.btnNewUser sd_setBackgroundImageWithURL:[NSURL URLWithString:_newUserModel.imgUrl] forState:UIControlStateNormal placeholderImage:normal];
//    [self.btnPlan sd_setBackgroundImageWithURL:[NSURL URLWithString:_jiHuaShu.bgImg] forState:UIControlStateNormal placeholderImage:normal];
    if([self.infoArray count] > 0){
        AnnouncementModel *chengGongZhiLu = [self.infoArray objectAtIndex:0];
        [self.btnBroker sd_setBackgroundImageWithURL:[NSURL URLWithString:chengGongZhiLu.bgImg] forState:UIControlStateNormal placeholderImage:normal];
        self.btnBroker.hidden = NO;
        if([self.infoArray count] > 1){
            AnnouncementModel *liPeiChuXian = [self.infoArray objectAtIndex:1];
            [self.btnService sd_setBackgroundImageWithURL:[NSURL URLWithString:liPeiChuXian.bgImg] forState:UIControlStateNormal placeholderImage:normal];
            self.btnService.hidden = NO;
            if([self.infoArray count] > 2){
                AnnouncementModel *duSheBaoXian = [self.infoArray objectAtIndex:2];
                [self.btnDetail sd_setBackgroundImageWithURL:[NSURL URLWithString:duSheBaoXian.bgImg] forState:UIControlStateNormal placeholderImage:normal];
                self.btnDetail.hidden = NO;
                if([self.infoArray count] > 3){
                    AnnouncementModel *cheshenghuo = [self.infoArray objectAtIndex:3];
                    [self.btnCarLife sd_setBackgroundImageWithURL:[NSURL URLWithString:cheshenghuo.bgImg] forState:UIControlStateNormal placeholderImage:normal];
                    self.btnCarLife.hidden = NO;
                }else
                    self.btnCarLife.hidden = YES;
            }else{
                self.btnCarLife.hidden = YES;
                self.btnDetail.hidden = YES;
            }
        }else{
            self.btnCarLife.hidden = YES;
            self.btnDetail.hidden = YES;
            self.btnService.hidden = YES;
        }
    }else{
        self.btnCarLife.hidden = YES;
        self.btnDetail.hidden = YES;
        self.btnService.hidden = YES;
        self.btnBroker.hidden = YES;
    }
}

# pragma mark MJBannnerPlayer delegate
-(void)MJBannnerPlayer:(UIView *)bannerPlayer didSelectedIndex:(NSInteger)index{
    
   // NSLog(@"%ld",(long)index);
    PosterModel *model = [_adArray objectAtIndex:index];
    if(model.isRedirect == 1){
        WebViewController *vc = [IBUIFactory CreateWebViewController];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = model.title;
        vc.type = enumShareTypeShare;
        if(model.imgUrl != nil)
            vc.shareImgArray = [NSArray arrayWithObject:model.imgUrl];
        vc.shareTitle = model.title;
        [self.navigationController pushViewController:vc animated:YES];
        if(model.url == nil){
            [vc loadHtmlFromUrlWithUserId:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", model.pid]];
        }else{
            [vc loadHtmlFromUrlWithUserId:model.url];
        }
    }

}

#pragma HeadlineViewDelegate
- (void) headline:(HeadlineCell *)head cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(head != nil){
        HeadlineModel *model = [_headlineArray objectAtIndex:indexPath.row];
        
        head.lbDetail.text = model.title;
    }
}

- (void) headline:(HeadlineView *)headline SelectAtIndexPath:(NSIndexPath *)indexpath
{
    if([_headlineArray count] > 0){
        HeadlineModel *model = [_headlineArray objectAtIndex:indexpath.row];
        if(model && model.isRedirect){
            WebViewController *web = [IBUIFactory CreateWebViewController];
            web.hidesBottomBarWhenPushed = YES;
            web.title = model.title;
            web.type = enumShareTypeShare;
            web.shareTitle = model.title;
            [self.navigationController pushViewController:web animated:YES];
            
            if(model.url == nil){
                [web loadHtmlFromUrlWithUserId:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", model.hid]];
            }else{
                [web loadHtmlFromUrlWithUserId:model.url];
            }
        }
    }
}

#pragma HeadlineViewDelegate
- (NSInteger) numberOfRows:(HeadlineView *)headline
{
    return [_headlineArray count];
}

- (void)doBtnProductSelect:(id)sender
{
    ProductListVC *vc = [[ProductListVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) doBtnNoticeList:(id) sender
{

    NoticeListVC *vc = [[NoticeListVC alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doBtnInvite:(id)sender
{
    if([self login]){
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NewUserModel *model = appDelegate.workBanner;
        if(model.isRedirect){
            WebViewController *web = [IBUIFactory CreateWebViewController];
            web.title = model.title;
            web.type = enumShareTypeShare;
            web.shareTitle = model.title;
            web.shareContent = model.content;
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            if(model.url){
                [web loadHtmlFromUrlWithUserId:[NSString stringWithFormat:@"%@", model.url]];
            }else{
                NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", model.nid];
                [web loadHtmlFromUrlWithUserId:[NSString stringWithFormat:@"%@",url]];
            }
        }
        
    }
}

- (void)doBtnMyTeams:(id)sender
{
    if([self login]){
        
        MyTeamInfoVC *vc = [[MyTeamInfoVC alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userid = [UserInfoModel shareUserInfoModel].userId;
        vc.title = @"我的团队";
        vc.toptitle = @"我的队员";
        vc.name = @"我";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) doBtnAgentStrategy:(id)sender
{
//    BOOL result = [self login];
//    if(result){
    if([self.infoArray count] > 0){
        AnnouncementModel *chengGongZhiLu = [self.infoArray objectAtIndex:0];
        AgentStrategyViewController *vc = [[AgentStrategyViewController alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        vc.category = chengGongZhiLu.category;
        vc.title = chengGongZhiLu.title;
        vc.totalModel = chengGongZhiLu;
        [self.navigationController pushViewController:vc animated:YES];
    }
//    }
}

- (void) doBtnJiHuaShu:(id) sender
{
    AgentStrategyViewController *vc = [[AgentStrategyViewController alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.category = _jiHuaShu.category;
    vc.title = _jiHuaShu.title;
    vc.totalModel = _jiHuaShu;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) doBtnFuWuZhiCheng:(id) sender
{
    if([self.infoArray count] > 1){
        AnnouncementModel *liPeiChuXian = [self.infoArray objectAtIndex:1];
        AgentStrategyViewController *vc = [[AgentStrategyViewController alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        vc.category = liPeiChuXian.category;
        vc.title = liPeiChuXian.title;
        vc.totalModel = liPeiChuXian;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) doBtnDuSheBaoXian:(id) sender
{
    if([self.infoArray count] > 2){
        AnnouncementModel *duSheBaoXian = [self.infoArray objectAtIndex:2];
        AgentStrategyViewController *vc = [[AgentStrategyViewController alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        vc.category = duSheBaoXian.category;
        vc.title = duSheBaoXian.title;
        vc.totalModel = duSheBaoXian;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) doBtnCarLife:(id) sender
{
    if([self.infoArray count] > 3){
        AnnouncementModel *carLife = [self.infoArray objectAtIndex:3];
        AgentStrategyViewController *vc = [[AgentStrategyViewController alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        vc.category = carLife.category;
        vc.title = carLife.title;
        vc.totalModel = carLife;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) doBtnMyService:(id)sender
{
    PopView *popview = [[PopView alloc] initWithImageArray:@[@"wechat", @"share_message"] nameArray:@[@"客服电话", @"在线咨询"]];
    [self.view.window addSubview:popview];
    popview.delegate = self;
    [popview show];
}

- (void) HandleItemSelect:(PopView *) view withTag:(NSInteger) tag
{
    if(tag == 0){
        NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",ServicePhone]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }else{
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
        [OnlineCustomer sharedInstance].navTitle=zxTitle;
        [OnlineCustomer sharedInstance].groupName=bjkf;
        [ProgressHUD show:@"连接客服..."];
        [[OnlineCustomer sharedInstance] userInfoInit:[UserInfoModel shareUserInfoModel].realName sex:msex Province:[UserInfoModel shareUserInfoModel].liveProvince City:[UserInfoModel shareUserInfoModel].liveCity phone:[UserInfoModel shareUserInfoModel].phone headImage:placeholderImage nav:self.navigationController leftBtn:leftBarButtonItemButton rightBtn:rightBarButtonItemButton];
    }
}

-(void) kefuNavigationBar{
    // 左边按钮
    leftBarButtonItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftBarButtonItemButton setImage:[UIImage imageNamed:@"arrow_left"]
                             forState:UIControlStateNormal];
    //    [leftBarButtonItemButton addTarget:self action:@selector(leftBarButtonItemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    // 右边按钮
    rightBarButtonItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    //        [_rightBarButtonItemButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    
    [rightBarButtonItemButton setTitle:@"更多" forState:UIControlStateNormal];
    [rightBarButtonItemButton setTitleColor:UIColorFromRGB(0xff6619)forState:UIControlStateNormal];
}

- (void) doBtnNewUser:(id)sender
{
    if(_newUserModel && _newUserModel.isRedirect){
        WebViewController *web = [IBUIFactory CreateWebViewController];
        web.hidesBottomBarWhenPushed = YES;
        web.title = _newUserModel.title;
        web.type = enumShareTypeShare;
        if(_newUserModel.imgUrl != nil)
            web.shareImgArray = [NSArray arrayWithObject:_newUserModel.imgUrl];
        web.shareTitle = _newUserModel.title;
        web.shareContent = _newUserModel.content;
        [self.navigationController pushViewController:web animated:YES];
        
        if(_newUserModel.url == nil){
            [web loadHtmlFromUrlWithUserId:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", _newUserModel.nid]];
        }else{
            [web loadHtmlFromUrlWithUserId:_newUserModel.url];
        }
    }
}

- (void)doBtnSelectForInsur:(id)sender
{
    if([self login]){
        SelectCustomerVC *vc = [[SelectCustomerVC alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) doBtnQuote:(id) sender
{
    QuickQuoteVC *web = [IBUIFactory CreateQuickQuoteVC];
    web.hidesBottomBarWhenPushed = YES;
    web.title = @"快速算价";
    web.type = enumShareTypeNo;
    web.shareTitle = @"算价方案";
    [self.navigationController pushViewController:web animated:YES];
    
    [web loadHtmlFromUrlWithUserId:_quoteUrl];
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
//    [pullDelegate pullTableViewDidTriggerRefresh:self];
    [self loadDatas];
}

//- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
//    return self.pullLastRefreshDate;
//}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [refreshView egoRefreshScrollViewDidScroll:scrollView];
    
    // Also forward the message to the real delegate
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    
    // Also forward the message to the real delegate
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [refreshView egoRefreshScrollViewWillBeginDragging:scrollView];
    
    // Also forward the message to the real delegate
}

@end
