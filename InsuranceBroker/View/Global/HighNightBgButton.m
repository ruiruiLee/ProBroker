//
//  HighNightBgButton.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/5.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "HighNightBgButton.h"
#import "define.h"

@implementation HighNightBgButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self awakeFromNib];
    }
    
    return self;
}

- (void) awakeFromNib
{
    _mask = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_mask];
    _mask.translatesAutoresizingMaskIntoConstraints = NO;
    _mask.backgroundColor = MaskColor;
    _mask.userInteractionEnabled = YES;
    _mask.hidden = YES;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_mask);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mask]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mask]-0-|" options:0 metrics:nil views:views]];
}

- (void) setHighlighted:(BOOL)highlighted {
    //    [super setHighlighted:highlighted];
    
    if (highlighted) {
        _mask.hidden = NO;
    }
    else {
        _mask.hidden = YES;
    }
}

@end
