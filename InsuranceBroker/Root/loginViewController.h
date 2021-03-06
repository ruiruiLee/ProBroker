//
//  loginViewController.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/26.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "LeftImgButton.h"
#import "BindPhoneNumVC.h"
#import "HyperlinksButton.h"

@interface loginViewController : BindPhoneNumVC

@property (nonatomic, strong) IBOutlet UILabel *lbAgreement;
@property (nonatomic, strong) IBOutlet UILabel *lbShow;
@property (nonatomic, strong) IBOutlet UILabel *lbSepLine;
@property (nonatomic, strong) IBOutlet UILabel *lbInfoTips;
@property (nonatomic, strong) IBOutlet HyperlinksButton *btnRegister;

@end
