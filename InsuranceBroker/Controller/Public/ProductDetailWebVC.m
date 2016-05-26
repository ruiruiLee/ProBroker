//
//  ProductDetailWebVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ProductDetailWebVC.h"
#import "define.h"
#import "SBJson.h"
#import "SelectCustomerVC.h"

@implementation ProductDetailWebVC

- (void) NotifyToSelectCustomer
{
    if(self.infoModel.type == InsuredType1){
        NSDictionary *dic = [InsuredInfoModel dictionaryFromeModel:self.infoModel];
        SBJsonWriter *writer = [[SBJsonWriter alloc] init];
        NSString *string = [writer stringWithObject:dic];
        NSString *result = [NSString stringWithFormat:@"noticeCustomerInfo('%@');", string];
        
        [self.webview stringByEvaluatingJavaScriptFromString:result];
    }else{
        [self handleSelectCustomer];
    }
}

- (void) handleSelectCustomer//选择客户
{
    SelectCustomerVC *vc = [[SelectCustomerVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
