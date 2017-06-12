//
//  AutoInsuranceStep1VC.h
//  InsuranceBroker
//  快速报价
//  Created by LiuZach on 16/8/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "HighNightBgButton.h"

@class productAttrModel;

@interface AutoInsuranceStep1VC : BaseViewController
{
    NSInteger _perInsurCompany;
}

@property (nonatomic, strong) IBOutlet UITextField *tfCardNum;
@property (nonatomic, strong) IBOutlet UIButton *btnSubmit;
@property (nonatomic, strong) IBOutlet UILabel *lbWarning;

@property (nonatomic, strong) IBOutlet UIView *bgView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bgViewWidth;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bgViewHeight;

@property (nonatomic, strong) HighNightBgButton *btnProvience;//省简称
@property (nonatomic, strong) UILabel *lbProvience;

@property (nonatomic, strong) productAttrModel *selectProModel;//选中的产品

@property (nonatomic, strong) IBOutlet UIImageView *img_RB;
@property (nonatomic, strong) IBOutlet UIImageView *img_PA;
@property (nonatomic, strong) IBOutlet UIImageView *img_TP;
@property (nonatomic, strong) IBOutlet UIImageView *img_RS;
@property (nonatomic, strong) IBOutlet UIImageView *img_DD;

@end
