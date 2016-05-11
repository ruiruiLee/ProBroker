//
//  DashSepLineView.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/9.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "DashSepLineView.h"
#import "define.h"

@implementation DashSepLineView

-(void) awakeFromNib
{
    self.clipsToBounds = YES;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if(!shapeLayer)
        shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[UIColor whiteColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:SepLineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:8], [NSNumber numberWithInt:4], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, CGRectGetHeight(self.frame)-0.5);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-0.5);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
}


@end
