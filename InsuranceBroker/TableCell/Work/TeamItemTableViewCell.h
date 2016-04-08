//
//  TeamItemTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/8.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

//我的团长
@interface TeamItemTableViewCell : BaseTableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *photoImage;
@property (nonatomic, strong) IBOutlet UIImageView *logoImage;
@property (nonatomic, strong) IBOutlet UILabel *lbName;
@property (nonatomic, strong) IBOutlet UILabel *lbStatus;

@end
