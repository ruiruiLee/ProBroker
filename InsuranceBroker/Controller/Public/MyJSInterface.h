//
//  MyJSInterface.h
//  EasyJSWebViewSample
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyJSDataFunction.h"

@protocol MyJSInterfaceDelegate <NSObject>

- (void) NotifyCloseWindow;
- (void) NotifyShareWindow;
- (void) NotifyToReSubmitCarInfo:(NSString *) orderId customerId:(NSString *) customerId customerCarId:(NSString *) customerCarId;

@end

@interface MyJSInterface : NSObject

@property (nonatomic, assign) id<MyJSInterfaceDelegate> delegate;

- (void) test;
- (void) testWithParam: (NSString*) param;
- (void) testWithTwoParam: (NSString*) param AndParam2: (NSString*) param2;

- (void) testWithFuncParam: (EasyJSDataFunction*) param;
- (void) testWithFuncParam2: (EasyJSDataFunction*) param;

- (NSString*) testWithRet;

- (void) close;

- (void) shareUrl;

- (void) againParamsMap:(NSDictionary *) pramas;

@end
