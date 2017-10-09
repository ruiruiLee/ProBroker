//
//  SellInfoModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/9/28.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface SellInfoModel : BaseModel

@property (nonatomic, strong) NSString * JiaoQiangXianBaoFei;
@property (nonatomic, strong) NSString * JiaoQiangXianJingBaoFei;
@property (nonatomic, strong) NSString * cheChuanSuiBaoFei;
@property (nonatomic, assign) NSInteger cheXianCount;
@property (nonatomic, strong) NSString * geXianBaoFei;
@property (nonatomic, assign) NSInteger geXianCount;
@property (nonatomic, strong) NSString * jingBaoFei;
@property (nonatomic, strong) NSString * shangYeXianBaoFei;
@property (nonatomic, strong) NSString * shangYeXianJingBaoFei;
@property (nonatomic, strong) NSString *zongBaoFei;

@end
