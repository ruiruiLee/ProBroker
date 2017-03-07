//
//  TagObjectModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/23.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "TagObjectModel.h"

@implementation TagObjectModel

+ (NSMutableArray *) shareTagList
{
    static NSMutableArray *tagList = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tagList = [[NSMutableArray alloc] init];
    });
    
    return tagList;
}

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[TagObjectModel modelFromDictionary:dic]];
    }
    
    return result;
}

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    TagObjectModel *model = [[TagObjectModel alloc] init];
    
    model.labelName = [dictionary objectForKey:@"labelName"];
    model.labelId = [dictionary objectForKey:@"labelId"];
    model.labelCustomerNums = [dictionary objectForKey:@"labelCustomerNums"];
    model.labelStatus = [[dictionary objectForKey:@"labelStatus"] integerValue];
    model.labelType = [[dictionary objectForKey:@"labelType"] integerValue];
    model.userId = [dictionary objectForKey:@"userId"];

    
    return model;
}

@end
