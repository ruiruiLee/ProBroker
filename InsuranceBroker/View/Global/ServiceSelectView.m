//
//  ServiceSelectView.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/9.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ServiceSelectView.h"
#import "define.h"

@implementation ServiceSelectView
@synthesize lbServiceTime;

- (id) initWithImageArray:(NSArray *)images nameArray:(NSArray *)names
{
    self = [super initWithImageArray:images nameArray:names];
    if(self){
        lbServiceTime = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0x75, 0x75, 0x75)];
        [self.bgView addSubview:lbServiceTime];
        lbServiceTime.text = @"客服在线时间：工作日9:30-18:30";
        
        UIButton *btn = self.btnCancel;
        NSDictionary *views = NSDictionaryOfVariableBindings(btn, lbServiceTime);
        [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[lbServiceTime(14)]-10-[btn]->=0-|" options:0 metrics:nil views:views]];
        [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbServiceTime]-20-|" options:0 metrics:nil views:views]];
    }
    
    return self;
}

@end
