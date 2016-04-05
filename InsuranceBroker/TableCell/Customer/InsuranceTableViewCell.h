//
//  InsuranceTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/25.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface InsuranceTableViewCell : BaseTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lbTitle;
@property (nonatomic, strong) IBOutlet UILabel *lbDetail;
@property (nonatomic, strong) IBOutlet UILabel *lbContent;
@property (nonatomic, strong) IBOutlet UIButton *imgV1;
@property (nonatomic, strong) IBOutlet UIButton *imgV2;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *contentVConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *spaceVConstraint;

@end
