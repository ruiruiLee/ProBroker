//
//  TeamListTableViewCell.m
//  
//
//  Created by LiuZach on 16/3/17.
//
//

#import "TeamListTableViewCell.h"
#import "define.h"

@implementation TeamListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.lbName.textColor = _COLOR(0x21, 0x21, 0x21);
    self.lbStatus.textColor = _COLOR(0x46, 0xa6, 0xeb);
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
