//
//  CustomerInfoEditVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/23.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "TagListView.h"
#import "OnwerTagView.h"
#import "CustomerDetailModel.h"
#import "SelectAreaModel.h"
#import "PlaceholderTextView.h"

@interface CustomerInfoEditVC : BaseViewController<TagListViewDelegate, OnwerTagViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UITextViewDelegate>


@property (nonatomic, strong) IBOutlet NSLayoutConstraint *viewHConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tagVConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *myTagVConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *remarkCellVConstraint;

@property (nonatomic, strong) IBOutlet UITextField *tfName;
@property (nonatomic, strong) IBOutlet UITextField *tfMobile;
@property (nonatomic, strong) IBOutlet TagListView *tagView;
@property (nonatomic, strong) IBOutlet OnwerTagView *onwerTag;

//add
@property (nonatomic, strong) IBOutlet UITextField *tfEmail;
@property (nonatomic, strong) IBOutlet UITextField *tfDetailAddr;
@property (nonatomic, strong) IBOutlet PlaceholderTextView *tvRemarks;
@property (nonatomic, strong) IBOutlet UITextField *tfAddr;
@property (nonatomic, strong) IBOutlet UITextField *tfSex;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, strong) CustomerDetailModel *data;

@property (nonatomic, strong) SelectAreaModel *selectArea;

- (BOOL) isHasModify;
- (NSArray *) tagModelArrayFromIdAndName;
- (void) updateOrAddLabelInfo;
- (NSString *) formatPhoneNum:(NSString *) phoneNum;

- (IBAction)doBtnSelectSex:(id)sender;
- (IBAction)doBtnSelectArea:(id)sender;

@end
