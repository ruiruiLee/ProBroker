//
//  InsureInfoListTableViewCell.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@class InsureInfoListTableViewCell;

@protocol InsureInfoListTableViewCellDelegate <NSObject>

- (void) NotifySelectedAtIndex:(NSInteger) idx cell:(InsureInfoListTableViewCell *) cell;

@end

@interface InsureInfoListTableViewCell : BaseTableViewCell

@property (nonatomic, strong) IBOutlet UIButton *btnSelected;//设置tag,tag = index + 100
@property (nonatomic, weak) id<InsureInfoListTableViewCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *lbName;
@property (nonatomic, strong) IBOutlet UILabel *lbRelation;

@end
