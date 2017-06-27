//
//  NetWorkHandler+SMSRequest.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/6/27.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (SMSRequest)

+ (void) requestToShortMsg:(NSString *) phone template:(NSString *) temp sign:(NSString *) sign other:(NSString *) other Completion:(Completion)completion;

@end
