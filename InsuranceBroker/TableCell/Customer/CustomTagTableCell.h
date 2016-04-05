//
//  CustomTagTableCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface CustomTagTableCell : BaseTableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *photoImage;
@property (nonatomic, strong) IBOutlet UILabel *lbTitle;
@property (nonatomic, strong) IBOutlet UILabel *lbCount;

@end
