//
//  SelectCustomerVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BasePullTableVC.h"

@class SelectCustomerVC;
@class CustomerDetailModel;

@protocol SelectCustomerVCDelegate <NSObject>

- (void) NotifyCustomerSelectedWithModel:(CustomerDetailModel *) model vc:(SelectCustomerVC *) vc;

@end

@interface SelectCustomerVC : BasePullTableVC<UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) UISearchBar *searchbar;
@property (nonatomic, weak) id<SelectCustomerVCDelegate> delegate;

@end
