//
//  NetWorkHandler+getAndSaveCustomerCar.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (getAndSaveCustomerCar)

/**
 *    Pramas:
 *
 *    pageType:1;//1车险算加页面；2车辆信息补全页面
 *    userId:116;//
 *    carNo:xxxxx;//
 *    carOwnerName:xxxx;//车主姓名
 *    carOwnerCard:xxxx;//车主身份证号
 *    newCarNoStatus//是否新车未上牌
 *
 *    上面字段必传参数；下面字段，pageType=2才需要传入
 *    carShelfNo:xxxx;//车型
 *    carBrandName:xxxx;//品牌型号
 *    carTypeNo:xxxx;//车型
 *    carEngineNo:xxxx;//发动机号
 *    carRegTime:xxxx;//注册日期
 *    carTradeStatus:1未过户，2过户, nil表示第一阶段
 *    carTradeTime://车辆过户日期
 *    travelCard1://行驶证正本
 *
 */

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
                              productId:(NSString *) productId
                             Completion:(Completion)completion;

@end
