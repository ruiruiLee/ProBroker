//
//  ServicePushCustomerTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/20.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    enumCustomerFromOther,
    enumCustomerFromWechat,
    enumCustomerFromQQ,
} enumCustomerFrom;

@interface ServicePushCustomerTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *logoImageV;
@property (nonatomic, strong) IBOutlet UIImageView *imageFromV;
@property (nonatomic, strong) IBOutlet UILabel *lbName;
@property (nonatomic, strong) IBOutlet UILabel *lbType;
@property (nonatomic, strong) IBOutlet UILabel *lbActive;
@property (nonatomic, strong) IBOutlet UILabel *lbTime;
@property (nonatomic, strong) IBOutlet UIButton *btnApply;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *logoWConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *logoSepConstraint;

- (void) setCustomerFrom:(enumCustomerFrom) type;

@end
