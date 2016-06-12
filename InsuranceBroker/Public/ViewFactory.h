//
//  ViewFactory.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/16.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighNightBgButton.h"
#import "InfoTipsView.h"
#import "SepLineButton.h"

@interface ViewFactory : NSObject

/**
 标准化生成UILabel
 */
+ (UILabel *) CreateLabelViewWithFont:(UIFont *) font TextColor:(UIColor *)color;

/**
 标准化生成UIButton
 */
+ (HighNightBgButton *) CreateButtonWithzFont:(UIFont *) font TextColor:(UIColor *)color image:(UIImage *) image;

+ (HighNightBgButton *) CreateButtonWithImage:(UIImage *) image;

/**
 标准化view
 */

+ (UIView *) CreateView;

@end
