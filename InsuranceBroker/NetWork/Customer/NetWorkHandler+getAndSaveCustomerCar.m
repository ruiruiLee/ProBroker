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
    if([userId length] == 0)
        userId = nil;
    [Util setValueForKeyWithDic:pramas value:userId key:@"userId"];
    if([carNo length] == 0)
        carNo= nil;
    [Util setValueForKeyWithDic:pramas value:carNo key:@"carNo"];
    [Util setValueForKeyWithDic:pramas value:[NSNumber numberWithBool:newCarNoStatus] key:@"newCarNoStatus"];
    if([carOwnerName length] == 0)
        carOwnerName = nil;
    [Util setValueForKeyWithDic:pramas value:carOwnerName key:@"carOwnerName"];
    if([carOwnerCard length] == 0)
        carOwnerCard = nil;
    [Util setValueForKeyWithDic:pramas value:carOwnerCard key:@"carOwnerCard"];
    if([carShelfNo length] == 0)
        carShelfNo = nil;
    [Util setValueForKeyWithDic:pramas value:carShelfNo key:@"carShelfNo"];
    if([carBrandName length] == 0)
        carBrandName = nil;
    [Util setValueForKeyWithDic:pramas value:carBrandName key:@"carBrandName"];
    if([carRegTime length] == 0)
        carRegTime = nil;
    if([carTypeNo length] == 0)
        carTypeNo = nil;
    [Util setValueForKeyWithDic:pramas value:carTypeNo key:@"carTypeNo"];
    [Util setValueForKeyWithDic:pramas value:carRegTime key:@"carRegTime"];
    [Util setValueForKeyWithDic:pramas value:carTradeStatus key:@"carTradeStatus"];
//    if([carTradeTime length] == 0)
//        carTradeTime = nil;
    [Util setValueForKeyWithDic:pramas value:carTradeTime key:@"carTradeTime"];
    if([travelCard1 length] == 0)
        travelCard1 = nil;
    [Util setValueForKeyWithDic:pramas value:travelCard1 key:@"travelCard1"];
    if([carEngineNo length] == 0)
        carEngineNo = nil;
    [Util setValueForKeyWithDic:pramas value:carEngineNo key:@"carEngineNo"];
    
    [handle postWithMethod:@"/web/customer/getAndSaveCustomerCar.xhtml" BaseUrl:Base_Uri Params:pramas Completion:completion];
}

@end
