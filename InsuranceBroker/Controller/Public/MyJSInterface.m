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
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyShareWindowWithPrama:)])
    {
        [self.delegate NotifyShareWindowWithPrama:nil];
    }
}

- (void) shareUrl:(NSString *) pramas
{
    NSDictionary *object = nil;
    if(pramas != nil){
        SBJsonParser *_parser = [[SBJsonParser alloc] init];
        object = [_parser objectWithString:pramas];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyShareWindowWithPrama:)])
    {
        [self.delegate NotifyShareWindowWithPrama:object];
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

- (void) selectInsured
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToSelectInsured)]){
        [self.delegate NotifyToSelectInsured];
    }
}

- (void) initCustomer
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToInitCustomerInfo)]){
        [self.delegate NotifyToInitCustomerInfo];
    }
}

- (void) callInsurance:(NSString *) productAttrId
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToSelectCustomerForCar:)]){
        [self.delegate NotifyToSelectCustomerForCar:productAttrId];
    }
}

- (void) pay:(NSString *) pramas
{
    if([pramas isKindOfClass:[NSString class]]){
        SBJsonParser *_parser = [[SBJsonParser alloc] init];
        NSDictionary *result = [_parser objectWithString:pramas];
        NSString *planOfferId = [result objectForKey:@"planOfferId"];
        NSString *orderId = [result objectForKey:@"orderId"];
        NSString *insuranceType = [result objectForKey:@"insuranceType"];
        NSString *titleName = [result objectForKey:@"productName"];
        NSString *totalFee = [result objectForKey:@"amount"];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToPay:insuranceType:planOfferId:titleName:totalFee:)]){
            [self.delegate NotifyToPay:orderId insuranceType:insuranceType planOfferId:planOfferId titleName:titleName totalFee:totalFee];
        }
    }
}

- (void) canGoBack:(BOOL) flag
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyWebCanReturnPrev:)]){
        [self.delegate NotifyWebCanReturnPrev:flag];
    }
}

@end
