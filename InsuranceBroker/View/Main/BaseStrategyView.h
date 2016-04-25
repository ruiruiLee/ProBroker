//
//  BaseStrategyView.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/13.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"

#import "NetWorkHandler.h"

@interface BaseStrategyView : UIView <PullTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) PullTableView *pulltable;
@property (nonatomic, assign) NSInteger pageNum;//当前第几页
@property (nonatomic, assign) NSInteger total;//数据总条数
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) UIView *explainBgView;
@property (nonatomic, strong) UIImageView *imgWithNoData;

//约束
@property (nonatomic, strong) NSArray *hConstraints;
@property (nonatomic, strong) NSArray *vConstraints;

@property (nonatomic, weak) UIViewController *parentvc;

@property (nonatomic, strong) NetWorkHandler *handler;

- (void) initSubViews;

- (void) loadDataInPages:(NSInteger) page;

- (void) refreshTable;
- (void) loadMoreDataToTable;

//- (id) initWithFrame:(CGRect)frame Strategy:(NSString *) Strategy;

- (void) refreshAndReloadData:(NSString *) category list:(NSMutableArray *) list;

@end
