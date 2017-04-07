//
//  NetWorkHandler+setSpecialtyUserProductRatio.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/19.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (setSpecialtyUserProductRatio)

+ (void) requestToSetSpecialtyUserProductRatio:(NSString *) userId
                                     productId:(NSString *) productId
                                  productRatio:(CGFloat) productRatio
                                    Completion:(Completion)completion;

+ (void) requestToSetSpecialtyUserProductRatio:(NSString *) userId
                                     productId:(NSString *) productId
                                  productRatio:(CGFloat) productRatio
                                   selfDefault:(NSString *) selfDefault
                                    Completion:(Completion)completion;

@end
