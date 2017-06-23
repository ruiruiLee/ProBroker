//
//  RedMoneyModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/16.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "RedMoneyModel.h"

@implementation RedMoneyModel

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[RedMoneyModel modelFromDictionary:dic]];
    }
    
    return result;
}

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    RedMoneyModel *model = [[RedMoneyModel alloc] init];
    [model setContentFromDictionary:dictionary];
    return model;
}

- (id) init
{
    self = [super init];
    if(self){
        self.status = 0;
    }
    
    return self;
}

- (void) setContentFromDictionary:(NSDictionary *)dictionary
{
    
    self.status = [[dictionary objectForKey:@"status"] integerValue];
    self.carNo = [dictionary objectForKey:@"carNo"];
    self.memo = [dictionary objectForKey:@"memo"];
    self.createdAt = [BaseModel dateFromString:[dictionary objectForKey:@"createdAt"]];//[dictionary objectForKey:@"createdAt"];
    self.money = [dictionary objectForKey:@"money"];
    self.updatedAt = [BaseModel dateFromString:[dictionary objectForKey:@"updatedAt"]];//[dictionary objectForKey:@"updatedAt"];
    self.operatId = [dictionary objectForKey:@"operatId"];
    self.operatName = [dictionary objectForKey:@"operatName"];
    self.userId = [dictionary objectForKey:@"userId"];
    self.orderNo = [dictionary objectForKey:@"orderNo"];
    self.orderUuId = [dictionary objectForKey:@"orderUuId"];
    self.userMoneyLogId = [dictionary objectForKey:@"userMoneyLogId"];
    self.beforeMoney = [dictionary objectForKey:@"beforeMoney"];
    self.afterMoney = [dictionary objectForKey:@"afterMoney"];
}


@end
