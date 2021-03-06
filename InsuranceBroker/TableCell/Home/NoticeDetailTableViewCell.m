//
//  NoticeDetailTableViewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/30.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "NoticeDetailTableViewCell.h"
#import "define.h"

@implementation NoticeDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.lbContent.numberOfLines = 0;
    self.lbContent.preferredMaxLayoutWidth = ScreenWidth - 40;
    self.clipsToBounds = YES;
    self.btnDetail.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
