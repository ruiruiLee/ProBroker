//
//  AutoInsuranceStep1VC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "HighNightBgButton.h"

@interface AutoInsuranceStep1VC : BaseViewController

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *viewWidth;
@property (nonatomic, strong) IBOutlet UITextField *tfCardNum;
@property (nonatomic, strong) IBOutlet UITextField *tfName;
@property (nonatomic, strong) IBOutlet UITextField *tfCert;
@property (nonatomic, strong) IBOutlet UIButton *btnCertImage;
@property (nonatomic, strong) IBOutlet UIButton *btnSubmit;
@property (nonatomic, strong) IBOutlet UISwitch *switchCert;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bannerHeight;

@property (nonatomic, strong) HighNightBgButton *btnProvience;//省简称
@property (nonatomic, strong) UILabel *lbProvience;

@end
