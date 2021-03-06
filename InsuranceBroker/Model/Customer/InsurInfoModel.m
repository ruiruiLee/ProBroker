//
//  InsurInfoModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/11.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "InsurInfoModel.h"

@implementation InsurInfoModel

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    InsurInfoModel *model = [[InsurInfoModel alloc] init];
    
    model.insuranceOrderId = [dictionary objectForKey:@"insuranceOrderId"];
    model.insuranceOrderUuid = [dictionary objectForKey:@"insuranceOrderUuid"];
    model.insuranceOrderNo = [dictionary objectForKey:@"insuranceOrderNo"];
    model.planType = [[dictionary objectForKey:@"planType"] integerValue];
    model.planId = [dictionary objectForKey:@"planId"];
    model.insuranceType = [[dictionary objectForKey:@"insuranceType"] integerValue];
    model.createdAt = [InsurInfoModel dateFromString:[dictionary objectForKey:@"createdAt"]];
    if([BaseModel dateIsNil:model.createdAt])
        model.createdAt = nil;
    model.updatedAt = [InsurInfoModel dateFromString:[dictionary objectForKey:@"updatedAt"]];
    if([BaseModel dateIsNil:model.updatedAt])
        model.updatedAt = nil;
    
    model.orderStatus = [[dictionary objectForKey:@"orderStatus"] integerValue];
    model.orderOfferStatus = [[dictionary objectForKey:@"orderOfferStatus"] integerValue];
    model.orderOfferTime = [InsurInfoModel dateFromString:[dictionary objectForKey:@"orderOfferTime"]];
    model.orderOfferStatusId = [dictionary objectForKey:@"orderOfferStatusId"];
    model.orderOfferStatusMsg = [dictionary objectForKey:@"orderOfferStatusMsg"];
    model.orderOfferStatusDescr = [dictionary objectForKey:@"orderOfferStatusDescr"];
    if(model.orderOfferStatusDescr == nil)
        model.orderOfferStatusDescr = @"";
    model.orderOfferPayType = [[dictionary objectForKey:@"orderOfferPayType"] integerValue];
    model.orderOfferNums = [[dictionary objectForKey:@"orderOfferNums"] integerValue];
    model.orderOfferOrigPrice = [[dictionary objectForKey:@"orderOfferOrigPrice"] floatValue];
    model.orderOfferRatio = [[dictionary objectForKey:@"orderOfferRatio"] floatValue];
    model.orderOfferPayPrice = [[dictionary objectForKey:@"orderOfferPayPrice"] floatValue];
    model.customerName = [dictionary objectForKey:@"customerName"];
    model.customerName1 = [dictionary objectForKey:@"customerName1"];
    model.customerPhone = [dictionary objectForKey:@"customerPhone"];
    model.carNo = [dictionary objectForKey:@"carNo"];
    model.respAddr = [dictionary objectForKey:@"respAddr"];
    model.planTypeName = [dictionary objectForKey:@"planTypeName"];
    model.planOfferId = [dictionary objectForKey:@"planOfferId"];
    model.orderOfferStatusStr = [dictionary objectForKey:@"orderOfferStatusStr"];
    model.productLogo = [dictionary objectForKey:@"productLogo"];
    model.orderOfferPrintStatus = [[dictionary objectForKey:@"orderOfferPrintStatus"] integerValue];
    model.orderOfferGatherStatus = [[dictionary objectForKey:@"orderOfferGatherStatus"] boolValue];
    model.orderImgType = [[dictionary objectForKey:@"orderImgType"] integerValue];
    model.planTypeName_ = [dictionary objectForKey:@"planTypeName_"];
    model.gxTitle = [dictionary objectForKey:@"gxTitle"];
    model.insuredName = [dictionary objectForKey:@"insuredName"];
    model.expireDate = [InsurInfoModel dateFromString:[dictionary objectForKey:@"expireDate"]];
    model.fcreateDate = [InsurInfoModel dateFromString:[dictionary objectForKey:@"fcreateDate"]];
    model.clickUrl = [dictionary objectForKey:@"clickUrl"];
    model.gxbzStatus = [[dictionary objectForKey:@"gxbzStatus"] integerValue];
    
    model.orderClientStatus = [[dictionary objectForKey:@"orderClientStatus"] integerValue];
    
    return model;
}

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [result addObject:[InsurInfoModel modelFromDictionary:dic]];
    }
    
    return result;
}

@end
