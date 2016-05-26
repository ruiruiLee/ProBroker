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

- (void) selectCustomer
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToSelectCustomer)])
    {
        [self.delegate NotifyToSelectCustomer];
    }
}

@end
