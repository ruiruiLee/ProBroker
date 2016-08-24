//
//  AutoInsuranceStep1VC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "AutoInsuranceStep1VC.h"
#import "define.h"
#import "ProvienceSelectedView.h"
#import "AutoInsuranceStep2VC.h"

@interface AutoInsuranceStep1VC ()<ProvienceSelectedViewDelegate>

@end

@implementation AutoInsuranceStep1VC
@synthesize lbProvience;
@synthesize btnProvience;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.viewWidth.constant = ScreenWidth;
    self.btnCertImage.layer.borderColor = _COLOR(0xe6, 0xe6, 0xe6).CGColor;
    self.btnCertImage.layer.borderWidth = 0.5;
    self.btnSubmit.layer.cornerRadius = 4;
    
    UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
    
    lbProvience = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 29)];
    lbProvience.backgroundColor = [UIColor clearColor];
    lbProvience.font = _FONT(14);
    lbProvience.textAlignment = NSTextAlignmentCenter;
    lbProvience.textColor = _COLOR(0x21, 0x21, 0x21);
    lbProvience.text = @"川";
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 10, 6)];
    [leftBgView addSubview:imagev];
    imagev.image = ThemeImage(@"open_arrow");
    [leftBgView addSubview:lbProvience];
    self.btnProvience = [[HighNightBgButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftBgView addSubview:self.btnProvience];
    [self.btnProvience addTarget:self action:@selector(selectNewProvience:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tfCardNum.leftView = leftBgView;
    self.tfCardNum.leftViewMode = UITextFieldViewModeAlways;
    
    [self.switchCert setOn:NO];
}

- (BOOL) resignFirstResponder
{
    BOOL flag = [super resignFirstResponder];
    
    [self.tfCardNum resignFirstResponder];
    [self.tfCert resignFirstResponder];
    [self.tfName resignFirstResponder];
    
    return flag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) selectNewProvience:(id)sender
{
    [self resignFirstResponder];
    ProvienceSelectedView *view = [[ProvienceSelectedView alloc] init];
    [self.view.window addSubview:view];
    view.delegate = self;
    [view show];
}

- (void) NotifySelectedProvienceName:(NSString *) name view:(ProvienceSelectedView *) view
{
    self.lbProvience.text = name;
}

- (NSString *) getCarCertLocation:(NSString *) cert
{
    if(cert == nil || [cert length] < 1)
        return @"川";
    return [cert substringToIndex:1];
}

- (NSString *) getCarCertNum:(NSString *) cert
{
    if(cert == nil || [cert length] < 1)
        return @"";
    return [cert substringFromIndex:1];
}

- (NSString *) getCarCertString
{
    NSString *num = self.tfCardNum.text;
    NSString *provience = self.lbProvience.text;
    if(provience == nil)
        provience = @"";
    if(num == nil || [num length] == 0){
        num = @"";
        provience = @"";
    }
    NSString *carNo = [NSString stringWithFormat:@"%@%@", provience, num];
    return carNo;
}

- (IBAction)doBtnSubmit:(id)sender
{
    AutoInsuranceStep2VC *vc = [IBUIFactory CreateAutoInsuranceStep2VC];
    vc.title = @"车辆信息";
    [self.navigationController pushViewController:vc animated:YES];
    
    NSString *name = self.tfName.text;
    NSString *certNum = self.tfCert.text;
    NSString *cardNum = [self getCarCertString];
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

        [self.btnCertImage setBackgroundImage:new forState:UIControlStateSelected];
        self.btnCertImage.selected = YES;
    }];
    
}

-(IBAction) switchButoonChange:(id)sender
{
    BOOL flag = self.switchCert.on;
    if(flag){
        self.tfCardNum.userInteractionEnabled = NO;
        self.tfCardNum.text = @"";
    }else{
        self.tfCardNum.userInteractionEnabled = YES;
    }
}

@end
