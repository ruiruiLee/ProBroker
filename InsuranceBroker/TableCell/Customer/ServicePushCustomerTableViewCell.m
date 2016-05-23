//
//  ServicePushCustomerTableViewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/20.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ServicePushCustomerTableViewCell.h"
#import "define.h"

@implementation ServicePushCustomerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.btnApply.layer.cornerRadius = 3;
    self.logoImageV.layer.borderWidth = 0.5;
    self.logoImageV.layer.borderColor = _COLOR(0xe6, 0xe6, 0xe6).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCustomerFrom:(enumCustomerFrom) type
{
    
}

@end
