//
//  InsuranceTableViewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/25.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "InsuranceTableViewCell.h"

@implementation InsuranceTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.imgV1.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imgV2.imageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
