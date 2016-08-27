//
//  ProductListViewController.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/27.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BasePullTableVC.h"
#import "THSegmentedPageViewControllerDelegate.h"

@interface ProductListViewController : BasePullTableVC<THSegmentedPageViewControllerDelegate>

@property(nonatomic,strong)NSString *viewTitle;

@property (nonatomic, strong) NSString *category;

@property (nonatomic, weak) UIViewController *parentvc;

@property (nonatomic, strong) NetWorkHandler *handler;

//@property (nonatomic, assign) id<BaseStrategyViewDelegate> delegate;

@end
