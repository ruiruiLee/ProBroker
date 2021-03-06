//
//  NetWorkHandler.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/28.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "NetWorkHandler.h"
#import "SBJson.h"
#import "ProjectDefine.h"
#import "define.h"
#import "EGOCache.h"

static NetWorkHandler *networkmanager;

@implementation NetWorkHandler

+ (NetWorkHandler *) shareNetWorkHandler
{
    if(networkmanager == nil)
    {
        networkmanager = [[NetWorkHandler alloc] init];
    }
    
    return networkmanager;
}

- (id) init
{
    self = [super init];
    if(self){
        [ProjectDefine shareProjectDefine];
        self.manager = [AFHTTPSessionManager manager];
        _reqArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) getWithUrl:(NSString *) url Params:(NSMutableDictionary *) params Completion:(Completion)completion
{
    NSString *path = url;
    
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];//[AFHTTPRequest Serializerserializer];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *req = [self.manager POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *doubi = responseObject;
        
        NSString *shabi =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
        
        if(completion){
            completion(1, shabi);
        }
        
        [_reqArray removeObject:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求URL：%@  \n请求参数：%@\n 请求结果：%@\n==================================", url, params, error);
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInteger:error.code] forKey:@"code"];
        [dic setObject:error.localizedDescription forKey:@"msg"];
        [self handleResponse:dic Completion:completion];
        
        [_reqArray removeObject:task];
    }];
    
    [_reqArray addObject:req];
}

- (void) getWithMethod:(NSString *)method BaseUrl:(NSString *)url Params:(NSMutableDictionary *) params Completion:(Completion)completion
{
    NSString *path = url;
    if (method != nil && method.length > 0) {
        path = [url stringByAppendingString:method];
    }
    [self addDeviceAndAppInfo:params];
    if(![method isEqualToString:@"/api/user/login"])
    {
        [self addClientKey:params];
    }
    /**
     * 处理短时间内重复请求
     **/
    NSMutableString *Tag = [[NSMutableString alloc] init];
    [Tag appendString:path];
    for (int i = 0; i < [params.allKeys count]; i++) {
        NSString *key = [params.allKeys objectAtIndex:i];
        [Tag appendFormat:@"%@=%@", key, [params objectForKey:key]];
    }
    
    if([ProjectDefine searchRequestTag:Tag])
    {
        return;
    }
    [ProjectDefine addRequestTag:Tag];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLSessionDataTask *req = [self.manager GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = nil;
        if([responseObject isKindOfClass:[NSData class]]){
            SBJsonParser *_parser = [[SBJsonParser alloc] init];
            result = [_parser objectWithData:(NSData *)responseObject];
        }else{
            result = responseObject;
        }
        
        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", url, method, params, result);
        
        [self handleResponse:result Completion:completion];
        
        [ProjectDefine removeRequestTag:Tag];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_reqArray removeObject:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", url, method, params, error);
        [ProjectDefine removeRequestTag:Tag];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInteger:error.code] forKey:@"code"];
        [dic setObject:error.localizedDescription forKey:@"msg"];
        [self handleResponse:dic Completion:completion];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_reqArray removeObject:task];
    }];
    
    [_reqArray addObject:req];
}

-(NSMutableString *) ConvertCachKeyString:(NSString*)strUrl{
    NSMutableString *Strkey = [[NSMutableString alloc] initWithString:strUrl];

    NSString *strReplace = [NSString stringWithFormat:@"userid=%@",  [UserInfoModel shareUserInfoModel].userId];
    
    [Strkey stringByAppendingString:strReplace];
    return Strkey;
}

-(NSString *)getUrlAbsoluteString:(NSURLRequest *) request{
    NSString *url;
    if ([request.HTTPMethod isEqualToString:@"GET"]) {
        url = request.URL.absoluteString;
    }else {
        NSMutableString * string = [[NSMutableString alloc] initWithData:request.HTTPBody encoding:NSMacOSRomanStringEncoding];
        
        NSString    *regextString = @"JsonID=\\d+&";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regextString
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:string
                                                        options:NSMatchingReportProgress
                                                          range:NSMakeRange(0, string.length)];
        
        if (NSEqualRanges(match.range, NSMakeRange(0, 0))) {
            regextString = @"&JsonID=\\d+";
            regex = [NSRegularExpression regularExpressionWithPattern:regextString
                                                              options:NSRegularExpressionCaseInsensitive
                                                                error:nil];
            match = [regex firstMatchInString:string
                                      options:NSMatchingReportProgress
                                        range:NSMakeRange(0, string.length)];
        }
        [string replaceCharactersInRange:match.range withString:@""];
        
        
        url = [request.URL.absoluteString stringByAppendingFormat:@"?%@",string];
        
    }
    return url;
}


- (void) postWithMethod:(NSString *)method BaseUrl:(NSString *)url Params:(NSMutableDictionary *) params Completion:(Completion)completion
{
    NSString *path = url;
    if (method != nil && method.length > 0) {
        path = [url stringByAppendingString:method];
    }
    
    [self addDeviceAndAppInfo:params];
    if(![method isEqualToString:@"/api/user/login"])
    {
        [self addClientKey:params];
    }
    
    /**
     * 处理短时间内重复请求
     **/
    NSMutableString *Tag = [[NSMutableString alloc] init];
    [Tag appendString:path];
    for (int i = 0; i < [params.allKeys count]; i++) {
        NSString *key = [params.allKeys objectAtIndex:i];
        [Tag appendFormat:@"%@=%@", key, [params objectForKey:key]];
    }
    
    if([ProjectDefine searchRequestTag:Tag])
    {
        return;
    }
    
    [ProjectDefine addRequestTag:Tag];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSMutableURLRequest *request = [self.manager.requestSerializer requestWithMethod:@"POST" URLString:path parameters:params error:nil];
    
    NSURLSessionDataTask *req = [self.manager POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProjectDefine removeRequestTag:Tag];
        NSDictionary *result = nil;
        if([responseObject isKindOfClass:[NSData class]]){
            SBJsonParser *_parser = [[SBJsonParser alloc] init];
            result = [_parser objectWithData:(NSData *)responseObject];
        }else{
            result = responseObject;
        }
        _urlstring= [self ConvertCachKeyString:[self getUrlAbsoluteString:request]];
        // 加缓存
        [[EGOCache globalCache] setObject:result forKey: [Util md5Hash:_urlstring]];

        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", url, method, params, result);
        
        [self handleResponse:result Completion:completion];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_reqArray removeObject:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProjectDefine removeRequestTag:Tag];
        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", url, method, params, error);
        _urlstring= [self ConvertCachKeyString:[self getUrlAbsoluteString:request]];
        id cacheDatas =[[EGOCache globalCache] objectForKey:[Util md5Hash:_urlstring]];
        if([method isEqualToString:@"/api/user/login"])
        {
            [self handleResponse:nil Completion:completion];
        }else
            [self handleResponse:cacheDatas Completion:completion];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_reqArray removeObject:task];
    }];
    
    [_reqArray addObject:req];
}

- (void) handleResponse:(NSDictionary *)result Completion:(Completion)completion {
    if(![result isKindOfClass:[NSDictionary class]]){
        if(completion){
            completion(-1, nil);
        }
    }else{
        int code = [[result objectForKey:@"code"] intValue];
        if(completion){
            completion(code, result);
        }
    }
}

- (void) addDeviceAndAppInfo:(NSMutableDictionary *) parmas
{
    NSString *version = [Util getCurrentVersion];
    [Util setValueForKeyWithDic:parmas value:version key:@"appVersion"];
    NSNumber *deviceType = [NSNumber numberWithInt:2];
    [Util setValueForKeyWithDic:parmas value:deviceType key:@"deviceType"];
}

- (void) addClientKey:(NSMutableDictionary *) parmas
{
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    [Util setValueForKeyWithDic:parmas value:user.clientKey key:@"clientKey"];
}


+ (NSDictionary *) getRulesByField:(NSString *) field op:(NSString *) op data:(NSString *) data
{
    NSMutableDictionary *rule = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:rule value:field key:@"field"];
    [Util setValueForKeyWithDic:rule value:op key:@"op"];
    [Util setValueForKeyWithDic:rule value:data key:@"data"];
    
    return rule;
}

+ (NSString *) getStringWithList:(NSArray *)array
{
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < [array count]; i++) {
        NSString *str = [array objectAtIndex:i];
        [result appendString:str];
        if(i != [array count] -1)
            [result appendString:@"|"];
    }
    
    return result;
}

+ (NSString *) objectToJson:(id) obj
{
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    return [writer stringWithObject:obj];
}

- (void) removeAllRequest
{
//    [self.manager.operationQueue cancelAllOperations];
    for (int i = 0 ; i < [_reqArray count]; i++) {
        NSURLSessionDataTask *task = [_reqArray objectAtIndex:i];
        [task cancel];
    }
    
    [_reqArray removeAllObjects];
}

@end
