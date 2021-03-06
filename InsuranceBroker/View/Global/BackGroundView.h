//
//  BackGroundView.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/20.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BackGroundView;
#import "HighNightBgButton.h"

@protocol BackGroundViewDelegate <NSObject>

- (void) notifyToAddNewCustomer:(BackGroundView *) view;

@end

@interface BackGroundView : UIView

@property (nonatomic, strong) IBOutlet HighNightBgButton *btnAdd;
@property (nonatomic, strong) IBOutlet UILabel *lbTitle;
@property (nonatomic, assign) id<BackGroundViewDelegate> delegate;


//+ (id) loadFromNib;

@end
