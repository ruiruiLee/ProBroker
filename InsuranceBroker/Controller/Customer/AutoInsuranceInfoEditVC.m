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
#import <AVOSCloud/AVOSCloud.h>
#import "PhotoBrowserView.h"
#import "InsurCompanySelectVC.h"
#import "NetWorkHandler+queryForInsuranceCompanyList.h"
#import "NetWorkHandler+queryForCustomerCarInfo.h"
#import "InsuranceCompanyModel.h"
#import "CarAddInfoTableCell.h"
#import "ZHPickView.h"
#import "DictModel.h"
#import "UIImageView+WebCache.h"
#import "OrderWebVC.h"
#import "SJAvatarBrowser.h"
#import "ProgressHUD.h"
#import "UIButton+WebCache.h"
#import "NetWorkHandler+saveOrUpdateCustomer.h"

@interface AutoInsuranceInfoEditVC ()<MenuDelegate, ZHPickViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
{
    NSInteger _perInsurCompany;
    NSArray *_insurCompanyArray;
    
    NSInteger _changeNameIdx;
    NSMutableArray *_changeNameArray;
    
    NSDate *_changNameDate;
    NSDate *_signDate;
    
    ZHPickView *_datePicker;
    ZHPickView *_datePicker1;
    
    BOOL isCertModify;
    
    UIImage *newLisence;
    UIImage *newCert;
}

@property (nonatomic,strong) PhotoBrowserView *photoBrowserView;
@property (nonatomic, strong) InsurCompanySelectVC *menuView;
@property (nonatomic, strong) MenuViewController *menu;

@end

@implementation AutoInsuranceInfoEditVC
@synthesize btnQuote;

- (void) dealloc
{
    if(_datePicker){
        [_datePicker remove];
    }
    if(_datePicker1){
        [_datePicker1 remove];
    }
}

- (void) handleLeftBarButtonClicked:(id)sender
{
    [self.tfNo resignFirstResponder];
    [self.tfName resignFirstResponder];
    [self.tfMotorCode resignFirstResponder];
    [self.tfModel resignFirstResponder];
    [self.tfIdenCode resignFirstResponder];
    [self.tfDate resignFirstResponder];
    [self.tfCert resignFirstResponder];
    
    if(_datePicker){
        [_datePicker remove];
    }
    if(_datePicker1){
        [_datePicker1 remove];
    }
    
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

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        _perInsurCompany = -1;
        _changeNameIdx = 0;
        self.type = enumAddPhotoTypeNone;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadInsurCompany];
    
    isCertModify = NO;
    self.lbIsTransfer.text = @"否";
    
    [self.tfName addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.tfNo addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.tfMotorCode addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.tfModel addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.tfIdenCode addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.tfDate addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.tfCert addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.btnCert.layer.borderWidth = 1;
    self.btnCert.layer.borderColor = _COLOR(0xe6, 0xe6, 0xe6).CGColor;
    [self.btnCert addTarget:self action:@selector(btnPhotoPressed:) forControlEvents:UIControlEventTouchUpInside];
    _changeNameArray = [[NSMutableArray alloc] init];
    DictModel *model = [[DictModel alloc] init];
    model.dictName = @"否";
    [_changeNameArray addObject:model];
    
    DictModel *model1 = [[DictModel alloc] init];
    model1.dictName = @"是";
    [_changeNameArray addObject:model1];
    
    self.infoHConstraint.constant = ScreenWidth;
    self.imageHConstraint.constant = ScreenWidth;
    
    
    self.title = @"车辆信息";
    [self SetRightBarButtonWithTitle:@"保存" color:_COLORa(0xff, 0x66, 0x19, 0.5) action:NO];

    
    self.tfDate.delegate = self;
    self.tfCert.delegate = self;
    self.tfIdenCode.delegate = self;
    self.tfModel.delegate = self;
    self.tfMotorCode.delegate = self;
    self.tfName.delegate = self;
    self.tfNo.delegate = self;
    self.lbExplain.attributedText = [self getAttbuteString];
    self.lbExplain.hidden = YES;
    self.scrollview.delegate = self;
    
    self.tfMotorCode.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.tfIdenCode.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.tfModel.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.tfNo.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.tfCert.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    
    [self.btnReSubmit setTitle:@"上传照片" forState:UIControlStateNormal];
    [self.btnReSubmit addTarget:self action:@selector(btnPhotoPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    btnQuote = [[UIButton alloc] init];
    [self.view addSubview:btnQuote];
    [btnQuote setTitle:@"立即\n报价" forState:UIControlStateNormal];
    btnQuote.translatesAutoresizingMaskIntoConstraints = NO;
    btnQuote.layer.cornerRadius = 24;
    btnQuote.backgroundColor = _COLOR(0xff, 0x66, 0x19);
    btnQuote.titleLabel.font = _FONT_B(14);
    btnQuote.titleLabel.numberOfLines = 2;
    btnQuote.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnQuote.layer.shadowColor = _COLOR(0xff, 0x66, 0x19).CGColor;
    btnQuote.layer.shadowOffset = CGSizeMake(0, 0);
    btnQuote.layer.shadowOpacity = 0.5;
    btnQuote.layer.shadowRadius = 1;
    [btnQuote addTarget:self action:@selector(doBtnCarInsurPlan:) forControlEvents:UIControlEventTouchUpInside];
    
    self.scrollview.showsHorizontalScrollIndicator = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(btnQuote);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnQuote(48)]-10-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[btnQuote(48)]->=0-|" options:0 metrics:nil views:views]];
    
    self.btnReSubmit.layer.cornerRadius = 3;
    
    self.viewHConstraint.constant = ScreenWidth;
    
    [self.btnNoNo setImage:ThemeImage(@"select") forState:UIControlStateSelected];
    self.btnChange.selected = YES;
    [self doBtnInfoChange:self.btnChange];
}

- (void) valueChanged:(UITextField*) obj
{
    [self isModify];
}

- (void) loadCarInfoWithCustomerId:(NSString *) customerCarId
{
    [NetWorkHandler requestToQueryForCustomerCarInfo:customerCarId Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            CarInfoModel *model = (CarInfoModel*)[CarInfoModel modelFromDictionary:[content objectForKey:@"data"]];
            self.customerModel.carInfo = model;
            [self fillTheData];
        }
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    if(offset >= ScreenWidth){
        self.lbExplain.hidden = NO;
        self.btnHow.hidden = YES;
        self.btnChange.selected = NO;
    }else{
        self.lbExplain.hidden = YES;
        self.btnHow.hidden = NO;
        self.btnChange.selected = YES;
    }
    
    if(self.btnChange.selected){
        self.lbInfo.textColor = _COLOR(0xff, 0x66, 0x19);
        self.lbPhoto.textColor = _COLOR(0x21, 0x21, 0x21);
    }else{
        self.lbPhoto.textColor = _COLOR(0xff, 0x66, 0x19);
        self.lbInfo.textColor = _COLOR(0x21, 0x21, 0x21);
    }
    self.btnChange.selected = !self.btnChange.selected;
}

- (NSMutableAttributedString *)getAttbuteString
{
    NSString *text = @"*所有证件资料仅用于车辆报价或投保，不用做其他用途。";
//    NSString *text = @"*优快保经纪人保证所有证件资料仅用于车辆报价或投保，不用做其他用途，请放心上传";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    
    return string;
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

- (BOOL) resignFirstResponder
{
    BOOL flag = [super resignFirstResponder];
    
    [self.tfCert resignFirstResponder];
    [self.tfDate resignFirstResponder];
    [self.tfIdenCode resignFirstResponder];
    [self.tfModel resignFirstResponder];
    [self.tfMotorCode resignFirstResponder];
    [self.tfName resignFirstResponder];
    [self.tfNo resignFirstResponder];
    
    return flag;
}

////续保用户; 上传所有材料：身份证和行驶证； 上传文字资料
//- (BOOL) isRenewingCoverage
//{
//    BOOL result = NO;
//    
//    NSString *carNo = [self getCarCertString];
//    if(([Util validateCarNo:carNo] || [self isHasLisence]) && _perInsurCompany >= 0){
//        return YES;
//    }
//    
//    return result;
//}

- (BOOL) checkInfoFull
{
    BOOL result = NO;
    
    NSString *carOwnerCard = self.tfCert.text;//身份证号
    NSString *carRegTime = self.tfDate.text;//注册日期
    NSString *carEngineNo = self.tfMotorCode.text;////发动机号
    NSString *carShelfNo = self.tfIdenCode.text;//识别码
    NSString *carTypeNo = self.tfModel.text;//品牌型号
    NSString *carNo = [self getCarCertString];//车牌;
    
    if(_perInsurCompany >= 0){
        if([Util validateCarNo:carNo] || [self isHasLisence]){
            return YES;
        }else{
            [Util showAlertMessage:@"请填写车牌号或上传行驶证"];
            return NO;
        }
    }
    
    BOOL isCarInfo = NO;
    if(self.btnReSubmit.selected || ([self isNilValue:carRegTime] && [self isNilValue:carEngineNo] && [self isNilValue:carShelfNo] && [self isNilValue:carTypeNo] && ([self isNilValue:carNo] || self.btnNoNo.selected))){
        isCarInfo = YES;
    }
    if(isCarInfo && (self.btnCert.selected || [Util validateIdentityCard:carOwnerCard])){
        return YES;
    }
    
    if(!self.btnCert.selected){
        BOOL flag = [Util validateIdentityCard:carOwnerCard];//[self showMessage:@"车主身份证号不能为空" string:carOwnerCard];
        if(!flag){
            [Util showAlertMessage:@"车主身份证号不正确"];
            return result;
        }
    }
    if(!self.btnReSubmit.selected){
        if(!self.btnNoNo.selected){
            if(![Util validateCarNo:carNo]){
                [Util showAlertMessage:@"车牌号不正确"];
                return result;
            }
        }
        BOOL flag = [self showMessage:@"发动机号不能为空" string:carEngineNo];
        if(flag){
            return result;
        }
        flag = [self showMessage:@"车辆识别代号不能为空" string:carShelfNo];
        if(flag){
            return result;
        }
        flag = [self showMessage:@"品牌型号不能为空" string:carTypeNo];
        if(flag){
            return result;
        }
    }
    
    return result;
}

- (void) handleRightBarButtonClicked:(id)sender
{
    [self resignFirstResponder];
    
    if([self checkInfoFull]){
        if(newCert){
//            [self saveOrUpdateCustomerCert:^(int code, id content) {
//                if(code == 200){
                    [self submitWithLicense:^(int code, id content) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
//                }
//            }];
        }else{
            [self submitWithLicense:^(int code, id content) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}

- (void) submitWithLicense:(Completion) completion
{
    NSString *customerCarId = self.customerModel.carInfo.customerCarId;
    NSString *customerId = self.customerId;
    NSString *carOwnerCard = self.tfCert.text;
    NSString *carOwnerName = self.tfName.text;
    NSString *carRegTime = self.tfDate.text;
    NSString *carEngineNo = self.tfMotorCode.text;
    NSString *carShelfNo = self.tfIdenCode.text;
    NSString *carTypeNo = self.tfModel.text;
    NSString *carNo = [self getCarCertString];
    NSString *newCarNoStatus = @"1";
    if(self.btnNoNo.selected){
        carNo = nil;
        newCarNoStatus = @"0";
    }
    else{
    }

    
    NSString *carTradeStatus = @"0";
    NSString *carTradeTime = nil;
    if(_changeNameIdx == 0){
        carTradeStatus = @"1";
    }
    else if (_changeNameIdx == 1){
        carTradeStatus = @"2";
        carTradeTime = [Util getDayString:_changNameDate];
    }
    
    NSString *carInsurStatus1 = nil;
    NSString *carInsurCompId1 = nil;
    if(_perInsurCompany>=0){
        carInsurStatus1 = @"1";
        carInsurCompId1 = ((InsuranceCompanyModel*)[_insurCompanyArray objectAtIndex:_perInsurCompany]).insuranceCompanyId;
    }else{
        carInsurStatus1 = @"0";
        carInsurCompId1 = @"";
    }
    [ProgressHUD show:@"正在上传"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        NSString *filePahe = nil;
        NSString *filePahe1 = nil;
        if(newLisence != nil){
            filePahe = [self fileupMothed:newLisence];
        }
        if(newCert != nil){
            filePahe1 = [self fileupMothed:newCert];
        }
        
        [NetWorkHandler requestToSaveOrUpdateCustomerCar:customerCarId customerId:customerId carNo:carNo carProvinceId:nil carCityId:nil driveProvinceId:nil driveCityId:nil carTypeNo:carTypeNo carShelfNo:carShelfNo carEngineNo:carEngineNo carOwnerName:carOwnerName carOwnerCard:carOwnerCard carOwnerPhone:nil carOwnerTel:nil carOwnerAddr:nil travelCard1:filePahe travelCard2:nil carOwnerCard1:filePahe1 carOwnerCard2:nil carRegTime:carRegTime newCarNoStatus:nil carTradeStatus:carTradeStatus carTradeTime:carTradeTime carInsurStatus1:carInsurStatus1 carInsurCompId1:carInsurCompId1 Completion:^(int code, id content) {
            [ProgressHUD dismiss];
            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
            if(code == 200){
                CarInfoModel *model = self.customerModel.carInfo;
                if(model == nil){
                    model = [[CarInfoModel alloc] init];
                    self.customerModel.carInfo = model;
                }
                model.customerCarId = [content objectForKey:@"data"];
                model.customerId = customerId;
                model.carOwnerName = carOwnerName;
                model.carOwnerCard = carOwnerCard;
                model.carRegTime = _signDate;
                model.carEngineNo = carEngineNo;
                model.carShelfNo = carShelfNo;
                model.carTypeNo = carTypeNo;
                model.carNo = carNo;
                if(filePahe)
                    model.travelCard1 = filePahe;
                if(filePahe1 != nil)
                    self.customerModel.cardNumberImg1 = filePahe1;

                if(completion){
                    completion(code, content);
                }
            }
        }];
    });
}

-(NSString *)fileupMothed:(UIImage *) image
{
    //图片
    //添加文件名
    @autoreleasepool {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
        AVFile *file = [AVFile fileWithData:imageData];
        [file save];
        
        return file.url;
    }

    //文字内容
}

- (IBAction)doButtonEditNo:(UIButton *)sender
{
    BOOL selected = sender.selected;
    if(selected){
        self.tfNo.enabled = YES;
        self.lbDateTitle.text = @"注册日期";
        self.pInfoView.hidden = NO;
        self.assignedView.hidden = NO;
        self.baseViewVConstraint.constant = 90;
        _perInsurCompany = -1;
        _changeNameIdx = -1;
        _changNameDate = nil;
    }else{
        self.tfNo.enabled = NO;
        self.tfNo.text = @"";
        self.lbDateTitle.text = @"购车日期";
        self.pInfoView.hidden = YES;
        self.assignedView.hidden = YES;
        self.baseViewVConstraint.constant = 50;
    }
    
    sender.selected = !selected;
    [self cancelSelectPCompany:nil];
    [self isModify];
}

#pragma mark- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [Util openPhotoLibrary:self allowEdit:YES completion:^{
        }];
        
    }else if (buttonIndex == 1)
    {
        [Util openCamera:self allowEdit:YES completion:^{}];
    }
    else if(buttonIndex == 2){
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if(self.type == enumAddPhotoTypeLisence){
            [array addObject:[self imageLisence]];
        }
        else{
            [array addObject:[self imageCert]];
        }

        _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
//        [_imageList addImagesURL:array withSmallImage:nil];
        [_imageList addImages:array];
        [self.view.window addSubview:_imageList];
        
    }else{
        
    }
}

-(void)dismissImageAction:(UIImageView*)sender
{
    NSLog(@"dismissImageAction");
    [_imageList removeFromSuperview];
    _imageList = nil;
}
#pragma mark- UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSData * imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"],0.5);
        UIImage *image= [UIImage imageWithData:imageData];
        image = [Util fitSmallImage:image scaledToSize:imgLicenseSize];
        isCertModify = YES;
        if(self.type == enumAddPhotoTypeLisence){
            [self.btnReSubmit setImage:image forState:UIControlStateSelected];
            newLisence = image;
            self.btnReSubmit.selected = YES;
        }else{
            [self.btnCert setImage:image forState:UIControlStateSelected];
            newCert = image;
            self.btnCert.selected = YES;
        }
        [self isModify];
        self.type = enumAddPhotoTypeNone;
    }];
    
}

#pragma ACTION
- (void) btnPhotoPressed:(UIButton*)sender{
    
    UIActionSheet *ac;
    
    if(sender == self.btnCert){
        if([self isHasCert])
            ac = [[UIActionSheet alloc] initWithTitle:@""
                                             delegate:(id)self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"从相册选取", @"拍照", @"查看原图",nil];
        else
        {
            ac = [[UIActionSheet alloc] initWithTitle:@""
                                             delegate:(id)self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"从相册选取", @"拍照",nil];        }
    }
    else{
        if([self isHasLisence])
            ac = [[UIActionSheet alloc] initWithTitle:@""
                                             delegate:(id)self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"从相册选取", @"拍照", @"查看原图",nil];
        else{
            ac = [[UIActionSheet alloc] initWithTitle:@""
                                             delegate:(id)self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"从相册选取", @"拍照",nil];
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

- (void) setCustomerModel:(CustomerDetailModel *)model
{
    _customerModel = model;
    if(model.carInfo != nil)
        [self loadCarInfoWithCustomerId:model.carInfo.customerCarId];
    
    [self fillTheData];
}

- (void) fillTheData
{
    CarInfoModel *model = self.customerModel.carInfo;
    self.tfName.text = self.customerModel.customerName;
    if(model){
        self.tfName.text = model.carOwnerName;
        self.tfNo.text = [self getCarCertNum:model.carNo];//model.carNo;
        if(model.newCarNoStatus == 0){
            self.btnNoNo.selected = YES;
            self.tfNo.enabled = NO;
            self.lbDateTitle.text = @"购车日期";
        }else{
            self.btnNoNo.selected = NO;
            self.tfNo.enabled = YES;
            self.lbDateTitle.text = @"注册日期";
        }
        self.tfMotorCode.text = model.carEngineNo;
        self.tfModel.text = model.carTypeNo;
        self.tfIdenCode.text = model.carShelfNo;
        self.tfDate.text = [Util getDayString:model.carRegTime];//model.carRegTime;
        self.tfCert.text = model.carOwnerCard;
        
        if(model.travelCard1 != nil){
            [self.btnReSubmit sd_setImageWithURL:[NSURL URLWithString:model.travelCard1] forState:UIControlStateSelected];
            self.btnReSubmit.selected = YES;
        }else
            self.btnReSubmit.selected = NO;
        
        if(model.carOwnerCard1 != nil){
            [self.btnCert sd_setImageWithURL:[NSURL URLWithString:model.carOwnerCard1] forState:UIControlStateSelected];
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
//                InsuranceCompanyModel *model = [_insurCompanyArray objectAtIndex:_perInsurCompany];
//                self.lbPName.text = model.insuranceCompanyShortName;
                [self menuViewController:_menuView AtIndex:_perInsurCompany];
            }else
            {
                NSInteger i = _perInsurCompany;
                [self cancelSelectPCompany:nil];
                _perInsurCompany = i;
            }
        }
        else{
            [self cancelSelectPCompany:nil];
        }
    }
    [self isModify];
}

- (NSInteger) getSelectIdxFromArray:(NSString *) comapyId
{
    for (int i = 0; i< [_insurCompanyArray count]; i++) {
        InsuranceCompanyModel *model = [_insurCompanyArray objectAtIndex:i];
        if([model.insuranceCompanyId isEqualToString:comapyId])
            return i;
    }
    
    return  -1;
}

//算价
- (void) doBtnCarInsurPlan:(UIButton *) sender
{
    //    http://118.123.249.87:8783/UKB.AgentNew/car_insur/car_insur_plan.html?orderId=e61a2a7d41114fe7a3bf6f96c69a1d9b
    
    [self resignFirstResponder];
    
    if([self isModify]){
        if([self checkInfoFull]){
            if(newCert){
//                [self saveOrUpdateCustomerCert:^(int code, id content) {
//                    if(code == 200){
                        [self submitWithLicense:^(int code, id content) {
                            if(code == 200){
                                [self car_insur_plan:[content objectForKey:@"data"]];
                            }
                        }];
//                    }
//                }];
            }else{
                [self submitWithLicense:^(int code, id content) {
                    if(code == 200){
                        [self car_insur_plan:[content objectForKey:@"data"]];
                    }
                }];
            }
        }
    }else{
        [self car_insur_plan:self.customerModel.carInfo.customerCarId];
    }
}

- (void) car_insur_plan:(NSString *) customerCarId
{
    OrderWebVC *web = [[OrderWebVC alloc] initWithNibName:@"OrderWebVC" bundle:nil];
    web.title = @"报价";
    [self.navigationController pushViewController:web animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/car_insur/car_insur_plan.html?clientKey=%@&userId=%@&customerId=%@&customerCarId=%@", Base_Uri, [UserInfoModel shareUserInfoModel].clientKey, [UserInfoModel shareUserInfoModel].userId, self.customerModel.customerId, customerCarId];
    [web loadHtmlFromUrl:url];
}

- (IBAction)doButtonHowToWrite:(UIButton *)sender
{
    [self.tfCert resignFirstResponder];
    [self.tfDate resignFirstResponder];
    [self.tfIdenCode resignFirstResponder];
    [self.tfModel resignFirstResponder];
    [self.tfMotorCode resignFirstResponder];
    [self.tfName resignFirstResponder];
    [self.tfNo resignFirstResponder];
    if(self.btnNoNo.selected){
        NSArray *urlArray = @[ThemeImage(@"price_img")];
//        _photoBrowserView=[[PhotoBrowserView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame WithArray:urlArray andCurrentIndex:0];
//        [self.view.window addSubview:_photoBrowserView];
        _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
//        [_imageList addImagesURL:urlArray withSmallImage:nil];
        [_imageList addImages:urlArray];
        [self.view.window addSubview:_imageList];
    }
    else{
        NSArray *urlArray = @[ThemeImage(@"license_img")];
//        _photoBrowserView=[[PhotoBrowserView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame WithArray:urlArray andCurrentIndex:0];
//        [self.view.window addSubview:_photoBrowserView];
        _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
//        [_imageList addImagesURL:urlArray withSmallImage:nil];
        [_imageList addImages:urlArray];
        [self.view.window addSubview:_imageList];
    }
}

- (void) loadInsurCompany
{
    [ProgressHUD show:nil];
    [NetWorkHandler requestToQueryForInsuranceCompanyList:nil insuranceType:@"1" Completion:^(int code, id content) {
        [ProgressHUD dismiss];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            _insurCompanyArray = [InsuranceCompanyModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]];
            [self fillTheData];
        }
    }];
}

- (IBAction)menuChange:(UIButton *)sender {
    
    if(_insurCompanyArray == nil){
        [self loadInsurCompany];
        return;
    }
    
    if (!_menuView) {
        NSArray *titles = @[];
        _menuView = [[InsurCompanySelectVC alloc]initWithTitles:titles];
        _menuView.menuDelegate = self;
        
    }
    
    _menuView.titleArray = _insurCompanyArray;
    _menuView.title = @"上一次投保公司";
    _menuView.selectIdx = _perInsurCompany;
    
    [_menuView show:self.view];
    [_menuView.btnCancel addTarget:self action:@selector(cancelSelectPCompany:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) cancelSelectPCompany:(UIButton *)sender
{
    _perInsurCompany = -1;
    self.lbPName.text = @"";
    [_menuView hide];
    self.view5.hidden = NO;
    self.view6.hidden = NO;
    self.view7.hidden = NO;
    self.view5VConstraint.constant = 30;
    self.view6VConstraint.constant = 210;
    self.view7VConstraint.constant = 40;
    
    [self isModify];
}

- (IBAction)menuChangeName:(UIButton *)sender {
    
    if (!_menu) {
        _menu = [[MenuViewController alloc]initWithTitles:_changeNameArray];
        _menu.menuDelegate = self;
        
    }
    
    _menu.selectIdx = _changeNameIdx;
    _menu.title = @"是否过户";
    
    [_menu show:self.view];
    
}

-(void)menuViewController:(MenuViewController *)menu AtIndex:(NSUInteger)index
{
    [menu hide];
    
    if(menu == _menuView){//上年度投保
        _perInsurCompany = index;
        self.lbPName.text = ((InsuranceCompanyModel*)[_insurCompanyArray objectAtIndex:index]).insuranceCompanyShortName;
        self.view6.hidden = YES;
        self.view7.hidden = YES;
        self.view5.hidden = YES;
        self.view5VConstraint.constant = 0;
        self.view6VConstraint.constant = 0;
        self.view7VConstraint.constant = 0;
    }else if (menu == _menu){
        _changeNameIdx = index;
        if(index == 1){
            self.lbIsTransfer.text = @"是";
            [self addDatePicker1:nil];
        }
        else{
            self.lbIsTransfer.text = @"否";
            _changNameDate = nil;
            self.lbTransferDate.text = @"";
        }
    }
    
    [self isModify];
}
-(void)menuViewControllerDidCancel:(MenuViewController *)menu
{
    [menu hide];
}

- (IBAction) addDatePicker:(id) sender
{
    if(!_datePicker){
        _datePicker = [[ZHPickView alloc] initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDate isHaveNavControler:YES];
        [_datePicker show];
        _datePicker.delegate = self;
    }else{
        [_datePicker show];
    }
}

- (IBAction) addDatePicker1:(id) sender
{
    if(!_datePicker1){
        _datePicker1 = [[ZHPickView alloc] initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDate isHaveNavControler:YES];
        [_datePicker1 show];
        _datePicker1.delegate = self;
    }else{
        [_datePicker1 show];
    }
}

#pragma ZHPickViewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultDate:(NSDate *)resultDate
{
    if(pickView == _datePicker){
        _signDate = resultDate;
        NSString *dateStr = [Util getDayString:resultDate];
        self.tfDate.text = dateStr;
    }else{
        _changNameDate = resultDate;
        self.lbTransferDate.text = [Util getDayString:resultDate];
    }
    
    [self isModify];
}

- (void)toobarCandelBtnHaveClick:(ZHPickView *)pickView
{
}//    if(pickView == _datePicker1){
//        _changeNameIdx = 0;
//        [self.tableview reloadData];
//    }


#pragma UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.tfDate){
        [self addDatePicker:nil];
        [self resignFirstResponder];
        [self isModify];
    }else{
        [_datePicker remove];
    }
    return YES;
}

- (BOOL) isModify
{
    CarInfoModel *model = self.customerModel.carInfo;
    BOOL result = NO;
    
    result = isCertModify;
    
    NSString *name = self.tfName.text;
    BOOL flag = [self checkValueChange:name text:model.carOwnerName];
    if(flag)
        result = flag;
    NSString *cert = self.tfCert.text;
    flag = [self checkValueChange:cert text:model.carOwnerCard];
    if(flag)
        result = flag;
    NSString *no = [self getCarCertString];//self.tfNo.text;
    flag = [self checkValueChange:no text:model.carNo];
    if(flag)
        result = flag;
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
        if(![model.carInsurCompId1 isEqualToString:((InsuranceCompanyModel*)[_insurCompanyArray objectAtIndex:_perInsurCompany]).insuranceCompanyId])
            result = YES;
    }
    else{
        if([self isNilValue:model.carInsurCompId1]){
            result = YES;
        }
    }
    //是否过户
    if(model.carTradeStatus != _changeNameIdx + 1){
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
        [self SetRightBarButtonWithTitle:@"保存" color:_COLORa(0xff, 0x66, 0x19, 1) action:YES];
    }
    else{
        [self SetRightBarButtonWithTitle:@"保存" color:_COLORa(0xff, 0x66, 0x19, 0.5) action:NO];
    }
    return result;
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

- (NSString *) getCarCertLocation:(NSString *) cert
{
    return [cert substringToIndex:1];
}

- (NSString *) getCarCertNum:(NSString *) cert
{
//    return [cert substringFromIndex:1];
    return cert;
}

- (NSString *) getCarCertString
{
    NSString *num = _tfNo.text;
    return [NSString stringWithFormat:@"%@%@", @"", num];
}

- (UIImage *) imageLisence
{
    return [self.btnReSubmit imageForState:UIControlStateSelected];
}

//没有行驶证照片返回NO
- (BOOL) isHasLisence
{
    if(newLisence == nil && ![self isNilValue:self.customerModel.carInfo.travelCard1]){
        return NO;
    }else
        return YES;
}

- (UIImage *) imageCert
{
    return [self.btnCert imageForState:UIControlStateSelected];
}

//m
- (BOOL) isHasCert
{
    if(newCert == nil && ![self isNilValue:self.customerModel.carInfo.carOwnerCard1])
        return NO;
    else
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

//btn selected 0 明细  1 照片
- (IBAction)doBtnInfoChange:(UIButton *)sender
{
    if(sender.selected){
        self.lbInfo.textColor = _COLOR(0xff, 0x66, 0x19);
        self.lbPhoto.textColor = _COLOR(0x21, 0x21, 0x21);
        [self.scrollview scrollRectToVisible:CGRectMake(0, 0, ScreenWidth, self.scrollview.frame.size.height) animated:YES];
    }else{
        self.lbPhoto.textColor = _COLOR(0xff, 0x66, 0x19);
        self.lbInfo.textColor = _COLOR(0x21, 0x21, 0x21);
        [self.scrollview scrollRectToVisible:CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollview.frame.size.height) animated:YES];
    }
    sender.selected = !sender.selected;
}

@end
