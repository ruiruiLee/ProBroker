//
//  ProvienceSelectedView.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/26.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProvienceSelectedView;

@protocol ProvienceSelectedViewDelegate <NSObject>

- (void) NotifySelectedProvienceName:(NSString *) name view:(ProvienceSelectedView *) view;

@end

@interface ProvienceSelectedView : UIView
{
    NSArray *titleArray;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, weak) id<ProvienceSelectedViewDelegate> delegate;

- (void) show;

- (void) hidden;

@end
