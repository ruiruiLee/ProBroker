//
//  AgentStrategyViewController.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/12.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BasePullTableVC.h"
#import "AnnouncementModel.h"


@interface AgentStrategyViewController : BasePullTableVC

@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) UIButton *bannerImageView;

@property (nonatomic, strong) AnnouncementModel *totalModel;

@end
