//
//  MyJSInterface.m
//  EasyJSWebViewSample
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import "MyJSInterface.h"
#import "SBJsonParser.h"

@implementation MyJSInterface

- (void) test{
	NSLog(@"test called");
}

- (void) testWithParam: (NSString*) param{
	NSLog(@"test with param: %@", param);
}

- (void) testWithTwoParam: (NSString*) param AndParam2: (NSString*) param2{
	NSLog(@"test with param: %@ and param2: %@", param, param2);
}

- (void) testWithFuncParam: (EasyJSDataFunction*) param{
	NSLog(@"test with func");
	
	param.removeAfterExecute = YES;
	NSString* ret = [param executeWithParam:@"blabla:\"bla"];
	
	NSLog(@"Return value from callback: %@", ret);
}

- (void) testWithFuncParam2: (EasyJSDataFunction*) param{
	NSLog(@"test with func 2 but not removing callback after invocation");
	
	param.removeAfterExecute = NO;
	[param executeWithParam:@"data 1"];
	[param executeWithParam:@"data 2"];
}

- (NSString*) testWithRet{
	NSString* ret = @"js";
	return ret;
}

- (void) close
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyCloseWindow)])
    {
        [self.delegate NotifyCloseWindow];
    }
}

- (void) shareUrl
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyShareWindow)])
    {
        [self.delegate NotifyShareWindow];
    }
}

- (void) againParamsMap:(NSString *) pramas
{
    if([pramas isKindOfClass:[NSString class]]){
        SBJsonParser *_parser = [[SBJsonParser alloc] init];
        NSDictionary *result = [_parser objectWithString:pramas];
        NSString *customerCarId = [result objectForKey:@"customerCarId"];
        NSString *orderId = [result objectForKey:@"orderId"];
        NSString *userId = [result objectForKey:@"userId"];
        if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToReSubmitCarInfo:customerId:customerCarId:)]){
            [self.delegate NotifyToReSubmitCarInfo:orderId customerId:userId customerCarId:customerCarId];
        }
    }
}

@end
