//
//  OrderManagerTableViewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/29.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "OrderManagerTableViewCell.h"
#import "define.h"

@implementation OrderManagerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.logoImgV.layer.borderWidth = 0.5;
    self.logoImgV.layer.borderColor = _COLOR(0xe6, 0xe6, 0xe6).CGColor;
    [self.hud startAnimating];
    
    self.btnModifyPlain.layer.cornerRadius = 15;
    self.btnModifyPlain.layer.borderWidth = 1;
    self.btnModifyPlain.layer.borderColor = _COLOR(0xff, 0x66, 0x19).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
