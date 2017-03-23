//
//  AutoInsuranceInfoEditVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/26.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "AutoInsuranceInfoEditVC.h"
#import "define.h"
#import "NetWorkHandler+saveOrUpdateCustomerCar.h"
#import "AVOSCloud/AVOSCloud.h"
#import "NetWorkHandler+queryForInsuranceCompanyList.h"
#import "NetWorkHandler+queryForCustomerCarInfo.h"
#import "InsuranceCompanyModel.h"
#import "CarAddInfoTableCell.h"
#import "ZHPickView.h"
#import "DictModel.h"
#import "UIImageView+WebCache.h"
#import "SJAvatarBrowser.h"
#import "ProgressHUD.h"
#import "UIButton+WebCache.h"
#import "NetWorkHandler+saveOrUpdateCustomer.h"
#import "NetWorkHandler+queryForProductList.h"
#import "ProvienceSelectedView.h"

@interface AutoInsuranceInfoEditVC ()

@end

@implementation AutoInsuranceInfoEditVC
@synthesize btnQuote;
@synthesize lbProvience;

- (void) fillTheData
{
    CarInfoModel *model = self.carInfo;
    
    _travelCard1 = model.travelCard1;
    
//    if(![Util validateCarNo:self.customerModel.customerName])
//        self.tfName.text = self.customerModel.customerName;
    if(model){
        if(model.carOwnerName != nil && ![model.carOwnerName isKindOfClass:[NSNull class]] && [model.carOwnerName length] > 0)
            self.tfName.text = model.carOwnerName;
        self.tfNo.text = [self getCarCertNum:model.carNo];
        self.lbProvience.text = [self getCarCertLocation:model.carNo];
        if(model.newCarNoStatus == 0){
            self.btnNoNo.selected = YES;
            self.tfNo.enabled = NO;
            self.lbDateTitle.text = @"购车日期";
            self.tfDate.placeholder = @"请选择购车日期";
            self.lbCertTitle.text = @"购车发票信息";
            [self.btnReSubmit setBackgroundImage:ThemeImage(@"fapiao") forState:UIControlStateNormal];
            newLisence = nil;
            self.btnReSubmit.selected = NO;
            self.baseViewVConstraint.constant = 50;
        }else{
            self.btnNoNo.selected = NO;
            self.tfNo.enabled = YES;
            self.lbDateTitle.text = @"注册日期";
            self.tfDate.placeholder = @"请选择注册日期";
            self.lbCertTitle.text = @"行驶证信息";
            [self.btnReSubmit setBackgroundImage:ThemeImage(@"drivingLicenseBg") forState:UIControlStateNormal];
            newLisence = nil;
            self.baseViewVConstraint.constant = 90;
            self.btnReSubmit.selected = NO;
        }
        self.tfMotorCode.text = model.carEngineNo;
        self.tfModel.text = model.carTypeNo;
        self.tfIdenCode.text = model.carShelfNo;
        self.tfDate.text = [Util getDayString:model.carRegTime];
        self.tfCert.text = model.carOwnerCard;
        
        if(model.travelCard1 != nil){
            CGSize size = self.btnReSubmit.frame.size;
            [self.btnReSubmit sd_setBackgroundImageWithURL:[NSURL URLWithString:FormatImage(model.travelCard1, (int)size.width, (int)size.height)] forState:UIControlStateSelected placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
            self.btnReSubmit.selected = YES;
        }else
            self.btnReSubmit.selected = NO;
        
        if(model.travelCard1 == nil && ([Util isNilValue:model.carEngineNo] || [Util isNilValue:model.carTypeNo] || [Util isNilValue:model.carShelfNo] || ![Util isNilOrNull:model.carRegTime])){
            [self performSelector:@selector(scrollToInfo) withObject:nil afterDelay:1];
        }else{
            [self performSelector:@selector(scrollToImage) withObject:nil afterDelay:0.2];
        }
        
        if(model.carOwnerCard1 != nil){
            CGSize size = self.btnCert.frame.size;
            [self.btnCert sd_setBackgroundImageWithURL:[NSURL URLWithString:FormatImage(model.carOwnerCard1, (int)size.width, (int)size.height)] forState:UIControlStateSelected];
            self.btnCert.selected = YES;
        }else{
            self.btnCert.selected = NO;
        }
        
        if(model.carTradeStatus == 0){
            _changNameDate = nil;
            _changeNameIdx = -1;
            self.lbIsTransfer.text = @"否";
        }
        else if (model.carTradeStatus == 1){
            _changNameDate = nil;
            _changeNameIdx = 0;
            self.lbIsTransfer.text = @"否";
        }
        else{
            _changNameDate = model.carTradeTime;
            _changeNameIdx = 1;
            self.lbTransferDate.text = [Util getDayString:_changNameDate];
            self.lbIsTransfer.text = @"是";
        }
        
        if(model.carInsurStatus1 == 1){
            _perInsurCompany = [self getSelectIdxFromArray:model.carInsurCompId1];
            if(_perInsurCompany >= 0){
                self.lbPName.text = ((InsuranceCompanyModel*)[_insurCompanyArray objectAtIndex:_perInsurCompany]).productName;
            }else
            {
                NSInteger i = _perInsurCompany;
                [self cancelSelectPCompany:nil];
                _perInsurCompany = i;
                self.lbPName.text = @"请选择";
            }
        }
        else{
            [self cancelSelectPCompany:nil];
        }
    }
    [self isModify];
}

- (void) scrollToInfo
{
    [self.scrollview scrollRectToVisible:CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollview.frame.size.height) animated:YES];
}

- (void) scrollToImage
{
    [self.scrollview scrollRectToVisible:CGRectMake(0, 0, ScreenWidth, self.scrollview.frame.size.height) animated:YES];
}

- (NSInteger) getSelectIdxFromArray:(NSString *) comapyId
{
    for (int i = 0; i< [_insurCompanyArray count]; i++) {
        InsuranceCompanyModel *model = [_insurCompanyArray objectAtIndex:i];
        if([model.productId isEqualToString:comapyId])
            return i;
    }
    
    return  -1;
}


- (BOOL) isModify
{
    CarInfoModel *model = self.carInfo;
    BOOL result = NO;
    
    result = isCertModify;
    
    NSString *name = self.tfName.text;
    BOOL flag1 = [self checkValueChange:name text:model.carOwnerName];
    if(flag1){
        result = flag1;
    }
    
    NSString *cert = self.tfCert.text;
    BOOL flag = [self checkValueChange:cert text:model.carOwnerCard];
    if(flag)
        result = flag;
    NSString *no = [self getCarCertString];//self.tfNo.text;
    if([no length] == 1 && (model.carNo == nil || [model.carNo length] == 0))
        flag = NO;
    else{
        flag = [self checkValueChange:no text:model.carNo];
        if(flag)
            result = flag;
    }
    
    if(model != nil){
        if(model.newCarNoStatus == self.btnNoNo.selected){
            result = YES;
        }
    }else{
        if(self.btnNoNo.selected)
            result = YES;
    }
    NSString *date = self.tfDate.text;
    flag = [self checkValueChange:date text:[Util getDayString:model.carRegTime]];
    if(flag)
        result = flag;
    NSString *modelStr = self.tfModel.text;
    flag = [self checkValueChange:modelStr text:model.carTypeNo];
    if(flag)
        result = flag;
    NSString *idenCode = self.tfIdenCode.text;
    flag = [self checkValueChange:idenCode text:model.carShelfNo];
    if(flag)
        result = flag;
    NSString *motorCode = self.tfMotorCode.text;
    flag = [self checkValueChange:motorCode text:model.carEngineNo];
    if(flag)
        result = flag;
    
    if(_perInsurCompany >= 0 && _perInsurCompany < [_insurCompanyArray count]){
        if(![model.carInsurCompId1 isEqualToString:((InsuranceCompanyModel*)[_insurCompanyArray objectAtIndex:_perInsurCompany]).productId])
            result = YES;
    }
    else{
        if([self isNilValue:model.carInsurCompId1]){
            result = YES;
        }
    }
    //是否过户
    if( model != nil && (model.carTradeStatus != _changeNameIdx + 1)){
        result = YES;
    }
    
    if(model == nil && !(_changeNameIdx == -1 || _changeNameIdx == 0))
    {
        result = YES;
    }
    //过户日起
    if(model.carTradeTime != nil){
        if(![[Util getDayString:model.carTradeTime] isEqualToString:[Util getDayString:_changNameDate]])
            result = YES;
    }else{
        if(_changNameDate != nil)
            result = YES;
    }
    
    if(result){
        [self setRightBarButtonWithFlag:YES];
    }
    else{
        [self setRightBarButtonWithFlag:NO];
    }
    
    if ([self checkInfoFull]) {
        self.btnQuote.enabled = YES;
    }else{
        self.btnQuote.enabled = NO;
    }
    
    return result;
}


- (void) btnPhotoPressed:(UIButton*)sender{
    [self resignFirstResponder];
    
    UIActionSheet *ac;
    CarInfoModel *model = self.carInfo;
    if(sender == self.btnCert){
        if([Util isNilValue:model.carOwnerCard1] || newCert){
            ac = [[UIActionSheet alloc] initWithTitle:@""
                                             delegate:(id)self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"查看原图", @"从相册选取", @"拍照",nil];
            ac.tag = 1001;
        }
        else
        {
            ac = [[UIActionSheet alloc] initWithTitle:@""
                                             delegate:(id)self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"从相册选取", @"拍照",nil];
            ac.tag = 1002;
        }
    }
    else{
        if([Util isNilValue:model.travelCard1] || newLisence){
            ac = [[UIActionSheet alloc] initWithTitle:@""
                                             delegate:(id)self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"查看原图", @"从相册选取", @"拍照",nil];
            ac.tag = 1001;
        }
        else{
            ac = [[UIActionSheet alloc] initWithTitle:@""
                                             delegate:(id)self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"从相册选取", @"拍照",nil];
            ac.tag = 1002;
        }
    }
    
    
    ac.actionSheetStyle = UIBarStyleBlackTranslucent;
    [ac showInView:self.view];
    
    if(sender == self.btnCert){
        self.type = enumAddPhotoTypeCert;
    }
    else{
        self.type = enumAddPhotoTypeLisence;
    }
}


#pragma mark- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if(actionSheet.tag == 1002){
            [Util openPhotoLibrary:self allowEdit:NO completion:nil];
        }else{
            NSMutableArray *array = [[NSMutableArray alloc] init];
            CarInfoModel *model = self.carInfo;
            if(self.type == enumAddPhotoTypeLisence){
                if(newLisence)
                    [array addObject:newLisence];
                else
                    [array addObject:model.travelCard1];
            }
            else{
                if(newCert)
                    [array addObject:newCert];
                else
                    [array addObject:model.carOwnerCard1];
            }
            
            _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
            [_imageList addImageObjs:array];
            [self.view.window addSubview:_imageList];
        }
        
    }else if (buttonIndex == 1)
    {
        if(actionSheet.tag == 1002){
            [Util openCamera:self allowEdit:NO completion:^{}];
        }else{
            [Util openPhotoLibrary:self allowEdit:NO completion:nil];
        }
    }
    else if(buttonIndex == 2){
        if(actionSheet.tag == 1002){
            
        }else{
            [Util openCamera:self allowEdit:NO completion:^{}];
        }
        
    }else{
        
    }
}

- (void) doBtnCarInsurPlan:(UIButton *) sender
{
    [self resignFirstResponder];
    
    if([self isModify]){
        if([self checkInfoFull]){
            if([self checkInfoRight]){
                [self submitWithLicense:^(int code, id content) {
                    if(code == 200){
                        [self car_insur_plan:[content objectForKey:@"data"]];
                    }
                }];
            }
        }
    }else{
        if([self checkInfoFull])
            [self car_insur_plan:self.carInfo.customerCarId];
    }
}

- (BOOL) isHasLisence
{
    if(newLisence == nil && ![self isNilValue:self.carInfo.travelCard1]){
        return NO;
    }else
        return YES;
}

- (BOOL) isHasCert
{
    if(newCert == nil && ![self isNilValue:self.carInfo.carOwnerCard1])
        return NO;
    else
        return YES;
}

@end
