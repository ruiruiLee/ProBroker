//
//  BaseTableViewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/5.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "define.h"

@implementation BaseTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        [self awakeFromNib];
    }
    
    return self;
}


- (void) awakeFromNib
{
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = _COLORa(239, 239, 239, 0.3);
}

@end
