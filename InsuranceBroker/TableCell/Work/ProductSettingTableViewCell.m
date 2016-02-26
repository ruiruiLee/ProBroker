//
//  ProductSettingTableViewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/26.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ProductSettingTableViewCell.h"
#import "define.h"

@implementation ProductSettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.logo.layer.borderWidth = 0.5;
    self.logo.layer.borderColor = _COLOR(0xe6, 0xe6, 0xe6).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
