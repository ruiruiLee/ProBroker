//
//  EditInsuredUserInfoVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "EditInsuredUserInfoVC.h"
#import "NetWorkHandler+queryCustomerInsuredInfo.h"
#import "define.h"

@implementation EditInsuredUserInfoVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self updateDataWithModel:self.insuredModel];
    [self loadUserInfo:self.insuredModel.insuredId];
}

- (void) loadUserInfo:(NSString *) insuredId
{
    [ProgressHUD show:nil];
    [NetWorkHandler requestToQueryCustomerInsuredInfoInsuredId:insuredId Completion:^(int code, id content) {
        [ProgressHUD dismiss];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            if(!self.insuredModel)
                self.insuredModel = [[InsuredUserInfoModel alloc] init];
            [self.insuredModel updateModelWithDictionary:[content objectForKey:@"data"]];
            [self updateDataWithModel:self.insuredModel];
        }
    }];
}

- (void) updateDataWithModel:(InsuredUserInfoModel *) model
{
    self.tfCert.text = model.cardNumber;
    self.tfEmail.text = model.insuredEmail;
    self.tfMobile.text = model.insuredPhone;
    self.tfName.text = model.insuredName;
    self.tfRelation.text = model.relationTypeName;
    self.tfSex.text = [Util getSexStringWithSex:model.insuredSex];
}

@end
