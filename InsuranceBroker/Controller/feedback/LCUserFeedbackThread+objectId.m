//
//  LCUserFeedbackThread+objectId.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "LCUserFeedbackThread+objectId.h"
#import "LCHttpClient.h"
#import "LCUtils.h"

#define LC_FEEDBACK_BASE_PATH @"feedback"

@implementation LCUserFeedbackThread (objectId)

+ (NSString *)objectPath {
    return LC_FEEDBACK_BASE_PATH;
}

//自定义会话id
+(void)fetchFeedbackWithObjectId:(NSString *)objectId Block:(LCUserFeedbackBlock)block {
    NSString *feedbackObjectId = objectId;
    if (feedbackObjectId == nil) {
        // do not create empty feedback
        block(nil, nil);
    } else {
        LCHttpClient *client = [LCHttpClient sharedInstance];
        [client getObject:[LCUserFeedbackThread objectPath] withParameters:@{@"objectId":feedbackObjectId} block:^(id object, NSError *error) {
            if (error) {
                [LCUtils callIdResultBlock:block object:nil error:error];
            } else {
                NSArray* results = [(NSDictionary*)object objectForKey:@"results"];
                if (results.count == 0) {
                    [LCUtils callIdResultBlock:block object:nil error:nil];
                } else {
                    LCUserFeedbackThread *feedback = [[LCUserFeedbackThread alloc] initWithDictionary:results[0]];
                    [LCUtils callIdResultBlock:block object:feedback error:nil];
                }
            }
        }];
    }
}

@end
