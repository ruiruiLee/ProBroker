//
//  NetWorkHandler.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/28.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"

typedef void(^Completion) (int code, id content);

@interface NetWorkHandler : NSObject
{
    NSMutableString       * _urlstring;
    
    NSMutableArray *_reqArray;
}

@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (NetWorkHandler *) shareNetWorkHandler;

- (void) postWithMethod:(NSString *)method BaseUrl:(NSString *)url Params:(NSMutableDictionary *) params Completion:(Completion)completion;
- (void) getWithMethod:(NSString *)method BaseUrl:(NSString *)url Params:(NSMutableDictionary *) params Completion:(Completion)completion;
- (void) getWithUrl:(NSString *) url Params:(NSMutableDictionary *) params Completion:(Completion)completion;

+ (NSDictionary *) getRulesByField:(NSString *) field op:(NSString *) op data:(NSString *) data;//添加过滤项
+ (NSString *) getStringWithList:(NSArray *)array;//序列化数组
+ (NSString *) objectToJson:(id) obj;//json化

- (void) removeAllRequest;

@end
