//
//  NetWorkHandler+saveOrUpdateCustomerInsured.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/17.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (saveOrUpdateCustomerInsured)

+ (void) requestToQueryForInsuredPageListCardNumber:(NSString *) cardNumber//身份证
                                         customerId:(NSString *) customerId//经纪人id
                                       insuredEmail:(NSString *) insuredEmail//被保人邮箱
                                          insuredId:(NSString *) insuredId//被保人id
                                        insuredMemo:(NSString *) insuredMemo//被保人备注描述
                                        insuredName:(NSString *) insuredName//被保人姓名
                                       insuredPhone:(NSString *) insuredPhone//被保人电话
                                         insuredSex:(NSInteger ) insuredSex//被保人性别
                                      insuredStatus:(BOOL      ) insuredStatus//被保人状态
                                           liveAddr:(NSString *) liveAddr//
                                         liveAreaId:(NSString *) liveAreaId//
                                         liveCityId:(NSString *) liveCityId//
                                     liveProvinceId:(NSString *) liveProvinceId//
                                       relationType:(NSString *) relationType//
                                         Completion:(Completion) completion;

@end
