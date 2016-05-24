//
//  ProductListVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/19.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BasePullTableVC.h"
#import "LightMenuBar.h"
#import "LightMenuBarDelegate.h"
#import "LightMenuBarView.h"
#import "BaseStrategyView.h"

@interface ProductListVC : BaseViewController <LightMenuBarDelegate>

@property (nonatomic, strong) BaseStrategyView *contentView;

- (void) loadData;//直接获取所有的产品
- (void) loadDataWithLimitVal;//获取除车险外的其他产品

@end
