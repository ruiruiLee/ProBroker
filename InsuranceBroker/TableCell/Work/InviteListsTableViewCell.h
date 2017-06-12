//
//  InviteListsTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/12.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface InviteListsTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *photoImage;
@property (nonatomic, strong) IBOutlet UILabel *lbName;
@property (nonatomic, strong) IBOutlet UILabel *lbPhone;

@end
