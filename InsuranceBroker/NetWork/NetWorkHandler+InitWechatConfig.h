//
//  NetWorkHandler+InitWechatConfig.h
//  InsuranceBroker
//  5.42	生成微信支付预订单
//  Created by LiuZach on 16/7/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (InitWechatConfig)

+ (void) requestToInitWechatConfig:(NSString *) initType
                      payOrderType:(NSInteger) payOrderType
                        outTradeNo:(NSString *) outTradeNo
                            openId:(NSString *) openId
                          totalFee:(NSString *) totalFee
                              body:(NSString *) body
                           baseUrl:(NSString *) baseUrl
                        Completion:(Completion)completion;

@end
