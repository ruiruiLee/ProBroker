//
//  UINavigationBar+HitTest.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/3/9.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "UINavigationBar+HitTest.h"

@implementation UINavigationBar (HitTest)

// 在自定义UITabBar中重写以下方法，其中self.button就是那个希望被触发点击事件的按钮
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    for (int i = 0; i < [self.subviews count]; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        view = [view hitTest:point withEvent:event];
        if(view)
            return view;
    }
    return view;
}

@end
