//
//  DeatilTextTableviewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/28.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "DeatilTextTableviewCell.h"
#import "define.h"

@implementation DeatilTextTableviewCell

- (void)awakeFromNib {
    // Initialization code
    self.lbDetailTitle.textColor = Subhead_Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
