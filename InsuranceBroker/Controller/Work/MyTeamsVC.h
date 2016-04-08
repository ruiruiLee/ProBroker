//
//  MyTeamsVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/31.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BasePullTableVC.h"
#import "RatioMapsModel.h"

@interface MyTeamsVC : BasePullTableVC

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *toptitle;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) UILabel *lbMonth;
@property (nonatomic, strong) UILabel *lbDay;
@property (nonatomic, strong) UILabel *lbUpdateTime;

@property (nonatomic, strong) RatioMapsModel *teamInfo;

- (NSDictionary *) getRulesByField:(NSString *) field op:(NSString *) op data:(NSString *) data;

- (void) initHeaderView;

- (NSAttributedString *) getOrderDetailString:(CGFloat) amount orderValue:(CGFloat) orderValue;

- (NSAttributedString *) getOrderAmount:(NSInteger) insure offer:(NSInteger) offer;

- (UIView *) createTeamTotalInfo;

@end
