//
//  DeatilTextTableviewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/28.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface DeatilTextTableviewCell : BaseTableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *photoImgV;
@property (nonatomic, strong) IBOutlet UILabel *lbTitle;
@property (nonatomic, strong) IBOutlet UILabel *lbDetailTitle;

@end
