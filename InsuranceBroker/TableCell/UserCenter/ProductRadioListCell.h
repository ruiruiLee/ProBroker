//
//  ProductRadioListCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/5.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ProductRadioListCell : BaseTableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *productLogo;
@property (nonatomic, strong) IBOutlet UILabel *productName;
@property (nonatomic, strong) IBOutlet UILabel *productRadio;

@end
