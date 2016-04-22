//
//  SepLineLabel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/11.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "SepLineLabel.h"
#import "define.h"

@implementation SepLineLabel

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, SepLineColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) / 2, CGRectGetWidth(self.frame), 0.5));
    CGContextFillRect(context, CGRectMake(CGRectGetWidth(self.frame)/2, 0, 0.5, CGRectGetHeight(self.frame)));
}

@end
