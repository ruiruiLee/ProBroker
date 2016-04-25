//
//  LightMenuBarView.h
//  LightMenuBar
//
//  Created by Haoxiang on 6/10/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LightMenuBar;
@protocol LightMenuBarDelegate;

@interface LightMenuBarView : UIView {

    NSUInteger _selectedItemIndex;
    
    //< Parameters
    NSUInteger itemCount;
    
    CGFloat vPadding;
    CGFloat hPadding;
    CGFloat backgroundRad;
    CGFloat buttonRad;
    CGFloat sepWidth;
    CGFloat sepHeightRate;
    
    UIColor *backgoundColor;
    UIColor *buttonHighlightColor;
    UIColor *titleHighlightColor;
    UIColor *titleNormalColor;
    UIColor *sepColor;
    
    BOOL autoWidth;
    CGFloat averWidth;
    CGRect bkgrdRect;
    
//    int barAnimation;
}

@property (nonatomic, assign) LightMenuBar *menuBar;
@property (nonatomic, assign) NSUInteger selectedItemIndex;
@property (nonatomic, assign) id<LightMenuBarDelegate> delegate;
@property (nonatomic, strong) UIFont *titleFont;

- (CGFloat)barLength;
- (void)fillParams;
- (void)render;
- (void)blink;

- (CGFloat)getCenterOfItemAtIndex:(NSInteger)index;

@end
