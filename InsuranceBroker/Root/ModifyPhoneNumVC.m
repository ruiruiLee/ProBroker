//
//  ModifyPhoneNumVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ModifyPhoneNumVC.h"
#import "NetWorkHandler+modifyUserInfo.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>
#import "define.h"

@implementation ModifyPhoneNumVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self setBackBarButton];
    
    [self.btnGetCaptcha setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (BOOL) resignFirstResponder
{
    [self.tfMobile resignFirstResponder];
    [self.tfCaptcha resignFirstResponder];
    return [super resignFirstResponder];
}

- (void) handleLeftBarButtonClicked:(id)sender
{
    [self resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loginWithDictionary:(NSDictionary *)dic phone:(NSString *) phone smCode:(NSString *)smCode
{
    [self resignFirstResponder];

    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    [AVOSCloud verifySmsCode:smCode mobilePhoneNumber:phone callback:^(BOOL succeeded, NSError *error) {
        if(error == nil){
            [NetWorkHandler requestToModifyuserInfo:user.userId realName:nil userName:nil phone:phone cardNumber:nil cardNumberImg1:nil cardNumberImg2:nil liveProvinceId:nil liveCityId:nil liveAreaId:nil liveAddr:nil userSex:nil headerImg:nil Completion:^(int code, id content) {
                 [ProgressHUD dismiss];
                  if(code == 200){
                    user.phone = phone;
                    [self.navigationController popViewControllerAnimated:YES];
                  }else{
                      [Util showAlertMessage:@"重新绑定号码失败！" ];
                  }
            }];
        }
        else{
             [ProgressHUD dismiss];
            long code = [[error.userInfo objectForKey:@"code"] longValue];
            if(code == 603){
                 [Util showAlertMessage:@"无效的验证码！" ];
            }else
                [Util showAlertMessage:@"网络连接异常，请检查网络设置！" ];
        }
    }];
}



- (void) btnGainVerifyCode:(id)sender
{
    [self resignFirstResponder];

    self.btnGetCaptcha.enabled = NO;
    self.btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
    NSString *phone = self.tfMobile.text;

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

@end
