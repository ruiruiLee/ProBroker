//
//  UserEditTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/29.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface UserEditTableViewCell : BaseTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lbTitle;
@property (nonatomic, strong) IBOutlet UILabel *lbDetail;
@property (nonatomic, strong) IBOutlet UIImageView *imgv;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *imgHConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *imgVConstraint;


@end
