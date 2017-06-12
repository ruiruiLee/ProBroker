//
//  InviteListsTableViewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/12.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "InviteListsTableViewCell.h"
#import "define.h"

@implementation InviteListsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lbName.textColor = _COLOR(0x21, 0x21, 0x21);
    self.photoImage.clipsToBounds = YES;
    self.photoImage.layer.cornerRadius = 20;
    self.photoImage.layer.borderWidth = 0.5;
    self.photoImage.layer.borderColor = _COLOR(0xe6, 0xe6, 0xe6).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
