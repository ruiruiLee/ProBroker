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
#import "CustomerCarInfoModel.h"
#import "NetWorkHandler+getAndSaveCustomerCar.h"
#import "NetWorkHandler+queryForProductList.h"
#import "InsuranceCompanyModel.h"
#import "NSString+URL.h"
#import "IQKeyboardManager.h"
#import "SRAlertView.h"

@interface AutoInsuranceStep1VC ()<ProvienceSelectedViewDelegate>
{
    NSArray *_insurCompanyArray;
}

@end

@implementation AutoInsuranceStep1VC
@synthesize lbProvience;
@synthesize btnProvience;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.btnSubmit.layer.cornerRadius = 4;
    self.tfCardNum.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
    [leftBgView addSubview:bgview];
    bgview.backgroundColor = _COLOR(249, 234, 222);
    bgview.layer.cornerRadius = 3;
    bgview.layer.borderWidth = 0.5;
    bgview.layer.borderColor = _COLOR(0xff, 0x76, 0x29).CGColor;
    
    lbProvience = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 29)];
    lbProvience.backgroundColor = [UIColor clearColor];
    lbProvience.font = _FONT(14);
    lbProvience.textAlignment = NSTextAlignmentCenter;
    lbProvience.textColor = _COLOR(0x21, 0x21, 0x21);
    lbProvience.text = @"川";
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 10, 6)];
    [bgview addSubview:imagev];
    imagev.image = ThemeImage(@"open_arrow");
    [bgview addSubview:lbProvience];
    self.btnProvience = [[HighNightBgButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [bgview addSubview:self.btnProvience];
    [self.btnProvience addTarget:self action:@selector(selectNewProvience:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tfCardNum.leftView = leftBgView;
    self.tfCardNum.leftViewMode = UITextFieldViewModeAlways;
    
    _perInsurCompany = -1;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"行驶证报价，可直接点击［立即报价］"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:_COLOR(0xff, 0x66, 0x19) range:NSMakeRange(12, 4)];
    
    self.lbWarning.attributedText = attributedString;
    
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = _COLOR(0xe3, 0xe3, 0xe3).CGColor;
    
    self.bgViewHeight.constant = SCREEN_HEIGHT - 64;
    self.bgViewWidth.constant = ScreenWidth;
    
}

- (void) loadInsurCompany
{
    [ProgressHUD show:nil];
    [NetWorkHandler requestToQueryForProductList:@"1" Completion:^(int code, id content) {
        [ProgressHUD dismiss];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        
        if(code == 200){
            _insurCompanyArray = [InsuranceCompanyModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]];
        }
        
    }];
}

- (BOOL) resignFirstResponder
{
    BOOL flag = [super resignFirstResponder];
    
    [self.tfCardNum resignFirstResponder];
    
    return flag;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
    NSString *cardNum = [self getCarCertString];
    cardNum = [cardNum uppercaseString];
    cardNum = [cardNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if([cardNum length] == 0){
        
        [SRAlertView sr_showAlertViewWithTitle:nil
                                       message:@"您也可以尝试，输入车牌报价~"
                               leftActionTitle:@"输入车牌"
                              rightActionTitle:@"上传行驶证"
                                animationStyle:AlertViewAnimationZoom
                                  selectAction:^(AlertViewActionType actionType) {
                                      if(actionType == AlertViewActionTypeRight)
                                          [self quickQuoteWithCarNo:@""];
                                      else
                                          [self.tfCardNum becomeFirstResponder];
                                  }];
        
        return;
    }
    
    if([cardNum length] > 0 && ![Util validateCarNo:cardNum]){
        [Util showAlertMessage:@"请输入正确车牌号！"];
        return;
    }
    
    [self quickQuoteWithCarNo:cardNum];
    
}

- (void) quickQuoteWithCarNo:(NSString *) carNo
{
    QuickQuoteVC *web = [IBUIFactory CreateQuickQuoteVC];
    web.hidesBottomBarWhenPushed = YES;
    web.type = enumShareTypeNo;
    web.shareTitle = @"算价方案";
    [self.navigationController pushViewController:web animated:YES];
    
    NSString *string = [NSString stringWithFormat:CHE_XIAN_BAO_JIA, [UserInfoModel shareUserInfoModel].uuid, [carNo URLEncodedString]];
    [web loadHtmlFromUrl:string];
}

@end
