//
//  ProductRadioModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/5.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "ProductRadioModel.h"

@implementation ProductRadioModel

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    ProductRadioModel *model = [[ProductRadioModel alloc] init];
    
    model.productId = [dictionary objectForKey:@"productId"];
    model.productLogo = [dictionary objectForKey:@"productLogo"];
    model.productMaxRatio = [dictionary objectForKey:@"productMaxRatio"];
    model.productMinRatio = [dictionary objectForKey:@"productMinRatio"];
    model.productName = [dictionary objectForKey:@"productName"];
    
    return model;
}

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[ProductRadioModel modelFromDictionary:dic]];
    }
    
    return result;
}

@end
