//
//  NetWorkHandler+privateLetter.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"

@interface NetWorkHandler (privateLetter)

+ (void) requestToPostPrivateLetter:(NSString *) userId
                              title:(NSString *) title
                            content:(NSString *) content
                           senderId:(NSString *) senderId
                         senderName:(NSString *) senderName
                         Completion:(Completion)completion;

@end
