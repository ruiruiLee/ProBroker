//
//  MyTeamInfoVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "MyTeamsVC.h"
#import "BackGroundView.h"

@interface MyTeamInfoVC : MyTeamsVC<BackGroundViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong)  BackGroundView *addview;

@property (nonatomic, strong)  UISearchBar *searchbar;

@end
