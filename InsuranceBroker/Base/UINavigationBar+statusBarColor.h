//
//  UINavigationBar+statusBarColor.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/22.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (statusBarColor)

@property (nonatomic, strong, setter = setStatusBarColor:, getter=statusBarColor) UIColor * statusBarColor;

@end
