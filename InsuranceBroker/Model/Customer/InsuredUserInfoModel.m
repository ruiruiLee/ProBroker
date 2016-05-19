//
//  InsuredUserInfoModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "InsuredUserInfoModel.h"

@implementation InsuredUserInfoModel

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[InsuredUserInfoModel modelFromDictionary:dic]];
    }
    
    return result;
}

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    InsuredUserInfoModel *model = [[InsuredUserInfoModel alloc] init];
    
    [model updateModelWithDictionary:dictionary];
    
    return model;
}

- (void) updateModelWithDictionary:(NSDictionary *) dictionary
{
    self.cardNumber = [[dictionary objectForKey:@"cardNumber"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.createdAt = [BaseModel dateFromString:[dictionary objectForKey:@"createdAt"]];
    self.customerId = [dictionary objectForKey:@"customerId"];
    self.insuredEmail = [dictionary objectForKey:@"insuredEmail"];
    self.insuredId = [dictionary objectForKey:@"insuredId"];
    self.insuredMemo = [dictionary objectForKey:@"insuredMemo"];
    self.insuredName = [dictionary objectForKey:@"insuredName"];
    self.insuredPhone = [[dictionary objectForKey:@"insuredPhone"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.liveAddr = [dictionary objectForKey:@"liveAddr"];
    self.insuredSex = [[dictionary objectForKey:@"insuredSex"] integerValue];
    self.insuredStatus = [[dictionary objectForKey:@"insuredStatus"] integerValue];
    self.liveAreaId = [dictionary objectForKey:@"liveAreaId"];
    self.liveAreaName = [dictionary objectForKey:@"liveAreaName"];
    self.liveCityId = [dictionary objectForKey:@"liveCityId"];
    self.liveCityName = [dictionary objectForKey:@"liveCityName"];
    self.liveProvinceId = [dictionary objectForKey:@"liveProvinceId"];
    self.liveProvinceName = [dictionary objectForKey:@"liveProvinceName"];
    self.relationType = [dictionary objectForKey:@"relationType"];
    self.relationTypeName = [dictionary objectForKey:@"relationTypeName"];
    self.updatedAt = [BaseModel dateFromString:[dictionary objectForKey:@"updatedAt"]];
}

@end
