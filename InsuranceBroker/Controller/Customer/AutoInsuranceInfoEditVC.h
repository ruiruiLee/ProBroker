//
//  AutoInsuranceInfoEditVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/26.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseLineTextField.h"
#import "CustomerDetailModel.h"
#import "LeftImgButton.h"
#import "HBImageViewList.h"

typedef enum : NSUInteger {
    enumAddPhotoTypeNone,
    enumAddPhotoTypeCert,
    enumAddPhotoTypeLisence,
} addPhotoType;

@interface AutoInsuranceInfoEditVC : BaseViewController
{
    HBImageViewList *_imageList;
}


@property (nonatomic, strong) IBOutlet NSLayoutConstraint *viewHConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *baseViewVConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *view5VConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *view6VConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *view7VConstraint;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *infoHConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *imageHConstraint;

@property (nonatomic, strong) IBOutlet BaseLineTextField *tfName;//车主姓名
@property (nonatomic, strong) IBOutlet BaseLineTextField *tfCert;//身份证号码
@property (nonatomic, strong) IBOutlet BaseLineTextField *tfNo;//车牌号
@property (nonatomic, strong) IBOutlet UILabel *lbDateTitle;
@property (nonatomic, strong) IBOutlet BaseLineTextField *tfDate;//登记日期
@property (nonatomic, strong) IBOutlet BaseLineTextField *tfModel;//品牌型号
@property (nonatomic, strong) IBOutlet BaseLineTextField *tfIdenCode;//识别码
@property (nonatomic, strong) IBOutlet BaseLineTextField *tfMotorCode;//发动机号
@property (nonatomic, strong) IBOutlet UIView *licenseView;//基本信息
@property (nonatomic, strong) IBOutlet UIButton *btnReSubmit;//重新上传
@property (nonatomic, strong) IBOutlet UIView *contenView;//基本信息
@property (nonatomic, strong) IBOutlet UILabel *lbPName;//上年度保险厂家
@property (nonatomic, strong) IBOutlet UILabel *lbIsTransfer;//是否过户
@property (nonatomic, strong) IBOutlet UILabel *lbTransferDate;//过户时间

@property (nonatomic, strong) IBOutlet LeftImgButton *btnNoNo;//新车未上牌
@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UIButton *btnCert;
@property (nonatomic, strong) IBOutlet UIButton *btnHow;
@property (nonatomic, strong) IBOutlet UILabel *lbExplain;


@property (nonatomic, strong) IBOutlet UIView *view1;
@property (nonatomic, strong) IBOutlet UIView *view2;
@property (nonatomic, strong) IBOutlet UIView *view3;
@property (nonatomic, strong) IBOutlet UIView *view4;
@property (nonatomic, strong) IBOutlet UIView *view5;
@property (nonatomic, strong) IBOutlet UIView *view6;
@property (nonatomic, strong) IBOutlet UIView *view7;
@property (nonatomic, strong) IBOutlet UIView *pInfoView;
@property (nonatomic, strong) IBOutlet UIView *assignedView;

//
@property (nonatomic, strong) IBOutlet UILabel *lbInfo;
@property (nonatomic, strong) IBOutlet UILabel *lbPhoto;
@property (nonatomic, strong) IBOutlet UIButton *btnChange;

@property (nonatomic, strong) UIButton *btnQuote;//立即报价

@property (nonatomic, strong) CustomerDetailModel *customerModel;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, assign) addPhotoType type;

- (IBAction)doButtonEditNo:(UIButton *)sender;
- (IBAction)doButtonHowToWrite:(UIButton *)sender;


@end
