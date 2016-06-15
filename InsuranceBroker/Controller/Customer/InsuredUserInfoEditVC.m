//
//  InsuredUserInfoEditVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/17.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "InsuredUserInfoEditVC.h"
#import "define.h"
#import "NetWorkHandler+saveOrUpdateCustomerVisits.h"
#import "NetWorkHandler+saveOrUpdateCustomerInsured.h"
#import "DictModel.h"

@implementation InsuredUserInfoEditVC

- (void) handleLeftBarButtonClicked:(id)sender
{
    [self resignFirstResponder];
    
    BOOL flag = [self isModify];
    if(flag){
        if([self getIOSVersion] < 8.0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确认放弃保存填写资料吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alert show];
        }
        else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"确认放弃保存填写资料吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.tfMobile addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [self.tfCert addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [self.tfEmail addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [self.tfName addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    if(self.customerDetail){
        if(self.customerDetail.customerPhone)
            self.tfMobile.text = self.customerDetail.customerPhone;
        if(self.customerDetail.customerEmail)
            self.tfEmail.text = self.customerDetail.customerEmail;
    }
    
    self.viewHConstraint.constant = ScreenWidth;
    
    _selectRelationTypeIdx = -1;
    
    [self loadVisitDictionary];
    
    [self isModify];
}

- (void) loadVisitDictionary
{
    [ProgressHUD show:nil];
    NSString *method = @"/web/common/getDicts.xhtml?dictType=customerRelationType&limitVal=1";
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    __weak InsuredUserInfoEditVC *weakself = self;
    [handle getWithMethod:method BaseUrl:Base_Uri Params:nil Completion:^(int code, id content) {
        [ProgressHUD dismiss];
        [weakself handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            NSArray *array = [DictModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]];
            self.relatrionArray = array;
        }
    }];
}

- (void) handleRightBarButtonClicked:(id)sender
{
    [self resignFirstResponder];
    
    [self submitWithInsuredId:nil];
}

- (void) submitWithInsuredId:(NSString *) insuredId
{
    [self isModify];
    
    NSString *name = self.tfName.text;
    NSString *cert = self.tfCert.text;
    NSString *mobile = self.tfMobile.text;
    NSString *email = self.tfEmail.text;
    NSString *relationType = nil;
    if(self.selectRelationTypeIdx >= 0){
        DictModel *model = [self.relatrionArray objectAtIndex:self.selectRelationTypeIdx];
        relationType = model.dictValue;
    }
    
    if( [name length] == 0){
        [Util showAlertMessage:@"被保人姓名不能为空！"];
        return;
    }
    
    mobile = [self formatPhoneNum:mobile];
    if([mobile length] > 0){
        if(![Util isMobilePhoeNumber:mobile] && ![Util checkPhoneNumInput:mobile]){
            [Util showAlertMessage:@"客户联系电话不正确"];
            return;
        }
    }
    
    if([email length] > 0 && ![Util validateEmail:email]){
        [Util showAlertMessage:@"电子邮箱不正确"];
        return;
    }
    
    BOOL flag = [Util validateIdentityCard:cert];
    
    if([cert length] > 0 && !flag){
        [Util showAlertMessage:@"身份证号输入不正确"];
        return;
    }
    
    if(relationType == nil){
        [Util showAlertMessage:@"请选择被保人和投保人关系"];
        return;
    }
    
    [NetWorkHandler requestToSaveOrUpdateCustomerInsuredCardNumber:cert
                                                        customerId:self.customerId
                                                      insuredEmail:email
                                                         insuredId:insuredId
                                                       insuredMemo:nil
                                                       insuredName:name
                                                      insuredPhone:mobile
                                                        insuredSex:self.sex
                                                     insuredStatus:1
                                                          liveAddr:nil
                                                        liveAreaId:nil
                                                        liveCityId:nil
                                                    liveProvinceId:nil
                                                      relationType:relationType
                                                        Completion:^(int code, id content) {
                                                            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
                                                            if(code == 200){
                                                                [self.navigationController popViewControllerAnimated:YES];
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Refresh_Insured_list object:nil userInfo:nil];
                                                            }
                                                        }];
}

- (BOOL) resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    [self.tfCert resignFirstResponder];
    [self.tfEmail resignFirstResponder];
    [self.tfMobile resignFirstResponder];
    [self.tfName resignFirstResponder];
    [self.tfRelation resignFirstResponder];
    [self.tfSex resignFirstResponder];
    
    return result;
}

- (IBAction)doBtnSelectSex:(id)sender
{
    [self resignFirstResponder];
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
    [action showInView:self.view];
    action.tag = 1000;
}

- (IBAction)doBtnSelectRelation:(UIButton *)sender
{
    [self resignFirstResponder];
    
    if (!_menuView) {
        NSArray *titles = @[];
        _menuView = [[MenuViewController alloc]initWithTitles:titles];
        _menuView.menuDelegate = self;
        
    }

    _menuView.selectIdx = _selectRelationTypeIdx;
    _menuView.titleArray = self.relatrionArray;
    _menuView.tag = 101;
    _menuView.title = @"与投保人关系";

    [_menuView show:self.view];

}

-(void)menuViewController:(MenuViewController *)menu AtIndex:(NSUInteger)index
{
    [menu hide];
    _selectRelationTypeIdx = index;
    DictModel *model = [self.relatrionArray objectAtIndex:index];
    self.tfRelation.text = model.dictName;

    [self isModify];
}

-(void)menuViewControllerDidCancel:(MenuViewController *)menu
{
    [menu hide];
    [self isModify];
}

#pragma mark- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(actionSheet.tag == 1000){
        if(buttonIndex == 0){
            self.tfSex.text = @"男";
            _sex = 1;
        }
        else if (buttonIndex == 1){
            self.tfSex.text = @"女";
            _sex = 2;
        }else
            _sex = 0;
    }
    
    [self isModify];
}

- (BOOL) isModify
{
    NSString *name = self.tfName.text;
    NSString *cert = self.tfCert.text;
    NSString *mobile = self.tfMobile.text;
    NSString *email = self.tfEmail.text;
    
    BOOL back = NO;
    
    if( [name length] > 0 ){
        back = YES;
    }
    
    if( [cert length] > 0 ){
        back = YES;
    }
    
    //电话
    if( [mobile length] > 0 && ![mobile isEqualToString:self.customerDetail.customerPhone]){
        back = YES;
    }
    
    //邮件
    if([email length] > 0 && ![email isEqualToString:self.customerDetail.customerEmail] ){
        back = YES;
    }
    
    if(self.sex != 0){
        back = YES;
    }
    
    if(self.selectRelationTypeIdx >= 0){
        back = YES;
    }

    if(back){
        [self SetRightBarButtonWithTitle:@"保存" color:_COLORa(0xff, 0x66, 0x19, 1) action:YES];
    }else{
        [self SetRightBarButtonWithTitle:@"保存" color:_COLORa(0xff, 0x66, 0x19, 0.5) action:NO];
    }
    
    return back;
}

- (void) textChangeAction:(id) sender {
    [self isModify];
}

- (NSString *) formatPhoneNum:(NSString *) phoneNum
{
    NSString *mobile = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobile = [Util formatPhoneNum:mobile];
    
    return mobile;
}

- (NSInteger) getSelectIndexWithRelationValue:(NSString *) value
{
    if(value == nil)
        return -1;
    else{
        for (int i = 0; i < [self.relatrionArray count]; i++) {
            DictModel *model = [self.relatrionArray objectAtIndex:i];
            if([model.dictValue isEqualToString:value])
                return i;
        }
        
        return -2;
    }
    return -1;
}

@end
