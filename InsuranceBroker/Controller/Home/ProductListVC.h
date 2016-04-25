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

@end
