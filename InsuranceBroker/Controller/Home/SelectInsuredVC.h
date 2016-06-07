//
//  SelectInsuredVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/26.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BasePullTableVC.h"

@class InsuredUserInfoModel;
@class SelectInsuredVC;

@protocol SelectInsuredVCDelegate <NSObject>

- (void) NotifyInsuredSelectedWithModel:(InsuredUserInfoModel *) model vc:(SelectInsuredVC *) vc;

@end

@interface SelectInsuredVC : BasePullTableVC
{
    NSString *_insuredId;
}

@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, weak) id<SelectInsuredVCDelegate> delegate;

- (void) setSelectedInsuredId:(NSString *) insuredId;

@end
