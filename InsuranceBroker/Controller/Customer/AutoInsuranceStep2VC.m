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

@interface AutoInsuranceStep2VC ()<ZHPickViewDelegate, MotorcycleTypeSelectedVCDelegate>
{
    ZHPickView *_datePicker1;
    NSDate *_changNameDate;
    ZHPickView *_datePicker;
    NSDate *_registerDate;
}

@end

@implementation AutoInsuranceStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.viewWidth.constant = ScreenWidth;
    self.btnSubmit.layer.cornerRadius = 4;
    
    [self.switchTransfer setOn:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }];
    
}

@end
