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
    
    [self.btnSelect setImage:ThemeImage(@"unselect_point") forState:UIControlStateNormal];
    [self.btnSelect setImage:ThemeImage(@"select_point") forState:UIControlStateSelected];
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
