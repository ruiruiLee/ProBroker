//
//  NetWorkHandler+getCharge.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/4/24.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (getCharge)

+ (void) requestToGetCharge:(NSString *)channel
                     amount:(NSString *) amount
                    orderNo:(NSString *) orderNo
                productDesc:(NSString *) productDesc
                productName:(NSString *) productName
                 systemName:(NSString *) systemName
                 Completion:(Completion)completion;

@end

