//
//  MyTeamsVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/31.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BasePullTableVC.h"

typedef enum : NSUInteger {
    enumNotNeedIndicator,
    enumNeedIndicator,
} needIndicator;

@interface MyTeamsVC : BasePullTableVC

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *toptitle;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) needIndicator need;

@end
