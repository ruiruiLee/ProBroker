//
//  NetWorkHandler+initOrderShare.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/21.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (initOrderShare)

+ (void) requestToInitOrderShare:(NSString *) orderId Completion:(Completion)completion;

@end
