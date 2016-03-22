//
//  CustomDetailHeaderView.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/21.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubView.h"
#import "HBImageViewList.h"

@class CustomDetailHeaderView;

@protocol CustomDetailHeaderViewDelegate <NSObject>

- (void) NotifyToEditUserInfo:(CustomDetailHeaderView*) sender;
- (void) NotifyToSubmitCustomerHeadImg:(UIImage *) image;

@end

@interface CustomDetailHeaderView : SubView
{
    UIImagePickerController  *picker;
    HBImageViewList *_imageList;
}

@property (nonatomic, strong) IBOutlet UIImageView *photoImageV;//头像
@property (nonatomic, strong) IBOutlet UILabel *lbName;
@property (nonatomic, strong) IBOutlet UILabel *lbMobile;
@property (nonatomic, strong) IBOutlet UILabel *lbTag;
@property (nonatomic, strong) IBOutlet UILabel *lbSepLine1;
@property (nonatomic, strong) IBOutlet UILabel *lbSepLine2;
@property (nonatomic, strong) IBOutlet UIButton *btnEditUser;
@property (nonatomic, strong) IBOutlet UIButton *btnPhone;
@property (nonatomic, strong) IBOutlet UIButton *btnMsg;
@property (nonatomic, strong) IBOutlet UIButton *btnTageEdit;

@property (nonatomic, weak) id<CustomDetailHeaderViewDelegate> delegate;
@property (nonatomic, weak) UIViewController *pvc;

- (IBAction)EditUserInfo:(id)sender;
- (IBAction)PhoneUser:(id)sender;
- (IBAction)SendMsgToUser:(id)sender;

@end
