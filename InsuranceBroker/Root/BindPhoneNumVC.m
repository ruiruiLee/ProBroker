//
//  BindPhoneNumVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/28.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BindPhoneNumVC.h"
#import "define.h"
#import "NetWorkHandler+login.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>


@interface BindPhoneNumVC ()

@end

@implementation BindPhoneNumVC

- (void)dealloc
{
    [_timerOutTimer invalidate];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
//        [self setLeftBarButtonWithImage:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"修改绑定手机号";
    [self setLeftBarButtonWithNil];
    
    self.btnGetCaptcha.layer.cornerRadius = 5;
    [self.btnGetCaptcha addTarget:self action:@selector(btnGainVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    self.btnSubmit.layer.cornerRadius = 5;
    [self.btnSubmit addTarget:self action:@selector(btnLoginUseVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    
    self.viewHConstraint.constant = ScreenWidth;
    
    self.tfCaptcha.placeholder = @"请输入验证码";
    self.tfMobile.placeholder = @"请输入手机号";
    self.tfCaptcha.keyboardType = UIKeyboardTypeNumberPad;
    self.tfMobile.keyboardType = UIKeyboardTypeNumberPad;
    self.tfMobile.delegate = self;
    self.tfCaptcha.delegate = self;
    
    self.btnGetCaptcha.enabled = NO;
    self.btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
    self.btnSubmit.enabled = NO;
    self.btnSubmit.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.tfMobile resignFirstResponder];
    [self.tfCaptcha resignFirstResponder];
}

#pragma UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _tfMobile) {
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
//            self.btnSubmit.enabled = YES;
//            self.btnSubmit.backgroundColor = _COLORa(0xff, 0x66, 0x19, 1);
        }else{
            
            self.btnGetCaptcha.enabled = NO;
            self.btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
//            self.btnSubmit.enabled = NO;
//            self.btnSubmit.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
        }
    }else{
        NSString *text = nil;
        NSString *textfront = nil;
        NSString *textend=nil;
        if (string.length > 0) {
            textfront = [textField.text substringToIndex:range.location];
            textend=[textField.text substringFromIndex:range.location];
            text = [NSString stringWithFormat:@"%@%@%@",textfront,string,textend];
            
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        
        if ([text length] == 6) {
            self.btnSubmit.enabled = YES;
            self.btnSubmit.backgroundColor = _COLORa(0xff, 0x66, 0x19, 1);
        }else{
            self.btnSubmit.enabled = NO;
            self.btnSubmit.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
        }
    }
    return YES;
    
}

#pragma action

- (void) btnGainVerifyCode:(id)sender
{
    [_tfMobile resignFirstResponder];
    [_tfCaptcha resignFirstResponder];
    _btnGetCaptcha.enabled = NO;
    _btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
    NSString *phone = _tfMobile.text;
    [AVOSCloud requestSmsCodeWithPhoneNumber:phone callback:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self timerOutTimer];
            [KGStatusBar showSuccessWithStatus:@"验证码已发送!"];
        }else{
            if([error localizedDescription].length>0)
               [KGStatusBar showErrorWithStatus:[error localizedDescription]];
            [_btnGetCaptcha setTitle:@"重取验证码" forState:UIControlStateNormal];
            _btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 1);
            _btnGetCaptcha.enabled = YES;
        }
    }];
}

- (void) btnLoginUseVerifyCode:(id)sender
{
    [_tfMobile resignFirstResponder];
    [_tfCaptcha resignFirstResponder];
    
    NSString *verifyCode = _tfCaptcha.text;
    NSString *phone = _tfMobile.text;
    [ProgressHUD show:@"登陆中..."];
    [self loginWithDictionary:self.wxDic phone:phone smCode:verifyCode];
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
    [_btnGetCaptcha setTitle:[NSString stringWithFormat:@"%d秒", _count] forState:UIControlStateNormal];
    if(_count == 0){
        [_timerOutTimer invalidate];
        [_btnGetCaptcha setTitle:@"重取验证码" forState:UIControlStateNormal];
        _btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 1);
        _btnGetCaptcha.enabled = YES;
        _tfCaptcha.text = @"";
    }
}


-(void) doBtnAgreementClicked:(UIButton *)sender
{
//    NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, Service_Methord, Care_Agreement];
//    WebViewController *vc = [[WebViewController alloc] initWithTitle:@"用户协议" url:url];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void) loginWithDictionary:(NSDictionary *)dic phone:(NSString *) phone smCode:(NSString *)smCode
{
    [NetWorkHandler loginWithPhone:phone openId:[dic objectForKey:@"openid"] sex:[[dic objectForKey:@"sex"] integerValue] nickname:[dic objectForKey:@"nickname"] privilege:[dic objectForKey:@"privilege"] unionid:[dic objectForKey:@"unionid"] province:[dic objectForKey:@"province"] language:[dic objectForKey:@"language"] headimgurl:[dic objectForKey:@"headimgurl"] city:[dic objectForKey:@"city"] country:[dic objectForKey:@"country"] smCode:smCode Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 505){
            BindPhoneNumVC *vc = [IBUIFactory CreateBindPhoneNumViewController];
            [self.navigationController pushViewController:vc animated:YES];
            vc.wxDic = dic;
        }else if (code == 200){
            NSDictionary *data = [content objectForKey:@"data"];
            UserInfoModel *userinfo = [UserInfoModel shareUserInfoModel];
            userinfo.isLogin = YES;
            [userinfo setContentWithDictionary:data];
            [userinfo queryUserInfo];
            [self handleLeftBarButtonClicked:nil];
            
            AVInstallation *currentInstallation = [AVInstallation currentInstallation];
            [currentInstallation addUniqueObject:@"ykbbrokerLoginUser4" forKey:@"channels"];
            [currentInstallation addUniqueObject:[UserInfoModel shareUserInfoModel].userId forKey:@"channels"];
            [currentInstallation saveInBackground];
        }
    }];
}

- (void) handleLeftBarButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
//    NSArray *vcarray = self.navigationController.viewControllers;
//    UIViewController *vc = nil;
//    for (int i = 0; i < [vcarray count]; i++) {
//        UIViewController *temp = [vcarray objectAtIndex:i];
//        if([temp isKindOfClass:[WXLoginVC class]]){
//            vc = temp;
//            break;
//        }
//    }
//    
//    [self.navigationController dismissViewControllerAnimated:vc completion:nil];
}

@end
