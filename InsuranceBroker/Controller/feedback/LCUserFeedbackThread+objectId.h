//
//  LCUserFeedbackThread+objectId.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <LeanCloudFeedback/LeanCloudFeedback.h>

@interface LCUserFeedbackThread (objectId)

+(void)fetchFeedbackWithObjectId:(NSString *)objectId Block:(LCUserFeedbackBlock)block;

@end
