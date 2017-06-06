//
//  ProductRadioListCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/5.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "ProductRadioListCell.h"
#import "define.h"

@implementation ProductRadioListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.productLogo.layer.borderWidth = 1;
    self.productLogo.layer.borderColor = _COLOR(0xE3, 0xE3, 0xE3).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
