//
//  NetWorkHandler+announcement.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/12.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (announcement)

+ (void) requestToAnnouncement:(NSString *)userId
                    completion:(Completion)completion;
+ (void) requestToAnnouncementNum:(NSString *)userId
                       completion:(Completion)completion;

+ (void) requestToPushCustomerCount:(NSString *) userId completion:(Completion)completion;
@end
