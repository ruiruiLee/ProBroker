//
//  InsuredInfoModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "InsuredInfoModel.h"
#import "InsuredUserInfoModel.h"
#import "define.h"

@implementation InsuredInfoModel

+ (InsuredInfoModel *) initFromInsuredUserInfoModel:(InsuredUserInfoModel *) insuredUserInfo
{
    InsuredInfoModel *model = [[InsuredInfoModel alloc] init];
    
    model.customerId = insuredUserInfo.customerId;
    model.insuredId = insuredUserInfo.insuredId;
    model.cardNumber = insuredUserInfo.cardNumber;
    model.createdAt = insuredUserInfo.createdAt;
    model.insuredEmail = insuredUserInfo.insuredEmail;
    model.insuredMemo = insuredUserInfo.insuredMemo;
    model.insuredName = insuredUserInfo.insuredName;
    model.insuredPhone = insuredUserInfo.insuredPhone;
    model.insuredSex = insuredUserInfo.insuredSex;
    model.insuredStatus = insuredUserInfo.insuredStatus;
    model.liveAddr = insuredUserInfo.liveAddr;
    model.liveAreaId = insuredUserInfo.liveAreaId;
    model.liveAreaName = insuredUserInfo.liveAreaName;
    model.liveCityId = insuredUserInfo.liveCityId;
    model.liveCityName = insuredUserInfo.liveCityName;
    model.liveProvinceId = insuredUserInfo.liveProvinceId;
    model.liveProvinceName = insuredUserInfo.liveProvinceName;
    model.relationType = insuredUserInfo.relationType;
    model.relationTypeName = insuredUserInfo.relationTypeName;
    model.updatedAt = insuredUserInfo.updatedAt;
    
    return model;
}

+ (NSDictionary *) dictionaryFromeModel:(InsuredInfoModel *) model
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:dic value:model.customerId key:@"customerId"];
    [Util setValueForKeyWithDic:dic value:model.insuredId key:@"insuredId"];
    [Util setValueForKeyWithDic:dic value:model.cardNumber key:@"cardNumber"];
    [Util setValueForKeyWithDic:dic value:model.insuredEmail key:@"insuredEmail"];
    [Util setValueForKeyWithDic:dic value:model.insuredName key:@"insuredName"];
    [Util setValueForKeyWithDic:dic value:model.insuredPhone key:@"insuredPhone"];
    [Util setValueForKeyWithDic:dic value:[NSNumber numberWithInteger:model.insuredSex] key:@"insuredSex"];
    [Util setValueForKeyWithDic:dic value:model.liveAddr key:@"liveAddr"];
    [Util setValueForKeyWithDic:dic value:model.liveAreaId key:@"liveAreaId"];
    [Util setValueForKeyWithDic:dic value:model.liveAreaName key:@"liveAreaName"];
    [Util setValueForKeyWithDic:dic value:model.liveCityId key:@"liveCityId"];
    [Util setValueForKeyWithDic:dic value:model.liveCityName key:@"liveCityName"];
    [Util setValueForKeyWithDic:dic value:model.liveProvinceId key:@"liveProvinceId"];
    [Util setValueForKeyWithDic:dic value:model.liveProvinceName key:@"liveProvinceName"];
    [Util setValueForKeyWithDic:dic value:model.relationTypeName key:@"relationTypeName"];
    [Util setValueForKeyWithDic:dic value:model.relationType key:@"relationType"];
    
    return dic;
}

@end
