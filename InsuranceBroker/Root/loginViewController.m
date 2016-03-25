//
//  loginViewController.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/26.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "loginViewController.h"
#import "define.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>
#import "NetWorkHandler+login.h"
#import "SetTeamLeaderPhoneView.h"
#import "IQKeyboardManager.h"

#define SETTING @"请联系您的团长设置您的佣金!"


@interface loginViewController ()<SetTeamLeaderPhoneViewDelegate>


@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"快速登录";
    [self setLeftBarButtonWithNil];
//    [self setBackBarButton];
    [self setRightBarButtonWithImage:ThemeImage(@"call_login_page")];
    self.lbAgreement.attributedText = [Util getAttributeString:@"点击“登录”，即表示您同意用户协议" substr:@"用户协议"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleLeftBarButtonClicked:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) handleRightBarButtonClicked:(id)sender
{
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",ServicePhone]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}

- (void) loginWithDictionary:(NSDictionary *)pramas
{
    
}


- (void) loginWithDictionary:(NSDictionary *)dic phone:(NSString *) phone smCode:(NSString *)smCode
{
    [NetWorkHandler loginWithPhone:phone openId:[dic objectForKey:@"openid"] sex:[[dic objectForKey:@"sex"] integerValue] nickname:[dic objectForKey:@"nickname"] privilege:[dic objectForKey:@"privilege"] unionid:@"" province:[dic objectForKey:@"province"] language:[dic objectForKey:@"language"] headimgurl:[dic objectForKey:@"headimgurl"] city:[dic objectForKey:@"city"] country:[dic objectForKey:@"country"] smCode:smCode Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 505){
//            BindPhoneNumVC *vc = [IBUIFactory CreateBindPhoneNumViewController];
//            [self.navigationController pushViewController:vc animated:YES];
//            vc.wxDic = dic;
            SetTeamLeaderPhoneView *view = [[SetTeamLeaderPhoneView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            view.delegate = self;
            view.tfNickname.text = [dic objectForKey:@"nickname"];
            [[UIApplication sharedApplication].keyWindow addSubview:view];
            
        }else if (code == 200){
            NSDictionary *data = [content objectForKey:@"data"];
            UserInfoModel *userinfo = [UserInfoModel shareUserInfoModel];
            userinfo.isLogin = YES;
            [userinfo setContentWithDictionary:data];
            [userinfo queryUserInfo];
            [self handleLeftBarButtonClicked:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Login object:nil];
            
            AVInstallation *currentInstallation = [AVInstallation currentInstallation];
            [currentInstallation addUniqueObject:@"ykbbrokerLoginUser4" forKey:@"channels"];
            [currentInstallation addUniqueObject:[UserInfoModel shareUserInfoModel].userId forKey:@"channels"];
            [currentInstallation saveInBackground];
            
//            [KGStatusBar showSuccessWithStatus:SETTING];
        }
    }];
}

#pragma action

- (void) btnGainVerifyCode:(id)sender
{
    [self.tfMobile resignFirstResponder];
    [self.tfCaptcha resignFirstResponder];
    self.btnGetCaptcha.enabled = NO;
    self.btnGetCaptcha.backgroundColor = _COLORa(0xff, 0x66, 0x19, 0.5);
    NSString *phone = self.tfMobile.text;
    [AVOSCloud requestSmsCodeWithPhoneNumber:phone callback:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self timerOutTimer];
//            [Util showAlertMessage:@"验证码已发送!" ];
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

- (IBAction)doBtnAgreementInfo:(id)sender
{
    WebViewController *web = [IBUIFactory CreateWebViewController];
    web.title = @"用户协议";
    [self.navigationController pushViewController:web animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", User_Agreement];
    [web loadHtmlFromUrl:url];
}

- (void) NotifyToSetTeamLeaderPhone:(NSString*) phoneNum remarkName:(NSString *)remarkName
{
    NSDictionary *dic = self.wxDic;
    [NetWorkHandler loginWithPhone:self.tfMobile.text openId:[dic objectForKey:@"openid"] sex:[[dic objectForKey:@"sex"] integerValue] nickname:remarkName privilege:[dic objectForKey:@"privilege"] unionid:[dic objectForKey:@"unionid"] province:[dic objectForKey:@"province"] language:[dic objectForKey:@"language"] headimgurl:[dic objectForKey:@"headimgurl"] city:[dic objectForKey:@"city"] country:[dic objectForKey:@"country"] smCode:nil parentPhone:(NSString *)phoneNum Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 505){
            //            BindPhoneNumVC *vc = [IBUIFactory CreateBindPhoneNumViewController];
            //            [self.navigationController pushViewController:vc animated:YES];
            //            vc.wxDic = dic;
            SetTeamLeaderPhoneView *view = [[SetTeamLeaderPhoneView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            
            view.delegate = self;
            [[UIApplication sharedApplication].keyWindow addSubview:view];
        }else if (code == 200){
            NSDictionary *data = [content objectForKey:@"data"];
            UserInfoModel *userinfo = [UserInfoModel shareUserInfoModel];
            userinfo.isLogin = YES;
            [userinfo setContentWithDictionary:data];
            [userinfo queryUserInfo];
            [self handleLeftBarButtonClicked:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Login object:nil];
            
            AVInstallation *currentInstallation = [AVInstallation currentInstallation];
            [currentInstallation addUniqueObject:@"ykbbrokerLoginUser4" forKey:@"channels"];
            [currentInstallation addUniqueObject:[UserInfoModel shareUserInfoModel].userId forKey:@"channels"];
            [currentInstallation saveInBackground];
            
            [KGStatusBar showSuccessWithStatus:SETTING];
        }
    }];
}

@end
