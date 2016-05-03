//
//  UITabBar+badge.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/3.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
