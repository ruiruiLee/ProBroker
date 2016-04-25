//
//  ProductListTableViewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ProductListTableViewCell.h"
#import "define.h"

@implementation ProductListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.logoImage.layer.borderWidth = 0.4;
    self.logoImage.layer.borderColor = _COLOR(0xe6, 0xe6, 0xe6).CGColor;
    self.logoImage.clipsToBounds = YES;
    self.logoImage.contentMode = UIViewContentModeScaleAspectFill;
    self.lbContent.preferredMaxLayoutWidth = ScreenWidth - 20 - 20 - 10 - 93;
    
    self.lbTitle.font = _FONT_B(14);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
