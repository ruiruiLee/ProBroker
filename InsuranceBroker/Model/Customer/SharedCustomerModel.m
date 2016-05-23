//
//  SharedCustomerModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/20.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "SharedCustomerModel.h"

@implementation SharedCustomerModel

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[SharedCustomerModel modelFromDictionary:dic]];
    }
    
    return result;
}

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    SharedCustomerModel *model = [[SharedCustomerModel alloc] init];
    
    [model updateModelWithDictionary:dictionary];
    
    return model;
}

- (void) updateModelWithDictionary:(NSDictionary *) dictionary
{
    self.cooperationImg = [dictionary objectForKey:@"cooperationImg"];
    self.cooperationSource = [dictionary objectForKey:@"cooperationSource"];
    self.phone = [dictionary objectForKey:@"phone"];
    self.brokerId = [dictionary objectForKey:@"brokerId"];
    self.name = [dictionary objectForKey:@"name"];
    self.appType = [dictionary objectForKey:@"appType"];
    self.flag = [[dictionary objectForKey:@"flag"] boolValue];
    self.uuid = [dictionary objectForKey:@"uuid"];
    self.headerUrl = [dictionary objectForKey:@"headerUrl"];
    self.shareSource = [dictionary objectForKey:@"shareSource"];
    self.objectId = [dictionary objectForKey:@"objectId"];
    self.shareImg = [dictionary objectForKey:@"shareImg"];
    self.provence = [dictionary objectForKey:@"provence"];
    self.city = [dictionary objectForKey:@"city"];
    self.createdAt = [BaseModel dateFromInteger:[[dictionary objectForKey:@"createdAt"] longLongValue]];
}


@end
