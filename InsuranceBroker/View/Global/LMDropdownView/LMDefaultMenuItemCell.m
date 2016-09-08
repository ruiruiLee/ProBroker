//
//  LMItemViewCell.m
//  LMDropdownView
//
//  Created by LMinh on 16/07/2014.
//  Copyright (c) Năm 2014 LMinh. All rights reserved.
//

#import "LMDefaultMenuItemCell.h"
#import "define.h"

@implementation LMDefaultMenuItemCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.menuItemLabel.backgroundColor = _COLOR(0xff, 0x66, 0x19);//[UIColor colorWithRed:81.0/255 green:168.0/255 blue:101.0/255 alpha:1];
    }
    else {
        self.menuItemLabel.backgroundColor = _COLORa(220, 220, 220, 1);//[UIColor colorWithRed:40.0/255 green:196.0/255 blue:80.0/255 alpha:1];
    }
}

@end


