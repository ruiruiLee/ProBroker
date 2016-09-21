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
#import "AVOSCloud/AVOSCloud.h"
//#import <AVOSCloudSNS/AVOSCloudSNS.h>


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
    
    [self.btnGetCaptcha setTitle:@"获取验证码" forState:UIControlStateNormal];
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
    [self.tfMobile resignFirstResponder];
    [self.tfCaptcha resignFirstResponder];
    self.btnGetCaptcha.enabled = NO;
    self.btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
    NSString *phone = _tfMobile.text;
    [AVOSCloud requestSmsCodeWithPhoneNumber:phone callback:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self timerOutTimer];
            [KGStatusBar showSuccessWithStatus:@"验证码已发送!"];
        }else{
            if([error localizedDescription].length>0)
               [KGStatusBar showErrorWithStatus:[error localizedDescription]];
            [self.btnGetCaptcha setTitle:@"重取验证码" forState:UIControlStateNormal];
            self.btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 1);
            self.btnGetCaptcha.enabled = YES;
        }
    }];
}

- (void) btnLoginUseVerifyCode:(id)sender
{
    [self.tfMobile resignFirstResponder];
    [self.tfCaptcha resignFirstResponder];
    
    NSString *verifyCode = self.tfCaptcha.text;
    NSString *phone = self.tfMobile.text;
    [ProgressHUD show:nil];
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


-(void) doBtnAgreementClicked:(UIButton *)sender
{

}

- (void) loginWithDictionary:(NSDictionary *)dic phone:(NSString *) phone smCode:(NSString *)smCode
{
}

- (void) handleLeftBarButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
