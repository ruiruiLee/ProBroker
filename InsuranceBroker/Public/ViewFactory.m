//
//  ViewFactory.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/16.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "ViewFactory.h"

@implementation ViewFactory

+ (UILabel *) CreateLabelViewWithFont:(UIFont *) font TextColor:(UIColor *)color
{
    UILabel *lb = [[UILabel alloc] init];
    
    lb.textColor = color;
    
    lb.font = font;
    
    lb.backgroundColor = [UIColor clearColor];
    
    lb.translatesAutoresizingMaskIntoConstraints = NO;
    
    return lb;
}

+ (HighNightBgButton *) CreateButtonWithzFont:(UIFont *) font TextColor:(UIColor *)color image:(UIImage *) image
{
    HighNightBgButton *btn = [[HighNightBgButton alloc] initWithFrame:CGRectZero];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    btn.backgroundColor = [UIColor whiteColor];
    
    return btn;
}

+ (HighNightBgButton *) CreateButtonWithImage:(UIImage *) image
{
    HighNightBgButton *btn = [[HighNightBgButton alloc] initWithFrame:CGRectZero];
    btn.backgroundColor = [UIColor whiteColor];
//    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    return btn;
}

+ (UIView *) CreateView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
