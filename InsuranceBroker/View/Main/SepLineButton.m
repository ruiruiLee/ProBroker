//
//  SepLineButton.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/22.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "SepLineButton.h"
#import "define.h"

@implementation SepLineButton

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self awakeFromNib];
    }
    
    return self;
}

- (void) awakeFromNib
{
    _left = NO;
    _right = NO;
    _top = NO;
    _bottom = NO;
}

- (void) setSepLineType:(BOOL) left right:(BOOL) right top:(BOOL) top bottom:(BOOL) bottom
{
    _left = left;
    _right = right;
    _top = top;
    _bottom = bottom;
    
    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
    if(_left){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, SepLineColor.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, 0.5, CGRectGetHeight(self.frame)));
    }
    
    if(_top){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, SepLineColor.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5));
    }
    
    if(_right){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, SepLineColor.CGColor);
        CGContextFillRect(context, CGRectMake(CGRectGetWidth(self.frame)-0.5, 0, 0.5, CGRectGetHeight(self.frame)));
    }
    
    if(_bottom){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, SepLineColor.CGColor);
        CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, 0.5, CGRectGetHeight(self.frame)));
    }
}

@end
