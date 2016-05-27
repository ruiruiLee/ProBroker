//
//  InsuredUserInfoEditVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/17.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "MenuViewController.h"
#import "HighNightBgButton.h"

@interface InsuredUserInfoEditVC : BaseViewController<UIActionSheetDelegate, UITextFieldDelegate, MenuDelegate>


@property (nonatomic, strong) IBOutlet NSLayoutConstraint *viewHConstraint;

@property (nonatomic, strong) IBOutlet UITextField *tfEmail;
@property (nonatomic, strong) IBOutlet UITextField *tfSex;

@property (nonatomic, strong) IBOutlet UITextField *tfMobile;
@property (nonatomic, strong) IBOutlet UITextField *tfName;
@property (nonatomic, strong) IBOutlet UITextField *tfCert;
@property (nonatomic, strong) IBOutlet UITextField *tfRelation;
@property (nonatomic, strong) IBOutlet UIButton *btnRelation;
@property (nonatomic, strong) IBOutlet UIImageView *rightArraw;

@property (nonatomic, strong) MenuViewController *menuView;

@property (nonatomic, strong) NSArray *relatrionArray;

@property (nonatomic, assign) NSInteger selectRelationTypeIdx;
@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, strong) NSString *customerId;

- (BOOL) isModify;

- (NSString *) formatPhoneNum:(NSString *) phoneNum;

- (void) submitWithInsuredId:(NSString *) insuredId;

- (NSInteger) getSelectIndexWithRelationValue:(NSString *) value;

@end
