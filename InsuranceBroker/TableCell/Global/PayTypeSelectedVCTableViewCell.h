//
//  PayTypeSelectedVCTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/7/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface PayTypeSelectedVCTableViewCell : BaseTableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *logoImgV;
@property (nonatomic, strong) IBOutlet UILabel *lbName;
@property (nonatomic, strong) IBOutlet UIButton *btnSelect;

- (void) setItemSelected:(BOOL) flag;

@end
