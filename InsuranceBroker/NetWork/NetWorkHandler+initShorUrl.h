//
//  NetWorkHandler+initShorUrl.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/5.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (initShorUrl)

+ (void) requestToInitShorUrl:(NSString *) url Completion:(Completion)completion;

@end
