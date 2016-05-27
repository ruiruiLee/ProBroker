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
#import "DictModel.h"

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
    self.selectRelationTypeIdx = [self getSelectIndexWithRelationValue:model.relationType];
    self.sex = model.insuredSex;
    [self isModify];
}

- (void) handleRightBarButtonClicked:(id)sender
{
    [self resignFirstResponder];
    
    [self submitWithInsuredId:self.insuredModel.insuredId];
}

- (BOOL) isModify
{
    NSString *name = self.tfName.text;
    NSString *cert = self.tfCert.text;
    NSString *mobile = self.tfMobile.text;
    NSString *email = self.tfEmail.text;
    
    if(self.selectRelationTypeIdx < 0 && self.insuredModel.relationType){
        self.selectRelationTypeIdx = [self getSelectIndexWithRelationValue:self.insuredModel.relationType];
    }
    
    BOOL back = NO;
    
    if( [name length] > 0 && ![name isEqualToString:self.insuredModel.insuredName]){
        back = YES;
    }
    
    if( [cert length] > 0 && ![cert isEqualToString:self.insuredModel.cardNumber]){
        back = YES;
    }
    
    if([cert length] == 0 && (self.insuredModel.cardNumber != nil && [self.insuredModel.cardNumber length] > 0))
        back = YES;
    
    //电话
    if( [mobile length] > 0 && ![mobile isEqualToString:self.insuredModel.insuredPhone]){
        back = YES;
    }
    
    if([mobile length] == 0 && (self.insuredModel.insuredPhone != nil && [self.insuredModel.insuredPhone length] > 0))
        back = YES;
    
    //邮件
    if([email length] > 0 && ![email isEqualToString:self.insuredModel.insuredEmail]){
        back = YES;
    }
    
    if([email length] == 0 && (self.insuredModel.insuredEmail != nil && [self.insuredModel.insuredEmail length] > 0))
        back = YES;
    
    if(self.sex != self.insuredModel.insuredSex){
        back = YES;
    }
    
    if(self.insuredModel.relationType){
        if(self.selectRelationTypeIdx >= 0 ){
            NSString *relation = ((DictModel *)[self.relatrionArray objectAtIndex:self.selectRelationTypeIdx]).dictValue;
            if(![relation isEqualToString:self.insuredModel.relationType])
                back = YES;
        }
    }else{
        if(self.selectRelationTypeIdx >= 0 )
            back = YES;
    }
    
    if(back){
        [self SetRightBarButtonWithTitle:@"保存" color:_COLORa(0xff, 0x66, 0x19, 1) action:YES];
    }else{
        [self SetRightBarButtonWithTitle:@"保存" color:_COLORa(0xff, 0x66, 0x19, 0.5) action:NO];
    }
    
    return back;
}

- (IBAction)doBtnSelectRelation:(UIButton *)sender
{
    [self resignFirstResponder];
    
    if (!self.menuView) {
        NSArray *titles = @[];
        self.menuView = [[MenuViewController alloc]initWithTitles:titles];
        self.menuView.menuDelegate = self;
    }
    
    if(self.selectRelationTypeIdx < 0 && self.insuredModel.relationType){
        self.selectRelationTypeIdx = [self getSelectIndexWithRelationValue:self.insuredModel.relationType];
    }

    self.menuView.selectIdx = self.selectRelationTypeIdx;
    self.menuView.titleArray = self.relatrionArray;
    self.menuView.tag = 101;
    self.menuView.title = @"与投保人关系";
    
    [self.menuView show:self.view];
    
}

@end