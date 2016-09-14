//
//  CarListTableViewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/9/12.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "CarListTableViewCell.h"
#import "define.h"

@implementation CarListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.btnSelected setImage:ThemeImage(@"unselect_point") forState:UIControlStateNormal];
    [self.btnSelected setImage:ThemeImage(@"select_point") forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
