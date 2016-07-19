//
//  PayUtil.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/7/14.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "PayUtil.h"
#import "AppMethod.h"
#import "AppUtils.h"
#import <AFNetworking.h>

@implementation PayUtil

// 需要一步
- (void)aliPayClick
{
    // 添加商品信息
    Product *product = [Product new];
    product.orderId = [AppMethod getRandomString];
    product.subject = @"PayDemo_AliPayTest_subject";
    product.body = @"PayDemo_AliPayTest_body";
    product.price = 0.01;
    
    
    // 调起支付宝客户端
    [[AlipayHelper shared] alipay:product block:^(NSDictionary *result) {
        // 返回结果
        NSString *message = @"";
        switch([[result objectForKey:@"resultStatus"] integerValue])
        {
            case 9000:message = @"订单支付成功";break;
            case 8000:message = @"正在处理中";break;
            case 4000:message = @"订单支付失败";break;
            case 6001:message = @"用户中途取消";break;
            case 6002:message = @"网络连接错误";break;
            default:message = @"未知错误";
        }
        
        UIAlertController *aalert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [aalert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
//        [self presentViewController:aalert animated:YES completion:nil];
    }];
    
}


// 需要两步
+ (void)wechatPayClick
{
//    ////////////  第一步 统一下单
//    // 添加商品信息
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:WeChatAppID forKey:@"appid"];
//    [dict setObject:@"PayDemo_WeChatPayTest_body" forKey:@"body"];
//    [dict setObject:WeChatMCH_ID forKey:@"mch_id"];
//    [dict setObject:[AppMethod getRandomString] forKey:@"nonce_str"];
//    [dict setObject:WeChatNOTIFY_URL forKey:@"notify_url"];
//    [dict setObject:[AppMethod getRandomString] forKey:@"out_trade_no"];
//    [dict setObject:[AppMethod deviceIPAdress] forKey:@"spbill_create_ip"];
//    [dict setObject:@"1" forKey:@"total_fee"];
//    [dict setObject:@"APP" forKey:@"trade_type"];
//    
//    // 签名
//    NSDictionary *params = [AppMethod partnerSignOrder:dict];
//    // 转化成XML格式 引用三方框架XMLDictionary
//    NSString *postStr = [params XMLString];
//    
//    
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFormData:[postStr dataUsingEncoding:NSUTF8StringEncoding] name:@"body"];
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        // 转换成Dictionary格式
//        NSDictionary *dict = [NSDictionary dictionaryWithXMLData:responseObject];
//        if(dict != nil)
//        {
//            ////////////  第二步 调起支付接口
//            // 添加调起数据
//            PayReq* req             = [[PayReq alloc] init];
//            req.partnerId           = WeChatMCH_ID;
//            req.prepayId            = [dict objectForKey:@"prepay_id"];
//            req.nonceStr            = [dict objectForKey:@"nonce_str"];
//            req.timeStamp           = [[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] intValue];
//            req.package             = @"Sign=WXPay";
//            
//            // 添加签名数据并生成签名
//            NSMutableDictionary *rdict = [NSMutableDictionary dictionary];
//            [rdict setObject:WeChatAppID forKey:@"appid"];
//            [rdict setObject:req.partnerId forKey:@"partnerid"];
//            [rdict setObject:req.prepayId forKey:@"prepayid"];
//            [rdict setObject:req.nonceStr forKey:@"noncestr"];
//            [rdict setObject:[NSString stringWithFormat:@"%u",(unsigned int)req.timeStamp] forKey:@"timestamp"];
//            [rdict setObject:req.package forKey:@"package"];
//            NSDictionary *result = [AppMethod partnerSignOrder:rdict];
//            req.sign                = [result objectForKey:@"sign"];
//            
//            // 调起客户端
//            [WXApi sendReq:req];
//            // 返回结果 在WXApiManager中
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Error: %@", error);
//    }];
    
}


@end
