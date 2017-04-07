//
//  PayTypeSelectedVCTableViewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/7/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "PayTypeSelectedVCTableViewCell.h"
#import "define.h"

@implementation PayTypeSelectedVCTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [self.btnSelect setImage:ThemeImage(@"pay_img_normal") forState:UIControlStateNormal];
    [self.btnSelect setImage:ThemeImage(@"Pay_img_select") forState:UIControlStateSelected];
    self.btnSelect.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setItemSelected:(BOOL) flag
{
    self.btnSelect.selected = flag;
}

@end
