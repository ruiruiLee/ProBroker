//
//  CarListTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/9/12.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighNightBgButton.h"

@interface CarListTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet HighNightBgButton *btnSelected;
@property (nonatomic, strong) IBOutlet UILabel *lbCarNu;//车牌
@property (nonatomic, strong) IBOutlet UIImageView *imgLisence;

@end
