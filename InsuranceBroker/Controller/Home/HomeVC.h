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
#import "AnnouncementModel.h"
#import "SepLineButton.h"

@interface HomeVC : BaseViewController<HeadlineViewDelegate, UIScrollViewDelegate>
{
    //ad
    NSArray *_adArray;
    //headline
    NSArray *_headlineArray;
    //newuser
    NewUserModel *_newUserModel;
//    AnnouncementModel *_jiHuaShu;
    
    NSString *_quoteUrl;
}

@property (nonatomic, strong) UIScrollView *scrollview;

@property (nonatomic, strong) UIScrollView *scroll;//背景scroll；

@property (nonatomic, strong) HeadlineView *headline;
//@property (nonatomic, strong) UIView *adView;

@property (nonatomic, strong) SepLineButton *btnProduct;//产品目录
@property (nonatomic, strong) SepLineButton *btnPlan;//计划书
@property (nonatomic, strong) SepLineButton *btnBroker;//经纪人成长之路
@property (nonatomic, strong) SepLineButton *btnService;//服务支撑

@property (nonatomic, strong) HighNightBgButton *btnMyService;//我的客服


@property (nonatomic, strong) SepLineButton *btnDetail;//毒舌保险
@property (nonatomic, strong) SepLineButton *btnCarLife;//互联网车生活

//底部图片跳转页面
@property (nonatomic, strong) SepLineButton *btnNewUser;

@property (nonatomic, strong) HighNightBgButton *btnMessage;

@property (nonatomic, strong) UIImageView *imgBroker;
@property (nonatomic, strong) UIImageView *imgService;
@property (nonatomic, strong) AnnouncementModel *jiHuaShu;


//我的消息
- (void) doBtnNoticeList:(id) sender;
- (void) doBtnAgentStrategy:(id)sender;
- (void) doBtnMyService:(id)sender;

@end
