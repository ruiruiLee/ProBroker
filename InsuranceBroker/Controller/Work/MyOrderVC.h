//
//  MyOrderVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/9/7.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"
#import "HMSegmentedControl.h"

#import "LMDropdownView.h"
#import "MyPageViewController.h"


@class OrderManagerVC;

@interface MyOrderVC : BaseViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    UIViewController *_currentVC;
    
    OrderManagerVC *_firstVC;
    OrderManagerVC *_secondVC;
}

@property (strong, nonatomic)NSMutableArray *pages;
@property (strong, nonatomic) HMSegmentedControl *pageControl;
@property (strong, nonatomic) UIView *contentContainer;

//@property (strong, nonatomic)MyPageViewController *pageViewController;

@property (strong, nonatomic) UITableView *menuTableView;
@property (strong, nonatomic) LMDropdownView *dropdownView;

- (void) initMenus;

@end
