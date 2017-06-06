//
//  HSepView.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/29.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "HSepView.h"
#import "define.h"

@implementation HSepView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    CGContextRef ctx=UIGraphicsGetCurrentContext();
//    //绘图
//    //第一条线
//    CGPoint begin = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + 20);
//    CGContextMoveToPoint(ctx, begin.x, begin.y);
//    CGContextAddLineToPoint(ctx, begin.x, rect.size.height - 20);
//
//    //设置第一条线的状态
//    //设置线条的宽度
//    CGContextSetLineWidth(ctx, 0.3);
//    //设置线条的颜色
//    [SepLineColor set];
//    //设置线条两端的样式为圆角
//    CGContextSetLineCap(ctx,kCGLineCapRound);
//    //对线条进行渲染
//    CGContextStrokePath(ctx);
//
//    //第二条线
////    CGContextMoveToPoint(ctx, 40, 200);
////    CGContextAddLineToPoint(ctx, 80, 100);
//    //渲染
//    CGContextStrokePath(ctx);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, SepLineColor.CGColor);
    CGContextFillRect(context, CGRectMake(CGRectGetWidth(self.frame)/2, 14, 0.6, CGRectGetHeight(self.frame) - 28));
    
}


@end
