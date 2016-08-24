//
//  UserCenterVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/18.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "TopImageButton.h"
#import "GradientView.h"
#import "UserNameEditButton.h"
#import "UIScrollView+JElasticPullToRefresh.h"
#import "UserCenterHeaderBgView.h"

@interface UserCenterVC : BaseViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UIImageView *photoImgV;
@property (nonatomic, strong) IBOutlet UIImageView *logoImgv;
@property (nonatomic, strong) IBOutlet UILabel *lbRole;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UserNameEditButton *btNameEdit;
@property (nonatomic, strong) IBOutlet UserCenterHeaderBgView *gradientView;
@property (nonatomic, strong) IBOutlet UILabel *lbCertificate;

//
@property (nonatomic, strong) IBOutlet UILabel *lbMonthOrderSuccessNums;//车险本月保费
@property (nonatomic, strong) IBOutlet UILabel *lbTotalOrderSuccessNums;//个险本月单量
@property (nonatomic, strong) IBOutlet UILabel *lbPersonalMonthOrderSuccessNums;//个险本月保费
@property (nonatomic, strong) IBOutlet UILabel *lbPersonalTotalOrderSuccessNums;//个险本月单量
@property (nonatomic, strong) IBOutlet UILabel *lbMonthOrderEarn;//总订单收益;
@property (nonatomic, strong) IBOutlet UILabel *lbOrderEarn;//累计收益;
@property (nonatomic, strong) IBOutlet UILabel *lbTotalOrderCount;//总订单数
@property (nonatomic, strong) IBOutlet UILabel *lbUserInvite;
@property (nonatomic, strong) IBOutlet UILabel *lbTeamTotal;
@property (nonatomic, strong) IBOutlet UILabel *lbNowMonthOrderCount;

@property (nonatomic, strong) IBOutlet UILabel *lbRedLogo;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *redFlagConstraint;

//约束
//@property (nonatomic, strong) IBOutlet NSLayoutConstraint *headVConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *headHConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *footVConstraint;

@property (nonatomic, strong) IBOutlet UIButton *btnEditPhoto;

//修改用户资料
- (IBAction)EditUserInfo:(id)sender;

//我的红包
- (IBAction)redPachet:(id)sender;

//设置
- (IBAction)doBtnUserSetting:(id)sender;

//收益提现
- (IBAction)withdraw:(id)sender;

//我的邀请
- (IBAction)invite:(id)sender;

//整体规模
- (IBAction)scale:(id)sender;

//上月已经完成
- (IBAction)finish:(id)sender;

//上月收益
- (IBAction)incomePrevMounth:(id)sender;

//认证
- (IBAction)authentication:(id)sender;

@end
