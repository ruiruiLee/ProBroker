//
//  AutoInsuranceStep1VC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "HighNightBgButton.h"
#import "InsurCompanySelectVC.h"

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

@property (nonatomic, strong) InsurCompanySelectVC *menuView;

@end
