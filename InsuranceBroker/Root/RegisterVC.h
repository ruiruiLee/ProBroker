//
//  RegisterVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/9/13.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "HyperlinksButton.h"

@interface RegisterVC : BaseViewController <UITextFieldDelegate>
{
    NSTimer *_timerOutTimer;
    NSInteger _count;
}

@property (nonatomic, strong) IBOutlet UITextField *tfTeamPhone;
@property (nonatomic, strong) IBOutlet UITextField *tfUserPhone;
@property (nonatomic, strong) IBOutlet UITextField *tfName;
@property (nonatomic, strong) IBOutlet UITextField *tfCaptcha;
//@property (nonatomic, strong) IBOutlet NSLayoutConstraint *teamPhoneHConstraint;
@property (nonatomic, strong) IBOutlet UIButton *btnRegister;
@property (nonatomic, strong) IBOutlet UIButton *btnLogin;
@property (nonatomic, strong) IBOutlet UIButton *btnSelect;
@property (nonatomic, strong) IBOutlet HyperlinksButton *btnYonghuxieyi;
@property (nonatomic, strong) IBOutlet UIButton *btnGetCaptcha;


@end
