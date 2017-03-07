//
//  productAttrModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "productAttrModel.h"

@implementation productAttrModel

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[productAttrModel modelFromDictionary:dic]];
    }
    
    return result;
}

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    productAttrModel *model = [[productAttrModel alloc] init];
    model.productStatus = [dictionary objectForKey:@"productStatus"];
    model.clickAddr = [dictionary objectForKey:@"clickAddr"];
    model.insuranceType = [dictionary objectForKey:@"insuranceType"];
    model.insuranceTypeName = [dictionary objectForKey:@"insuranceTypeName"];
    model.productSellNums = [dictionary objectForKey:@"productSellNums"];
    model.productLogo = [dictionary objectForKey:@"productLogo"];
    model.productIntro = [dictionary objectForKey:@"productIntro"];
    model.productName = [dictionary objectForKey:@"productName"];
    model.seqNo = [dictionary objectForKey:@"seqNo"];
    model.showPrice = [dictionary objectForKey:@"showPrice"];
    model.productMaxRatio = [dictionary objectForKey:@"productMaxRatio"];
    model.compCode = [dictionary objectForKey:@"compCode"];
    model.uniqueFlag = [dictionary objectForKey:@"uniqueFlag"];
    model.productId = [dictionary objectForKey:@"productId"];
    
    return model;
}

@end
