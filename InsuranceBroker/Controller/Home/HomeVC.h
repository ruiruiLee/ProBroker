//
//  HomeVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/18.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "HeadlineView.h"
#import "MainFunctionButton.h"
#import "LeftImgButton.h"
#import "MJBannnerPlayer.h"
#import "NewUserModel.h"
#import "EGORefreshTableHeaderView.h"
#import "AnnouncementModel.h"

@interface HomeVC : BaseViewController<HeadlineViewDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate>
{
    EGORefreshTableHeaderView *refreshView;
    //ad
    NSArray *_adArray;
    //headline
    NSArray *_headlineArray;
    //newuser
    NewUserModel *_newUserModel;
    AnnouncementModel *_liPeiChuXian;
    AnnouncementModel *_jiHuaShu;
    AnnouncementModel *_duSheBaoXian;
    AnnouncementModel *_chengGongZhiLu;
    
    NSString *_quoteUrl;
}

@property (nonatomic, strong) UIScrollView *scrollview;

@property (nonatomic, strong) HeadlineView *headline;
//@property (nonatomic, strong) UIView *adView;

@property (nonatomic, strong) HighNightBgButton *btnProduct;//产品目录
@property (nonatomic, strong) HighNightBgButton *btnPlan;//计划书
@property (nonatomic, strong) HighNightBgButton *btnBroker;//经纪人成长之路
@property (nonatomic, strong) HighNightBgButton *btnService;//服务支撑


//底部图片跳转页面
@property (nonatomic, strong) HighNightBgButton *btnNewUser;
@property (nonatomic, strong) HighNightBgButton *btnDetail;

@property (nonatomic, strong) HighNightBgButton *btnMessage;

@property (nonatomic, strong) UIImageView *imgBroker;
@property (nonatomic, strong) UIImageView *imgService;
@property (nonatomic, strong) UIImageView *imgDetail;


//我的消息
- (void) doBtnNoticeList:(id) sender;
- (void) doBtnAgentStrategy:(id)sender;
- (void) doBtnMyService:(id)sender;

@end
