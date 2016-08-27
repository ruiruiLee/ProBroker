//
//  THSegmentedPager.h
//  THSegmentedPagerExample
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "BaseViewController.h"

@interface THSegmentedPager : BaseViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) HMSegmentedControl *pageControl;
@property (strong, nonatomic) UIView *contentContainer;

@property (strong, nonatomic)NSMutableArray *pages;

@property (nonatomic, strong) NSArray *dataList;

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;

- (UIViewController *)selectedController;

- (void)updateTitleLabels;

- (void) loadData;

@end
