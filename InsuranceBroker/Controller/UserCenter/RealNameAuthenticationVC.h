//
//  RealNameAuthenticationVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/29.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "HBImageViewList.h"

typedef enum : NSUInteger {
    enumCertType1,//正面
    enumCertType2,//反面
} enumCertType;

@interface RealNameAuthenticationVC : BaseViewController
{
    enumCertType currentcertType;
    HBImageViewList *_imageList;
    UIImage * imgCer1;
    UIImage * imgCer2;
    UIImage * newimgCer1;
    UIImage * newimgCer2;
}

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *viewHConstraint;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *submitVConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *submitOffsetVConstraint;

@property (nonatomic, strong) IBOutlet UITextField *tfName;
@property (nonatomic, strong) IBOutlet UITextField *tfCertNo;
@property (nonatomic, strong) IBOutlet UIButton *btnCert1;//证件
@property (nonatomic, strong) IBOutlet UIButton *btnCert2;//
@property (nonatomic, strong) IBOutlet UIButton *btnSubmit;
@property (nonatomic, strong) IBOutlet UILabel *lbWarning;
@property (nonatomic, strong) IBOutlet UILabel *lbErrorInfo;

@end
