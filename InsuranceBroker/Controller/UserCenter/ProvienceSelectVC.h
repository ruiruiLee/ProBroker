//
//  ProvienceSelectVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "AreaSelectedVC.h"
#import "SelectAreaModel.h"
#import "CustomerInfoEditVC.h"

@interface ProvienceSelectVC : AreaSelectedVC

@property (nonatomic, strong) SelectAreaModel *selectArea;
@property (nonatomic, weak) CustomerInfoEditVC *_edit;

@end
