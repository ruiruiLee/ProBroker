//
//  SellInfoModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/9/28.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "SellInfoModel.h"

@implementation SellInfoModel

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    SellInfoModel *model = [[SellInfoModel alloc] init];
    
    model.JiaoQiangXianBaoFei = [dictionary objectForKey:@"JiaoQiangXianBaoFei"];
    if(model.JiaoQiangXianBaoFei == nil)
        model.JiaoQiangXianBaoFei = @"0";
    model.JiaoQiangXianJingBaoFei = [dictionary objectForKey:@"JiaoQiangXianJingBaoFei"];
    if(model.JiaoQiangXianJingBaoFei == nil)
        model.JiaoQiangXianJingBaoFei = @"0";
    model.cheChuanSuiBaoFei = [dictionary objectForKey:@"cheChuanSuiBaoFei"];
    if(model.cheChuanSuiBaoFei == nil)
        model.cheChuanSuiBaoFei = @"0";
    model.cheXianCount = [[dictionary objectForKey:@"cheXianCount"] integerValue];
    model.geXianBaoFei = [dictionary objectForKey:@"geXianBaoFei"];
    if(model.geXianBaoFei == nil)
        model.geXianBaoFei = @"0";
    model.geXianCount = [[dictionary objectForKey:@"geXianCount"] integerValue];
    model.jingBaoFei = [dictionary objectForKey:@"jingBaoFei"];
    if(model.jingBaoFei == nil)
        model.jingBaoFei = @"0";
    model.shangYeXianBaoFei = [dictionary objectForKey:@"shangYeXianBaoFei"];
    if(model.shangYeXianBaoFei == nil)
        model.shangYeXianBaoFei = @"0";
    model.shangYeXianJingBaoFei = [dictionary objectForKey:@"shangYeXianJingBaoFei"];
    if(model.shangYeXianJingBaoFei == nil)
        model.shangYeXianJingBaoFei = @"0";
    model.zongBaoFei = [dictionary objectForKey:@"zongBaoFei"];
    if(model.zongBaoFei == nil)
        model.zongBaoFei = @"0";
    
    return model;
}

@end
