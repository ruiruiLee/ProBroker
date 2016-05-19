//
//  NetWorkHandler+saveOrUpdateCustomerInsured.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/17.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+saveOrUpdateCustomerInsured.h"
#import "define.h"

@implementation NetWorkHandler (saveOrUpdateCustomerInsured)

+ (void) requestToSaveOrUpdateCustomerInsuredCardNumber:(NSString *) cardNumber
                                         customerId:(NSString *) customerId
                                       insuredEmail:(NSString *) insuredEmail
                                          insuredId:(NSString *) insuredId
                                        insuredMemo:(NSString *) insuredMemo
                                        insuredName:(NSString *) insuredName
                                       insuredPhone:(NSString *) insuredPhone
                                         insuredSex:(NSInteger ) insuredSex
                                      insuredStatus:(BOOL      ) insuredStatus
                                           liveAddr:(NSString *) liveAddr
                                         liveAreaId:(NSString *) liveAreaId
                                         liveCityId:(NSString *) liveCityId
                                     liveProvinceId:(NSString *) liveProvinceId
                                       relationType:(NSString *) relationType
                                         Completion:(Completion) completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithInt:insuredSex] key:@"insuredSex"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithBool:insuredStatus] key:@"insuredStatus"];
    [Util setValueForKeyWithDic:pramas value:cardNumber key:@"cardNumber"];
    [Util setValueForKeyWithDic:pramas value:customerId key:@"customerId"];
    [Util setValueForKeyWithDic:pramas value:insuredEmail key:@"insuredEmail"];
    [Util setValueForKeyWithDic:pramas value:insuredId key:@"insuredId"];
    [Util setValueForKeyWithDic:pramas value:insuredMemo key:@"insuredMemo"];
    [Util setValueForKeyWithDic:pramas value:insuredName key:@"insuredName"];
    [Util setValueForKeyWithDic:pramas value:insuredPhone key:@"insuredPhone"];
    [Util setValueForKeyWithDic:pramas value:liveAddr key:@"liveAddr"];
    [Util setValueForKeyWithDic:pramas value:liveAreaId key:@"liveAreaId"];
    [Util setValueForKeyWithDic:pramas value:liveCityId key:@"liveCityId"];
    [Util setValueForKeyWithDic:pramas value:liveProvinceId key:@"liveProvinceId"];
    [Util setValueForKeyWithDic:pramas value:relationType key:@"relationType"];
    
    [handle postWithMethod:@"/web/customer/saveOrUpdateCustomerInsured.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
