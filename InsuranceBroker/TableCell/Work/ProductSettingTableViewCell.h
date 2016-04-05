//
//  ProductSettingTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/26.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface ProductSettingTableViewCell : BaseTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lbAccount;
@property (nonatomic, strong) IBOutlet UILabel *lbDetail;
@property (nonatomic, strong) IBOutlet UIImageView *logo;

@end
