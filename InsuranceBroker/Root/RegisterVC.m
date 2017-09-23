//
//  RegisterVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/9/13.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "RegisterVC.h"
#import "define.h"
#import "NetWorkHandler+register.h"
#import "NetWorkHandler+SMSRequest.h"
#import "AVOSCloud.h"
#import "NetWorkHandler+newUser.h"

@interface RegisterVC ()

@end

@implementation RegisterVC
@synthesize btnGetCaptcha;
@synthesize btnRegister;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"注册";
    
    self.btnLogin.layer.borderWidth= 1;
    self.btnLogin.layer.borderColor = _COLOR(0x73, 0x73, 0x73).CGColor;
    self.btnLogin.layer.cornerRadius = 6;
    
    self.btnRegister.layer.cornerRadius = 6;
    self.btnRegister.backgroundColor = _COLOR(0xff, 0x66, 0x19);
    
    [self.btnSelect setImage:ThemeImage(@"unselect") forState:UIControlStateNormal];
    [self.btnSelect setImage:ThemeImage(@"select") forState:UIControlStateSelected];
    
    self.btnSelect.selected = YES;
    
    btnGetCaptcha = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    btnGetCaptcha.backgroundColor = _COLOR(0xff, 0x66, 0x19);
    [btnGetCaptcha setTitleColor:_COLOR(0xff, 0xff, 0xff) forState:UIControlStateNormal];
    [btnGetCaptcha setTitle:@"获取验证码" forState:UIControlStateNormal];
    btnGetCaptcha.layer.cornerRadius = 5;
    btnGetCaptcha.titleLabel.font = _FONT(15);
    
    self.tfCaptcha.rightView = btnGetCaptcha;
    self.tfCaptcha.rightViewMode = UITextFieldViewModeAlways;
    [btnGetCaptcha addTarget:self action:@selector(btnGainVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnYonghuxieyi setColor:_COLOR(0xff, 0x66, 0x19)];
    
    btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
    btnGetCaptcha.enabled = NO;
    btnRegister.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
    btnRegister.enabled = NO;
    
    self.tfCaptcha.delegate = self;
    self.tfUserPhone.delegate = self;
    self.tfName.delegate = self;
    self.tfTeamPhone.delegate = self;
    
    [self.tfCaptcha addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tfUserPhone addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tfTeamPhone addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tfName addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)dealloc
{
    [_timerOutTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doBtnAgreementInfo:(id)sender
{
    [self resignFirstResponder];
    
    WebViewController *web = [IBUIFactory CreateWebViewController];
    web.title = @"用户协议";
    [self.navigationController pushViewController:web animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", User_Agreement];
    [web loadHtmlFromUrl:url];
}

- (IBAction)doBtnAllowYonghuxieyi:(id)sender
{
    self.btnSelect.selected = !self.btnSelect.selected;
    if(!self.btnSelect.selected){
        self.btnRegister.userInteractionEnabled = NO;
        self.btnRegister.backgroundColor = _COLOR(0xcc, 0xcc, 0xcc);
    }
    else{
        self.btnRegister.userInteractionEnabled = YES;
        self.btnRegister.backgroundColor = _COLOR(0xff, 0x66, 0x19);
    }
}

- (IBAction)doBtnRegister:(id)sender
{
    if(!self.btnSelect.selected)
        [Util showAlertMessage:@""];
    
    NSString *name = self.tfName.text;
    NSString *teamPhone = self.tfTeamPhone.text;
    NSString *userPhone = self.tfUserPhone.text;
    NSString *captcha = self.tfCaptcha.text;
    
    [ProgressHUD show:@"正在注册"];
    [NetWorkHandler requestToRegister:teamPhone phone:userPhone smsCode:captcha userName:name action:@"register" Completion:^(int code, id content) {
        [ProgressHUD dismiss];
        if(code == 200){
            NSDictionary *data = [content objectForKey:@"data"];
            UserInfoModel *userinfo = [UserInfoModel shareUserInfoModel];
            [userinfo setContentWithDictionary:data];
            [userinfo queryUserInfo];
            [self handleLeftBarButtonClicked:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Login object:nil];
            // 订阅 push 频道
            AVInstallation *currentInstallation = [AVInstallation currentInstallation];
            [currentInstallation addUniqueObject:@"ykbbrokerLoginUser4" forKey:@"channels"];
            [currentInstallation addUniqueObject:[UserInfoModel shareUserInfoModel].userId forKey:@"channels"];
            [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSInteger isRegister = [[[content objectForKey:@"data"] objectForKey:@"isRegister"] integerValue];
                if(isRegister == 1){
                    [NetWorkHandler requestToRequestNewUser:userinfo.userId nickName:nil Completion:^(int code, id content) {
                        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
                    }];
                }
            }];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            [Util showAlertMessage:[content objectForKey:@"msg"]];
        }
    }];
}

- (IBAction)doBtnLogin:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma action

- (void) btnGainVerifyCode:(id)sender
{
    [self resignFirstResponder];
    
    self.btnGetCaptcha.enabled = NO;
    self.btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
    NSString *phone = self.tfUserPhone.text;
    [ProgressHUD show:@"正在获取验证码"];
    [NetWorkHandler requestToShortMsg:phone template:@"ykbConfirm" sign:@"优快保" other:nil Completion:^(int code, id content) {
        [ProgressHUD dismiss];
        if(code == 200){
            [self timerOutTimer];
            [KGStatusBar showSuccessWithStatus:@"验证码已发送,请及时查收！"];
        }else
        {
            [KGStatusBar showErrorWithStatus:[content objectForKey:@"msg"]];
            [self.btnGetCaptcha setTitle:@"重取验证码" forState:UIControlStateNormal];
            self.btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 1);
            self.btnGetCaptcha.enabled = YES;
            
        }
    }];
}

#pragma UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.tfUserPhone) {
        NSString *text = nil;
        NSString *textfront = nil;
        NSString *textend=nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            textfront = [textField.text substringToIndex:range.location];
            textend=[textField.text substringFromIndex:range.location];
            text = [NSString stringWithFormat:@"%@%@%@",textfront,string,textend];
            
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        if ([Util isMobilePhoeNumber:text]) {
            self.btnGetCaptcha.enabled = YES;
            self.btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 1);
        }else{
            
            self.btnGetCaptcha.enabled = NO;
            self.btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
        }
    }


    return YES;
}

-(void)passConTextChange:(id)sender{
    if([self isPramaFull]){
        self.btnRegister.enabled = YES;
        self.btnRegister.backgroundColor = _COLORa(0xff, 0x66, 0x19, 1);
    }else{
        self.btnRegister.enabled = NO;
        self.btnRegister.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
    }
}

- (BOOL) isPramaFull
{
    BOOL result = YES;
    NSString *name = self.tfName.text;
    if([name length] == 0)
        result = NO;
    NSString *teamPhone = self.tfTeamPhone.text;
    if(![Util isMobileNumber:teamPhone])
        result = NO;
    NSString *userPhone = self.tfUserPhone.text;
    if(![Util isMobileNumber:userPhone])
        result = NO;
    NSString *captcha = self.tfCaptcha.text;
    if ([captcha length] != 6)
        result = NO;
    
    return result;
}

#pragma timer
- (void)timerOutTimer
{
    [_timerOutTimer invalidate];
    _count = 60;
    _timerOutTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerObserver) userInfo:nil repeats:YES];
}

- (void)timerObserver
{
    _count --;
    NSString *str = [[NSNumber numberWithInteger:_count] stringValue];
    self.btnGetCaptcha.enabled = YES;
    [self.btnGetCaptcha setTitle:str forState:UIControlStateNormal];
    self.btnGetCaptcha.enabled = NO;
    
    if(_count == 0){
        [_timerOutTimer invalidate];
        [self.btnGetCaptcha setTitle:@"重取验证码" forState:UIControlStateNormal];
        self.btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 1);
        self.btnGetCaptcha.enabled = YES;
        self.tfCaptcha.text = @"";
    }
}

@end
