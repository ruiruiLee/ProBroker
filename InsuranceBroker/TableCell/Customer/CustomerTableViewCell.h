//
//  CustomerTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/21.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBImageViewList.h"
#import "BaseTableViewCell.h"

@interface CustomerTableViewCell : BaseTableViewCell
{
    HBImageViewList *_imageList;
}

@property (nonatomic, strong) IBOutlet UIImageView *photoImage;
@property (nonatomic, strong) IBOutlet UIImageView *logoImage;
@property (nonatomic, strong) IBOutlet UILabel *lbName;
@property (nonatomic, strong) IBOutlet UILabel *lbStatus;
@property (nonatomic, strong) IBOutlet UILabel *lbTimr;
@property (nonatomic, strong) IBOutlet UIButton *btnApply;
@property (nonatomic, strong) IBOutlet UIButton *btnShowImage;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *width;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *height;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *timerWidth;

@property (nonatomic, strong) IBOutlet NSString *headImg;

@end
