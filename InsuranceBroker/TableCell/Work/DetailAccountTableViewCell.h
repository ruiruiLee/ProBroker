//
//  DetailAccountTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/12.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface DetailAccountTableViewCell : BaseTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lbDate;
@property (nonatomic, strong) IBOutlet UILabel *lbTime;
@property (nonatomic, strong) IBOutlet UILabel *lbTypeName;
@property (nonatomic, strong) IBOutlet UILabel *lbAccount;
@property (nonatomic, strong) IBOutlet UILabel *lbDetail;
@property (nonatomic, strong) IBOutlet UIImageView *logo;

@end
