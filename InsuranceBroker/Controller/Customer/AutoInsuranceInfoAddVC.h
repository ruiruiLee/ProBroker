//
//  AutoInsuranceInfoAddVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/9/12.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseLineTextField.h"
#import "CustomerDetailModel.h"
#import "LeftImgButton.h"
#import "HBImageViewList.h"
#import "ReactiveButton.h"
#import "productAttrModel.h"


typedef enum : NSUInteger {
    enumAddPhotoTypeNone,
    enumAddPhotoTypeCert,
    enumAddPhotoTypeLisence,
} addPhotoType;

typedef enum : NSUInteger {
    enumInsurance,//首次报价
    enumReInsurance,//重新报价
} InsuranceType;


@class ZHPickView;

//新增
@interface AutoInsuranceInfoAddVC : BaseViewController
{
    HBImageViewList *_imageList;
    
    BOOL isShowWarning;
    
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
    
    NSString *_travelCard1;
    
    NSString *_productId;
}

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *viewHConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *baseViewVConstraint;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *infoHConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *imageHConstraint;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topVConstraint;

@property (nonatomic, strong) IBOutlet UITextField *tfName;//车主姓名
@property (nonatomic, strong) IBOutlet UITextField *tfCert;//身份证号码
@property (nonatomic, strong) IBOutlet UITextField *tfNo;//车牌号
@property (nonatomic, strong) IBOutlet UILabel *lbDateTitle;
@property (nonatomic, strong) IBOutlet UITextField *tfDate;//登记日期
@property (nonatomic, strong) IBOutlet UITextField *tfModel;//品牌型号
@property (nonatomic, strong) IBOutlet UITextField *tfIdenCode;//识别码
@property (nonatomic, strong) IBOutlet UITextField *tfMotorCode;//发动机号
@property (nonatomic, strong) IBOutlet UIView *licenseView;//基本信息
@property (nonatomic, strong) IBOutlet UIButton *btnReSubmit;//重新上传
@property (nonatomic, strong) IBOutlet UIView *contenView;//基本信息
@property (nonatomic, strong) IBOutlet UILabel *lbPName;//上年度保险厂家
@property (nonatomic, strong) IBOutlet UILabel *lbIsTransfer;//是否过户
@property (nonatomic, strong) IBOutlet UILabel *lbTransferDate;//过户时间

@property (nonatomic, strong) IBOutlet UILabel *lbShow;

@property (nonatomic, strong) IBOutlet LeftImgButton *btnNoNo;//新车未上牌
@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UIButton *btnCert;
@property (nonatomic, strong) IBOutlet UIButton *btnHow;
@property (nonatomic, strong) IBOutlet UILabel *lbExplain;


@property (nonatomic, strong) IBOutlet UIView *view1;
@property (nonatomic, strong) IBOutlet UIView *pInfoView;
@property (nonatomic, strong) IBOutlet UIView *assignedView;

//
@property (nonatomic, strong) IBOutlet UILabel *lbInfo;
@property (nonatomic, strong) IBOutlet UILabel *lbPhoto;
@property (nonatomic, strong) IBOutlet UIButton *btnChange;

@property (nonatomic, strong) IBOutlet UIButton *btnHowOrder;

@property (nonatomic, strong) IBOutlet UIImageView *imageShut;

@property (nonatomic, strong) ReactiveButton *btnQuote;//立即报价

@property (nonatomic, strong) HighNightBgButton *btnProvience;//省简称
@property (nonatomic, strong) UILabel *lbProvience;
@property (nonatomic, strong) IBOutlet UILabel *lbCertTitle;

@property (nonatomic, strong) CustomerDetailModel *customerModel;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, assign) addPhotoType type;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, assign) InsuranceType insType;

@property (nonatomic, strong) productAttrModel *selectProModel;//选中的产品

@property (nonatomic, strong) CarInfoModel *carInfo;//车辆信息；新建的时候为空，提交服务器后有数据;修改时不为空

- (IBAction)doButtonEditNo:(UIButton *)sender;

//
- (IBAction)doButtonHowToWrite:(UIButton *)sender;

//传递产品id过来
- (void) initWithProductId:(NSString *) product;

//上传图片到服务器
-(NSString *)fileupMothed:(UIImage *) image;

//获取特定客户的车辆详细信息
- (void) loadCarInfoWithCustomerId:(NSString *) customerCarId;


- (BOOL) isModify;

//取消上年度保险
- (void) cancelSelectPCompany:(UIButton *)sender;

- (NSString *) getCarCertLocation:(NSString *) cert;

- (NSString *) getCarCertNum:(NSString *) cert;

- (BOOL) checkValueChange:(NSString *) value text:(NSString *) text;

- (BOOL) isNilValue:(NSString *) value;

- (void) setRightBarButtonWithFlag:(BOOL) flag;

- (BOOL) checkInfoFull;

- (BOOL) checkInfoRight;

- (void) fillTheData;

- (NSString *) getCarCertString;

- (void) btnPhotoPressed:(UIButton*)sender;

-(void)dismissImageAction:(UIImageView*)sender;

- (void) car_insur_plan:(NSString *) customerCarId;

- (void) submitWithLicense:(Completion) completion;

- (BOOL) isHasLisence;

- (BOOL) isHasCert;

@end
