//
//  MotorcycleTypeSelectedVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseViewController.h"

@class MotorcycleTypeSelectedVC;

@protocol MotorcycleTypeSelectedVCDelegate <NSObject>

- (void) NotifySelected:(MotorcycleTypeSelectedVC *) vc result:(NSString *) result;

@end

@interface MotorcycleTypeSelectedVC : BaseViewController

@property (nonatomic, weak) id<MotorcycleTypeSelectedVCDelegate> delegate;

@end
