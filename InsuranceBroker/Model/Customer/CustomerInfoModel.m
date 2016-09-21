//
//  CustomerInfoModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/5.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "CustomerInfoModel.h"
#import <UIKit/UIKit.h>
#import "SBJson.h"

@implementation CustomerInfoModel

- (id) init
{
    self= [super init];
    
    if(self){
        self.isLoadDetail = 0;
    }
    
    return self;
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.zzz";
    return dateFormatter;
}

+ (NSDate *)dateFromString:(NSString *)string
{
    @try {
        NSString *dateString = [string substringWithRange:NSMakeRange(0, 19)];
        NSDateFormatter *dateFormatter = [BaseModel dateFormatter];
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        return date;
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
        
    }
    
}

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    CustomerInfoModel *model = [[CustomerInfoModel alloc] init];
    
    model.customerId = [dictionary objectForKey:@"customerId"];
    model.customerName = [dictionary objectForKey:@"customerName"];
    model.visitType = [dictionary objectForKey:@"visitType"];
    model.headImg = [dictionary objectForKey:@"headImg"];
    if(model.headImg != nil && [model.headImg length] == 0)
        model.headImg = nil;
    model.customerPhone = [dictionary objectForKey:@"customerPhone"];
    model.createdAt = [CustomerInfoModel dateFromString:[dictionary objectForKey:@"createdAt"]];
    model.isAgentCreate = [[dictionary objectForKey:@"isAgentCreate"] integerValue];
//    model.customerLabel = [dictionary objectForKey:@"customerLabel"];
//    model.customerLabelId = [dictionary objectForKey:@"customerLabelId"];
    model.bindType = [[dictionary objectForKey:@"bindType"] integerValue];
    model.bindStatus = [[dictionary objectForKey:@"bindStatus"] boolValue];
    model.updatedAt = [CustomerInfoModel dateFromString:[dictionary objectForKey:@"updatedAt"]];
    
    return model;
}

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[CustomerInfoModel modelFromDictionary:dic]];
    }
    
    return result;
}

//+ (NSDictionary *)JSONKeyPathsByPropertyKey {
//    return @{
//             @"customerId": @"customerId",
//             @"customerName": @"customerName",
//             @"visitType": @"visitType",
//             @"createdAt": @"createdAt",
//             @"isAgentCreate": @"isAgentCreate",
//             @"customerLabel": @"customerLabel",
//             @"customerLabelId": @"customerLabelId",
//             @"bindType": @"bindType",
//             @"bindStatus": @"bindStatus",
//             @"updatedAt": @"updatedAt",
//             @"headImg": @"headImg",
//             @"customerPhone": @"customerPhone"
//             };
//}
//
//+ (NSValueTransformer *)createdAtJSONTransformer {
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *dateString) {
//        return [CustomerInfoModel dateFromString:dateString];//[self.dateFormatter dateFromString:dateString];
//    } reverseBlock:^id(NSDate *date) {
//        return nil;//[self.dateFormatter stringFromDate:date];
//    }];
//}
//
//+ (NSValueTransformer *)updatedAtJSONTransformer {
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *dateString) {
//        return [CustomerInfoModel dateFromString:dateString];//[self.dateFormatter dateFromString:dateString];
//    } reverseBlock:^id(NSDate *date) {
//        return nil;//[self.dateFormatter stringFromDate:date];
//    }];
//}
//
//+ (NSNumber *) transformTobool:(NSString *) string
//{
//    return [NSNumber numberWithBool:[string boolValue]];//[string boolValue];
//}
//
//+ (NSNumber *) transformToInt:(NSString *) string
//{
//    return [NSNumber numberWithInteger:[string integerValue]];//[string boolValue];
//}
//
//+ (NSString *) transformToString:(NSNumber*) value
//{
//    return [NSString stringWithFormat:@"%d", [value integerValue]];
//}
//
//+ (NSValueTransformer *)isAgentCreateJSONTransformer {
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *string) {
//        return [CustomerInfoModel transformToInt:string];
//    } reverseBlock:^id(NSNumber *value) {
//        return [CustomerInfoModel transformToString:value];
//    }];
//}
//
//+ (NSValueTransformer *)bindTypeJSONTransformer {
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *string) {
//        return [CustomerInfoModel transformToInt:string];
//    } reverseBlock:^id(NSNumber *value) {
//        return [CustomerInfoModel transformToString:value];
//    }];
//}
//
//+ (NSValueTransformer *)bindStatusJSONTransformer {
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *string) {
//        return [CustomerInfoModel transformTobool:string];
//    } reverseBlock:^id(NSNumber *value) {
//        return [CustomerInfoModel transformToString:value];
//    }];
//}

+ (NSArray *) arrayFromString:(NSString *)string
{
    SBJsonParser *_parser = [[SBJsonParser alloc] init];
    return [_parser objectWithString:string];
}
//
//+ (NSValueTransformer *)customerLabelJSONTransformer {
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *string) {
//        return [CustomerInfoModel arrayFromString:string];
//    } reverseBlock:^id(NSArray *array) {
//        return nil;
//    }];
//}
//
//+ (NSValueTransformer *)customerLabelIdJSONTransformer {
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *string) {
//        return [CustomerInfoModel arrayFromString:string];
//    } reverseBlock:^id(NSArray *array) {
//        return nil;
//    }];
//}

@end
