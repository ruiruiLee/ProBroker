//
//  BaseLineView.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/14.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseLineView.h"
#import "define.h"

@implementation BaseLineView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, SepLineColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}

@end
