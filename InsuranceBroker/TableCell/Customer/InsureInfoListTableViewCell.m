//
//  InsureInfoListTableViewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "InsureInfoListTableViewCell.h"
#import "define.h"

@implementation InsureInfoListTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
    [self.btnSelected setImage:ThemeImage(@"unselect") forState:UIControlStateNormal];
    [self.btnSelected setImage:ThemeImage(@"select") forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)doBtnSelected:(UIButton *)sender
{
    if(!sender.selected && delegate && [delegate respondsToSelector:@selector(NotifySelectedAtIndex:cell:)]){
        [delegate NotifySelectedAtIndex:self.btnSelected.tag - 100 cell:self];
    }
}

@end
