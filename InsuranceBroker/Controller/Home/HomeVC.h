//
//  HomeVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/18.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "MainFunctionButton.h"
#import "LeftImgButton.h"
#import "MJBannnerPlayer.h"
#import "NewUserModel.h"
#import "AnnouncementModel.h"
#import "SepLineButton.h"

#import "DictModel.h"

@interface HomeVC : BaseViewController<UIScrollViewDelegate>
{
    //ad
    NSArray *_adArray;
}
@property (nonatomic, strong) HighNightBgButton *btnMessage;
@property (nonatomic, strong) AnnouncementModel *jiHuaShu;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;

@property (nonatomic, strong) IBOutlet UIScrollView *scroll;//背景scroll；
@property (nonatomic, strong) IBOutlet UIView *bgview;//背景scroll；

@property (nonatomic, strong) IBOutlet UIScrollView *scrollForStudy;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIButton *btnBg;

@property (nonatomic, strong) IBOutlet UIButton *btnMyService;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *viewWidth;
//@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tableHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *infoHeight;

@property (nonatomic, strong) IBOutlet UIView *commondView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *commondViewHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *commondViewBootomSpace;

@end
