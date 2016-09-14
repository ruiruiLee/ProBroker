//
//  OrderManagerVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/28.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BasePullTableVC.h"
#import "THSegmentedPageViewControllerDelegate.h"

@interface OrderManagerVC : BasePullTableVC <THSegmentedPageViewControllerDelegate>

@property (nonatomic, strong) UISearchBar *searchbar;
@property (nonatomic, strong) NSString *filterString;
@property(nonatomic,strong)NSString *viewTitle;

@property (nonatomic, strong) NSString *insuranceType;

@property (assign, nonatomic) NSInteger currentMapTypeIndex;
@property (strong, nonatomic) NSArray *mapTypes;

- (void) initMapTypesForCar;
- (void) initMapTypesForNoCar;

@end
