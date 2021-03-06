//
//  AutoInsuranceStep2VC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "HBImageViewList.h"

@class CustomerCarInfoModel;
@class productAttrModel;

@interface AutoInsuranceStep2VC : BaseViewController
{
    HBImageViewList *_imageList;
}


@property (nonatomic, strong) IBOutlet NSLayoutConstraint *viewWidth;
@property (nonatomic, strong) IBOutlet UIButton *btnSubmit;
@property (nonatomic, strong) IBOutlet UISwitch *switchTransfer;
@property (nonatomic, strong) IBOutlet UIButton *btnLisence;
@property (nonatomic, strong) IBOutlet UITextField *tfIdenCode;//车架号
@property (nonatomic, strong) IBOutlet UITextField *tfModel;//品牌型号
@property (nonatomic, strong) IBOutlet UITextField *tfMotorcycleType;//车型
@property (nonatomic, strong) IBOutlet UITextField *tfMotorCode;//发动机号
@property (nonatomic, strong) IBOutlet UITextField *lbTransferDate;//过户时间
@property (nonatomic, strong) IBOutlet UITextField *tfRegisterDate;//注册日期
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lbTransferDateHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *switchTransferHeight;
@property (nonatomic, strong) IBOutlet UILabel *lbRegisterDateString;
                             
@property (nonatomic, strong) CustomerCarInfoModel *carInfoModel;

@property (nonatomic, strong) productAttrModel *selectProModel;//选中的产品


@end
