//
//  CarAddInfoTableCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/14.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface CarAddInfoTableCell : BaseTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lbTitle;
@property (nonatomic, strong) IBOutlet UILabel *lbDetail;

@end
