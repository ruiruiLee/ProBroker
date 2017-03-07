//
//  SalesTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/1/13.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *logoImage;
@property (nonatomic, strong) IBOutlet UILabel *lbTitle;
@property (nonatomic, strong) IBOutlet UILabel *lbContent;
@property (nonatomic, strong) IBOutlet UILabel *lbPrice;
@property (nonatomic, strong) IBOutlet UILabel *lbCount;
@property (nonatomic, strong) IBOutlet UILabel *lbRate;

@end
