//
//  ProductInfoModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/19.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ProductInfoModel.h"

@implementation ProductInfoModel

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[ProductInfoModel modelFromDictionary:dic]];
    }
    
    return result;
}

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    ProductInfoModel *model = [[ProductInfoModel alloc] init];
    
    model.productRatio = [[dictionary objectForKey:@"productRatio"] floatValue];
    model.productMinRatio = [[dictionary objectForKey:@"productMinRatio"] floatValue];
    model.productLogo = [dictionary objectForKey:@"productLogo"];
    model.productMaxRatio = [[dictionary objectForKey:@"productMaxRatio"] floatValue];
    model.productName = [dictionary objectForKey:@"productName"];
    model.productId = [dictionary objectForKey:@"productId"];
    
    return model;
}

@end
