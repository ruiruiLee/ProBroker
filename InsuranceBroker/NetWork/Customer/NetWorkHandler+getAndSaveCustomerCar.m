//
//  NetWorkHandler+getAndSaveCustomerCar.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler+getAndSaveCustomerCar.h"
#import "define.h"

@implementation NetWorkHandler (getAndSaveCustomerCar)

+ (void) requestToGetAndSaveCustomerCar:(NSString *)pageType
                                 userId:(NSString *) userId
                                  carNo:(NSString *) carNo
                         newCarNoStatus:(BOOL) newCarNoStatus
                           carOwnerName:(NSString *) carOwnerName
                           carOwnerCard:(NSString *) carOwnerCard
                             carShelfNo:(NSString *) carShelfNo
                           carBrandName:(NSString *) carBrandName
                              carTypeNo:(NSString *) carTypeNo
                            carEngineNo:(NSString *) carEngineNo
                             carRegTime:(NSString *) carRegTime
                         carTradeStatus:(NSString *) carTradeStatus
                           carTradeTime:(NSString *) carTradeTime
                            travelCard1:(NSString *) travelCard1
                             Completion:(Completion)completion
{
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    
    NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:pramas value:pageType key:@"pageType"];
    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
    [Util setValueForKeyWithDic:pramas value:carNo key:@"carNo"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithBool:newCarNoStatus] key:@"newCarNoStatus"];
    [Util setValueForKeyWithDic:pramas value:carOwnerName key:@"carOwnerName"];
    [Util setValueForKeyWithDic:pramas value:carOwnerCard key:@"carOwnerCard"];
    [Util setValueForKeyWithDic:pramas value:carShelfNo key:@"carShelfNo"];
    [Util setValueForKeyWithDic:pramas value:carBrandName key:@"carBrandName"];
    [Util setValueForKeyWithDic:pramas value:carTypeNo key:@"carTypeNo"];
    [Util setValueForKeyWithDic:pramas value:carRegTime key:@"carRegTime"];
    [Util setValueForKeyWithDic:pramas value:carTradeStatus key:@"carTradeStatus"];
    [Util setValueForKeyWithDic:pramas value:carTradeTime key:@"carTradeTime"];
    [Util setValueForKeyWithDic:pramas value:travelCard1 key:@"travelCard1"];
    [Util setValueForKeyWithDic:pramas value:carEngineNo key:@"carEngineNo"];
    
    [handle postWithMethod:@"/web/customer/getAndSaveCustomerCar.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
