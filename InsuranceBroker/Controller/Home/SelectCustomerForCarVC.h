//
//  SelectCustomerForCarVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/6/4.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BasePullTableVC.h"

@class SelectCustomerForCarVC;
@class CustomerDetailModel;

@protocol SelectCustomerForCarVCDelegate <NSObject>

- (void) NotifyCustomerSelectedWithModel:(CustomerDetailModel *) model vc:(SelectCustomerForCarVC *) vc;

@end

@interface SelectCustomerForCarVC : BasePullTableVC < UISearchBarDelegate, UISearchDisplayDelegate >
@property (nonatomic, strong) UISearchBar *searchbar;
@property (nonatomic, weak) id<SelectCustomerForCarVCDelegate> delegate;

@property (nonatomic, strong) NSString *selectProductId;

@end
