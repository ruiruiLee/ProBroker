//
//  TeamListTableViewCell.h
//  
//
//  Created by LiuZach on 16/3/17.
//
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface TeamListTableViewCell : BaseTableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *photoImage;
@property (nonatomic, strong) IBOutlet UIImageView *logoImage;
@property (nonatomic, strong) IBOutlet UILabel *lbName;
@property (nonatomic, strong) IBOutlet UILabel *lbStatus;
@property (nonatomic, strong) IBOutlet UIButton *btnRemark;

@end
