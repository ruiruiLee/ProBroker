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
    model.attrStatus = [dictionary objectForKey:@"attrStatus"];
    model.clickAddr = [dictionary objectForKey:@"clickAddr"];
    model.insuranceType = [dictionary objectForKey:@"insuranceType"];
    model.productAttrId = [dictionary objectForKey:@"productAttrId"];
    model.productSellNums = [dictionary objectForKey:@"productSellNums"];
    model.productImg = [dictionary objectForKey:@"productImg"];
    model.productIntro = [dictionary objectForKey:@"productIntro"];
    model.productTitle = [dictionary objectForKey:@"productTitle"];
    model.seqNo = [dictionary objectForKey:@"seqNo"];
    model.showPrice = [dictionary objectForKey:@"showPrice"];
    model.productMaxRatio = [dictionary objectForKey:@"productMaxRatio"];
    
    return model;
}

@end
