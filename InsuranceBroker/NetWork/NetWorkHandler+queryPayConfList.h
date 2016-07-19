//
//  NetWorkHandler+queryPayConfList.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/7/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

/**
 payStatus: 1;//
 payConfType: 2;//1线下支付；2线上支付
 deviceType: 1;//
*/

#import "NetWorkHandler.h"

@interface NetWorkHandler (queryPayConfList)

+ (void) requestToQueryPayConfList:(NSInteger) payStatus payConfType:(NSString *) payConfType deviceType:(NSString *) deviceType Completion:(Completion)completion;

@end
