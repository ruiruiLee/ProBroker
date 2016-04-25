//
//  ProductListTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface ProductListTableViewCell : BaseTableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *logoImage;
@property (nonatomic, strong) IBOutlet UILabel *lbTitle;
@property (nonatomic, strong) IBOutlet UILabel *lbContent;
@property (nonatomic, strong) IBOutlet UILabel *lbPrice;
@property (nonatomic, strong) IBOutlet UILabel *lbCount;

@end
