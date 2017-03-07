//
//  SalesTableViewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/1/13.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "SalesTableViewCell.h"
#import "define.h"

@implementation SalesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // Initialization code
    self.logoImage.layer.borderWidth = 0.4;
    self.logoImage.layer.borderColor = _COLOR(0xe6, 0xe6, 0xe6).CGColor;
    self.logoImage.clipsToBounds = YES;
    self.logoImage.contentMode = UIViewContentModeScaleAspectFill;
    self.lbContent.preferredMaxLayoutWidth = ScreenWidth - 10 - 10 - 10 - 93;
    
    self.lbTitle.font = _FONT_B(15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
