//
//  ServiceSelectView.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/9.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ServiceSelectView.h"
#import "define.h"
#import "SepLineLabel.h"

@implementation ServiceSelectView
@synthesize lbServiceTime;

- (id) initWithImageArray:(NSArray *)images nameArray:(NSArray *)names
{
    self = [super initWithImageArray:images nameArray:names];
    if(self){
        lbServiceTime = [ViewFactory CreateLabelViewWithFont:_FONT(13) TextColor:_COLOR(0x75, 0x75, 0x75)];
        [self.bgView addSubview:lbServiceTime];
        lbServiceTime.text = @"客服在线时间：工作日9:30-18:00";
        lbServiceTime.textAlignment = NSTextAlignmentCenter;
        
        SepLineLabel *line = [[SepLineLabel alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:line];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIButton *btn = self.btnCancel;
        NSDictionary *views = NSDictionaryOfVariableBindings(btn, lbServiceTime, line);
        [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[line(1)]-6-[lbServiceTime(14)]-10-[btn]->=0-|" options:0 metrics:nil views:views]];
        [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbServiceTime]-20-|" options:0 metrics:nil views:views]];
        [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[line]-0-|" options:0 metrics:nil views:views]];
    }
    
    return self;
}

@end
