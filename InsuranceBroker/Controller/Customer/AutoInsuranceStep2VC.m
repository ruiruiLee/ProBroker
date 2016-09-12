//
//  AutoInsuranceStep2VC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "AutoInsuranceStep2VC.h"
#import "define.h"
#import "ZHPickView.h"
#import "NetWorkHandler+getAndSaveCustomerCar.h"
#import "CustomerCarInfoModel.h"
#import "UIButton+WebCache.h"
#import <AVOSCloud/AVOSCloud.h>
#import "IBUIFactory.h"
#import "OrderWebVC.h"

@interface AutoInsuranceStep2VC ()<ZHPickViewDelegate, MotorcycleTypeSelectedVCDelegate, UITextFieldDelegate>
{
    ZHPickView *_datePicker1;
    NSDate *_changNameDate;
    ZHPickView *_datePicker;
    NSDate *_registerDate;
    
    UIImage *newLisence;
}

@end

@implementation AutoInsuranceStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.viewWidth.constant = ScreenWidth;
    self.btnSubmit.layer.cornerRadius = 4;
    
    [self.switchTransfer setOn:NO animated:YES];
    
    self.tfIdenCode.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.tfModel.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.tfMotorCode.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    self.tfMotorCode.text = self.carInfoModel.carEngineNo;
    self.tfModel.text = self.carInfoModel.carTypeNo;
    self.tfRegisterDate.text = [Util getDayString:self.carInfoModel.carRegTime];
    self.lbTransferDate.text = [Util getDayString:self.carInfoModel.carTradeTime];
    [self.btnLisence sd_setBackgroundImageWithURL:[NSURL URLWithString:self.carInfoModel.travelCard1] forState:UIControlStateNormal placeholderImage:ThemeImage(@"drivingLicenseBg")];
    [self.switchTransfer setOn:self.carInfoModel.carTradeStatus - 1 animated:YES];
    
    self.tfIdenCode.text = self.carInfoModel.carShelfNo;
    
    self.tfIdenCode.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.tfModel.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.tfMotorcycleType.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.tfMotorCode.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    if(self.carInfoModel.newCarNoStatus){
        [self.btnLisence sd_setBackgroundImageWithURL:[NSURL URLWithString:self.carInfoModel.travelCard1] forState:UIControlStateNormal placeholderImage:ThemeImage(@"fapiao")];
        self.switchTransferHeight.constant = 0;
        self.lbRegisterDateString.text = @"购车日期";
        self.tfRegisterDate.placeholder = @"请选择购车日期";
        [self.switchTransfer setOn:NO animated:YES];
    }
    else{
        
    }
    
    UIButton *btnDetail = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
    [btnDetail setTitle:@"快速算价" forState:UIControlStateNormal];
    btnDetail.layer.cornerRadius = 12;
    btnDetail.layer.borderWidth = 0.5;
    btnDetail.layer.borderColor = _COLOR(0xff, 0x66, 0x19).CGColor;
    [btnDetail setTitleColor:_COLOR(0xff, 0x66, 0x19) forState:UIControlStateNormal];
    btnDetail.titleLabel.font = _FONT(12);
    //        btnDetail.backgroundColor = _COLOR(0xff, 0x66, 0x1a);
    [self setRightBarButtonWithButton:btnDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleRightBarButtonClicked:(id)sender
{
    NSString *_quoteUrl = ((AppDelegate *) [UIApplication sharedApplication].delegate).quoteUrl;
    if(_quoteUrl != nil){
        QuickQuoteVC *web = [IBUIFactory CreateQuickQuoteVC];
        web.hidesBottomBarWhenPushed = YES;
        web.title = @"快速算价";
        web.type = enumShareTypeNo;
        web.shareTitle = @"算价方案";
        [self.navigationController pushViewController:web animated:YES];
        
        [web loadHtmlFromUrlWithUserId:_quoteUrl];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Refresh_Home object:nil];
        [Util showAlertMessage:@"正在初始化快速算价数据，请稍后再试！"];
    }
}

- (BOOL) resignFirstResponder
{
    BOOL flag = [super resignFirstResponder];
    
    [self.tfRegisterDate resignFirstResponder];
    [self.tfMotorcycleType resignFirstResponder];
    [self.tfMotorCode resignFirstResponder];
    [self.tfModel resignFirstResponder];
    [self.tfIdenCode resignFirstResponder];
    [self.lbTransferDate resignFirstResponder];
    
    return flag;
}

- (IBAction) addDatePicker1:(id) sender
{
    [self resignFirstResponder];
    
    if(!_datePicker){
        _datePicker = [[ZHPickView alloc] initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDate isHaveNavControler:YES];
        _datePicker.lbTitle.text = @"选择注册日期";
        [_datePicker show];
        _datePicker.delegate = self;
    }else{
        [_datePicker show];
    }
    
    _datePicker.tag = 10001;
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultDate:(NSDate *)resultDate
{
    int tag = pickView.tag;
    if(tag == 10001){
        _registerDate = resultDate;
        self.tfRegisterDate.text = [Util getDayString:resultDate];
    }
    else{
        _changNameDate = resultDate;
        self.lbTransferDate.text = [Util getDayString:resultDate];
    }
}

- (void)toobarCandelBtnHaveClick:(ZHPickView *)pickView
{
    
}

- (IBAction)doBtnSelectedMotorcycleType:(id)sender
{
    MotorcycleTypeSelectedVC *vc = [IBUIFactory CreateMotorcycleTypeSelectedVC];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma MotorcycleTypeSelectedVCDelegate
- (void) NotifySelected:(MotorcycleTypeSelectedVC *) vc result:(NSString *) result
{
    self.tfMotorcycleType.text = result;
}

- (IBAction)doBtnSelectTraserDate:(id)sender
{
    [self resignFirstResponder];
    
    if(!_datePicker1){
        _datePicker1 = [[ZHPickView alloc] initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDate isHaveNavControler:YES];
        _datePicker1.lbTitle.text = @"选择过户日期";
        [_datePicker1 show];
        _datePicker1.delegate = self;
    }else{
        [_datePicker1 show];
    }
    
    _datePicker1.tag = 10002;
}

-(IBAction) switchButoonChange:(id)sender
{
    BOOL flag = self.switchTransfer.on;
    if(flag){
        self.lbTransferDateHeight.constant = 50.f;
    }else{
        self.lbTransferDateHeight.constant = 0;
        _changNameDate = nil;
        self.lbTransferDate.text = @"";
    }
}

#pragma ACTION
- (IBAction) btnPhotoPressed:(UIButton*)sender{
    [self resignFirstResponder];
    
    UIActionSheet *ac;
    
    ac = [[UIActionSheet alloc] initWithTitle:@""
                                     delegate:(id)self
                            cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                            otherButtonTitles:@"从相册选取", @"拍照",nil];
    
    ac.actionSheetStyle = UIBarStyleBlackTranslucent;
    [ac showInView:self.view];
}


#pragma mark- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [Util openPhotoLibrary:self allowEdit:NO completion:nil];
        
    }else if (buttonIndex == 1)
    {
        [Util openCamera:self allowEdit:NO completion:^{}];
        
    }
}
#pragma mark- UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSData * imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1);
        UIImage *image= [UIImage imageWithData:imageData];
        UIImage *new = [Util scaleToSize:image scaledToSize:CGSizeMake(1500, 1500)];
        
        [self.btnLisence setBackgroundImage:new forState:UIControlStateSelected];
        self.btnLisence.selected = YES;
        newLisence = new;
    }];
    
}

-(NSString *)fileupMothed:(UIImage *) image
{
    //图片
    //添加文件名
    @autoreleasepool {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        AVFile *file = [AVFile fileWithData:imageData];
        [file save];
        return file.url;
    }
}

- (IBAction)doBtnSubmit:(id)sender
{
    [self resignFirstResponder];
    
    BOOL result = [self checkInfoFull];
    if(!result)
        return;
    
    if([self isModify]){
        NSString *carRegTime = self.tfRegisterDate.text;//注册日期
        NSString *carEngineNo = self.tfMotorCode.text;////发动机号
        NSString *carShelfNo = self.tfIdenCode.text;//识别码
        NSString *carTypeNo = self.tfModel.text;//品牌型号
        NSString *carTradeTime = self.lbTransferDate.text;//
        BOOL carTradeStatus = self.switchTransfer.on;
        
        [ProgressHUD show:@"正在上传数据..."];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSString *filePahe = nil;
            if(newLisence != nil){
                filePahe = [self fileupMothed:newLisence];
                if (filePahe==nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showError:@"图片上传失败"];
                    });
                    
                    return ;
                }
            }
            
            [NetWorkHandler requestToGetAndSaveCustomerCar:@"2" userId:[UserInfoModel shareUserInfoModel].userId carNo:self.carInfoModel.carNo newCarNoStatus:!self.carInfoModel.newCarNoStatus carOwnerName:self.carInfoModel.carOwnerName carOwnerCard:self.carInfoModel.carOwnerCard carShelfNo:carShelfNo carBrandName:nil carTypeNo:carTypeNo carEngineNo:carEngineNo carRegTime:carRegTime carTradeStatus:[[NSNumber numberWithBool:carTradeStatus + 1] stringValue] carTradeTime:carTradeTime travelCard1:filePahe Completion:^(int code, id content) {
                
                [ProgressHUD dismiss];
                [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
                if(code == 200){
                    [ProgressHUD showSuccess:@"保存成功"];
                    
                    CustomerCarInfoModel *model = (CustomerCarInfoModel*)[CustomerCarInfoModel modelFromDictionary:[content objectForKey:@"data"]];
                    model.newCarNoStatus = self.carInfoModel.newCarNoStatus;
                    
                    self.carInfoModel = model;
                    
                    [self car_insur_plan:model.customerCarId];
                }
                else{
                    [ProgressHUD showSuccess:@"保存失败"];
                }
                
                
                
            }];
            
        });
    }
    else{
        [self car_insur_plan:self.carInfoModel.customerCarId];
    }
}

- (void) car_insur_plan:(NSString *) customerCarId
{
    OrderWebVC *web = [[OrderWebVC alloc] initWithNibName:@"OrderWebVC" bundle:nil];
    
    NSString *str = @"";
//    if(self.customerModel.carInfo.carInsurStatus1 && self.customerModel.carInfo.carInsurCompId1 != nil){
//        str = [NSString stringWithFormat:@"&lastYearStatus=1&carInsurCompId1=%@", self.customerModel.carInfo.carInsurCompId1];
//    }
    
    if(self.selectProModel){
        if(self.selectProModel.productAttrId)
            str = [NSString stringWithFormat:@"%@&productId=%@", str, self.selectProModel.productAttrId];
    }
    
    web.title = @"报价";
    [self.navigationController pushViewController:web animated:YES];
    NSString *url = [NSString stringWithFormat:CAR_INSUR_PLAN, Base_Uri, [UserInfoModel shareUserInfoModel].clientKey, [UserInfoModel shareUserInfoModel].userId, self.carInfoModel.customerId, customerCarId, str];
    [web loadHtmlFromUrl:url];
}

- (BOOL) checkInfoFull
{
    
    NSString *carRegTime = self.tfRegisterDate.text;//注册日期
    NSString *carEngineNo = self.tfMotorCode.text;////发动机号
    NSString *carShelfNo = self.tfIdenCode.text;//识别码
    NSString *carTypeNo = self.tfModel.text;//品牌型号
    NSString *carTradeTime = self.lbTransferDate.text;//
    BOOL carTradeStatus = self.switchTransfer.on;
    
    if(carTradeStatus){
        if(carTradeTime == nil || [carTradeTime length] == 0){
            [Util showAlertMessage:@"请选择过户日期"];
            return NO;
        }
    }
    
    if(newLisence || (self.carInfoModel.travelCard1 != nil && [self.carInfoModel.travelCard1 length] > 0))
        return YES;
    else{
        BOOL flag = [self showMessage:@"车辆信息不完善（请上传行驶证照片或者填写完相关明细项）" string:carEngineNo];
        if(flag){
            return NO;
        }
        flag = [self showMessage:@"车辆信息不完善（请上传行驶证照片或者填写完相关明细项）" string:carShelfNo];
        if(flag){
            return NO;
        }
        flag = [self showMessage:@"车辆信息不完善（请上传行驶证照片或者填写完相关明细项）" string:carTypeNo];
        if(flag){
            return NO;
        }
        flag = [self showMessage:@"车辆信息不完善（请上传行驶证照片或者填写完相关明细项）" string:carRegTime];
        if(flag){
            return NO;
        }
        
    }
    
    return YES;
}

/*
 是空返回NO
 */
- (BOOL) isNilValue:(NSString *) value
{
    if(value == nil || [value length] == 0)
        return NO;
    else
        return YES;
}

- (BOOL) showMessage:(NSString *)msg string:(NSString *) string
{
    if(string == nil || [string length] == 0)
    {
        [Util showAlertMessage:msg];
        return YES;
    }
    
    return NO;
}

//没有行驶证照片返回NO
- (BOOL) isHasLisence
{
    if(newLisence == nil && ![self isNilValue:self.carInfoModel.travelCard1]){
        return NO;
    }else
        return YES;
}

//value 控件中的值
- (BOOL) checkValueChange:(NSString *) value text:(NSString *) text
{
    BOOL flag = NO;
    if(text == nil)
        text = @"";
    if(value != nil){
        if(![value isEqualToString:text])
            flag = YES;
    }
    
    return flag;
}

- (BOOL) isModify
{
    CustomerCarInfoModel *model = self.carInfoModel;
    BOOL result = NO;
    BOOL carTradeStatus = self.switchTransfer.on;

    NSString *date = self.tfRegisterDate.text;
    BOOL flag = [self checkValueChange:date text:[Util getDayString:model.carRegTime]];
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
    
    //是否过户
    if( model != nil && (model.carTradeStatus != carTradeStatus + 1)){
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
    
    if(newLisence)
        result = YES;
    
    return result;
}

- (IBAction)doButtonHowToWrite:(UIButton *)sender
{
    [self resignFirstResponder];
    
    if(self.carInfoModel.newCarNoStatus){
        NSArray *urlArray = @[ThemeImage(@"price_img")];
        _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
        [_imageList addImages:urlArray];
        [self.view.window addSubview:_imageList];
    }
    else{
        NSArray *urlArray = @[ThemeImage(@"license_img")];
        _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
        [_imageList addImages:urlArray];
        [self.view.window addSubview:_imageList];
    }
}

-(void)dismissImageAction:(UIImageView*)sender
{
    NSLog(@"dismissImageAction");
    [_imageList removeFromSuperview];
    _imageList = nil;
}

@end
