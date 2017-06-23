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
        NSString *payDesc = [result objectForKey:@"payDesc"];
        NSString *createdAt = [result objectForKey:@"createdAt"];
        NSString *companyLogo = [result objectForKey:@"companyLogo"];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToPay:insuranceType:planOfferId:titleName:totalFee:companyLogo:createdAt:payDesc:)]){
            [self.delegate NotifyToPay:orderId insuranceType:insuranceType planOfferId:planOfferId titleName:titleName totalFee:totalFee companyLogo:companyLogo createdAt:createdAt payDesc:payDesc];
        }
    }
}

- (void) canGoBack:(BOOL) flag
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyWebCanReturnPrev:)]){
        [self.delegate NotifyWebCanReturnPrev:flag];
    }
}

- (void) updateMsgTime:(NSString *) string
{
    if([string isKindOfClass:[NSString class]]){
        SBJsonParser *_parser = [[SBJsonParser alloc] init];
        NSDictionary *result = [_parser objectWithString:string];
        NSString *time = [result objectForKey:@"lastNewsDt"];
        long long t = [time longLongValue];
        if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyLastUpdateTime:category:)])
            [self.delegate NotifyLastUpdateTime:t category:[result objectForKey:@"category"]];
    }
}

- (void) goOrderList:(NSString *) string//跳转到订单列表
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(notifyToOrderList:)]){
        [self.delegate notifyToOrderList:string];
    }
}

- (void) webViewLoadFinished:(NSString *) string
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(notifyWebViewLoadFinished:)]){
        [self.delegate notifyWebViewLoadFinished:string];
    }
}

- (void) openLocation:(NSString *)string
{
    SBJsonParser *_parser = [[SBJsonParser alloc] init];
    NSDictionary *coordinate = [_parser objectWithString:string];
    if(self.delegate && [self.delegate respondsToSelector:@selector(notifyOpenMap:)]){
        [self.delegate notifyOpenMap:coordinate];
    }
}

@end
