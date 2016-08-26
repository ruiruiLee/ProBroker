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
#import "AppDelegate.h"
#import "CustomerCarInfoModel.h"
#import "NetWorkHandler+getAndSaveCustomerCar.h"

@interface AutoInsuranceStep1VC ()<ProvienceSelectedViewDelegate>

@end

@implementation AutoInsuranceStep1VC
@synthesize lbProvience;
@synthesize btnProvience;

- (void) dealloc
{
//    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
//    [appdelegate removeObserver:self forKeyPath:@"quoteUrl"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
//    [appdelegate addObserver:self forKeyPath:@"quoteUrl" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    self.viewWidth.constant = ScreenWidth;
    self.btnCertImage.layer.borderColor = _COLOR(0xe6, 0xe6, 0xe6).CGColor;
    self.btnCertImage.layer.borderWidth = 0.5;
    self.btnSubmit.layer.cornerRadius = 4;
    self.tfCardNum.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
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
    
    self.bannerHeight.constant = [Util getHeightByWidth:750 height:330 nwidth:ScreenWidth];
}

- (IBAction)doBtnQuickQuote:(id)sender
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

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    NSString *_quoteUrl = ((AppDelegate *) [UIApplication sharedApplication].delegate).quoteUrl;
//    QuickQuoteVC *web = [IBUIFactory CreateQuickQuoteVC];
//    web.hidesBottomBarWhenPushed = YES;
//    web.title = @"快速算价";
//    web.type = enumShareTypeNo;
//    web.shareTitle = @"算价方案";
//    [self.navigationController pushViewController:web animated:YES];
//    
//    [web loadHtmlFromUrlWithUserId:_quoteUrl];
//}

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
    NSString *name = self.tfName.text;
    if(name == nil || [name length] == 0){
        [Util showAlertMessage:@"车主姓名不能为空！"];
        return;
    }
//    NSString *certNum = self.tfCert.text;
//    if ([Util validateIdentityCard:certNum]) {
//        [Util showAlertMessage:@"身份证号不正确，请重新输入！"];
//        return;
//    }
    BOOL newCarNoStatus = self.switchCert.on;
    
    NSString *cardNum = [self getCarCertString];
    cardNum = [cardNum uppercaseString];
    cardNum = [cardNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(!newCarNoStatus){
        if (![Util validateCarNo:cardNum]) {
            [Util showAlertMessage:@"车牌号不正确，请重新输入！"];
            return;
        }
    }
    else{
        cardNum = nil;
    }
    
    if(newCarNoStatus){
        AutoInsuranceStep2VC *vc = [IBUIFactory CreateAutoInsuranceStep2VC];
        vc.title = @"车辆信息";
        CustomerCarInfoModel *model = [[CustomerCarInfoModel alloc] init];
        model.newCarNoStatus = !newCarNoStatus;
        model.carOwnerName = name;
        vc.carInfoModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [ProgressHUD show:nil];
        
        [NetWorkHandler requestToGetAndSaveCustomerCar:@"1" userId:[UserInfoModel shareUserInfoModel].userId carNo:cardNum newCarNoStatus:!newCarNoStatus carOwnerName:name carOwnerCard:nil carShelfNo:nil carBrandName:nil carTypeNo:nil carEngineNo:nil carRegTime:nil carTradeStatus:nil carTradeTime:nil travelCard1:nil Completion:^(int code, id content) {
            
            [ProgressHUD dismiss];
            
            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
            if(code == 200){
                
                CustomerCarInfoModel *model = (CustomerCarInfoModel*)[CustomerCarInfoModel modelFromDictionary:[content objectForKey:@"data"]];
                model.newCarNoStatus = !newCarNoStatus;
                
                AutoInsuranceStep2VC *vc = [IBUIFactory CreateAutoInsuranceStep2VC];
                vc.title = @"车辆信息";
                vc.carInfoModel = model;
                vc.selectProModel = self.selectProModel;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
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
