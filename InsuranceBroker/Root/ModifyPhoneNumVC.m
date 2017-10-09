//
//  ModifyPhoneNumVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ModifyPhoneNumVC.h"
#import "NetWorkHandler+modifyUserInfo.h"
#import "AVOSCloud.h"
//#import <AVOSCloudSNS/AVOSCloudSNS.h>
#import "define.h"

#import "NetWorkHandler+SMSRequest.h"
#import "NetWorkHandler+VerifySMSCode.h"

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
    [ProgressHUD show:@"正在证码"];
    [NetWorkHandler requestToVerifySMSCode:phone smsCode:smCode Completion:^(int code, id content) {
        if(code == 200){
            [NetWorkHandler requestToModifySaveUser:user.userId realName:nil userName:nil phone:phone cardNumber:nil cardNumberImg1:nil cardNumberImg2:nil liveProvinceId:nil liveCityId:nil liveAreaId:nil liveAddr:nil userSex:nil headerImg:nil cardVerifiy:nil Completion:^(int code, id content) {
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
            [Util showAlertMessage:[content objectForKey:@"msg"]];
//            if(code == 603){
//                [Util showAlertMessage:@"无效的验证码！" ];
//            }else
//                [Util showAlertMessage:@"网络连接异常，请检查网络设置！" ];
        }
    }];
//    [AVOSCloud verifySmsCode:smCode mobilePhoneNumber:phone callback:^(BOOL succeeded, NSError *error) {
//        if(error == nil){
//            [NetWorkHandler requestToModifyuserInfo:user.userId realName:nil userName:nil phone:phone cardNumber:nil cardNumberImg1:nil cardNumberImg2:nil liveProvinceId:nil liveCityId:nil liveAreaId:nil liveAddr:nil userSex:nil headerImg:nil Completion:^(int code, id content) {
//                 [ProgressHUD dismiss];
//                  if(code == 200){
//                    user.phone = phone;
//                    [self.navigationController popViewControllerAnimated:YES];
//                  }else{
//                      [Util showAlertMessage:@"重新绑定号码失败！" ];
//                  }
//            }];
//        }
//        else{
//             [ProgressHUD dismiss];
//            long code = [[error.userInfo objectForKey:@"code"] longValue];
//            if(code == 603){
//                 [Util showAlertMessage:@"无效的验证码！" ];
//            }else
//                [Util showAlertMessage:@"网络连接异常，请检查网络设置！" ];
//        }
//    }];
}



- (void) btnGainVerifyCode:(id)sender
{
    [self resignFirstResponder];

    self.btnGetCaptcha.enabled = NO;
    self.btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
    NSString *phone = self.tfMobile.text;

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
    
//    [AVOSCloud requestSmsCodeWithPhoneNumber:phone callback:^(BOOL succeeded, NSError *error) {
//        if(succeeded){
//            [self timerOutTimer];
//            [KGStatusBar showSuccessWithStatus:@"验证码已发送!"];
//        }else{
//         if([error localizedDescription].length>0)
//            [KGStatusBar showErrorWithStatus:[error localizedDescription]];
//            [self.btnGetCaptcha setTitle:@"重取验证码" forState:UIControlStateNormal];
//            self.btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 1);
//            self.btnGetCaptcha.enabled = YES;
//        }
//    }];
}

@end
