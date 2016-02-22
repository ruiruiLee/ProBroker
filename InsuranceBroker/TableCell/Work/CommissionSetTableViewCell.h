//
//  CommissionSetTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/19.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommissionSetTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lbAccount;
@property (nonatomic, strong) IBOutlet UILabel *lbDetail;
@property (nonatomic, strong) IBOutlet UIImageView *logo;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit;;

@end
