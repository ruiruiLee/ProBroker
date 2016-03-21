//
//  OrderUtil.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/21.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "OrderUtil.h"
#import "OrderManagerTableViewCell.h"
#import "PolicyInfoTableViewCell.h"
#import "LeftImgButtonLeft.h"
#import "define.h"

@implementation OrderUtil

+ (void) setPolicyStatusWithTableCell:(PolicyInfoTableViewCell *) cell orderOfferStatus:(NSInteger) orderOfferStatus orderOfferStatusStr:(NSString*) orderOfferStatusStr orderOfferPrintStatus:(NSInteger) orderOfferPrintStatus
{
    LeftImgButtonLeft *btn = cell.btnStatus;
    [self checkOrderStatus:orderOfferStatus orderOfferPrintStatus:orderOfferPrintStatus orderOfferStatusStr:orderOfferStatusStr btn:btn];
}

+ (void) setPolicyStatusWithCell:(OrderManagerTableViewCell *) cell orderOfferStatus:(NSInteger) orderOfferStatus orderOfferStatusStr:(NSString *) orderOfferStatusStr orderOfferPrintStatus:(NSInteger) orderOfferPrintStatus
{
    LeftImgButtonLeft *btn = cell.btnStatus;
    [self checkOrderStatus:orderOfferStatus orderOfferPrintStatus:orderOfferPrintStatus orderOfferStatusStr:orderOfferStatusStr btn:btn];
}

//":"1"; //订单报价状态；1等待报价，2报价失败(读取失败原因,StatusId,StatusMsg），3报价完成，4出单配送-未付款（货到付款），5出单配送-付款中，6出单配送-已付款，7付款失败，8交易成功，9已过期，10禁止流程操作当扫表状态为1或2的时候，进行报价
/*
 desc : statusmsg
 orderOfferNums : 几分报价
 */
+ (NSMutableAttributedString *) getAttributedString:(NSString *)desc orderOfferNums:(NSInteger) orderOfferNums orderOfferStatus:(NSInteger) orderOfferStatus orderOfferPayPrice:(float) orderOfferPayPrice orderOfferStatusStr:(NSString *) orderOfferStatusStr orderOfferGatherStatus:(BOOL) orderOfferGatherStatus
{
    NSString *string = @"";
    if(orderOfferStatus == 2){
        string = desc;
        return [self attstringWithString:string range:NSMakeRange(0, [string length]) font:_FONT(12) color:_COLOR(0xf4, 0x43, 0x36)];
    }
    else if (orderOfferStatus == 1){}
    else if (orderOfferStatus == 3){
        string = [NSString stringWithFormat:@"共有%d份报价", orderOfferNums];
        return [self attstringWithString:string range:NSMakeRange(2, 1) font:_FONT(15) color:_COLOR(0xff, 0x66, 0x19)];
    }
    else if (orderOfferStatus == 4){
        string = desc;//@"未付款";
        if(orderOfferGatherStatus)
            return [self attstringWithString:string range:NSMakeRange(0, [string length]) font:_FONT(12) color:_COLOR(0x29, 0xcc, 0x5f)];
        else
            return [self attstringWithString:string range:NSMakeRange(0, [string length]) font:_FONT(12) color:_COLOR(0xf4, 0x43, 0x36)];
    }
    else if (orderOfferStatus == 5){
        string = desc;//@"付款中";
        return [self attstringWithString:string range:NSMakeRange(0, [string length]) font:_FONT(12) color:_COLOR(0x75, 0x75, 0x75)];
    }
    else if (orderOfferStatus == 6){
        string = desc;//@"已付款";
        if(!orderOfferGatherStatus)
            return [self attstringWithString:string range:NSMakeRange(0, [string length]) font:_FONT(12) color:_COLOR(0xf4, 0x43, 0x36)];
        else
            return [self attstringWithString:string range:NSMakeRange(0, [string length]) font:_FONT(12) color:_COLOR(0x29, 0xcc, 0x5f)];
    }
    else if (orderOfferStatus == 7){
        string = desc;//@"付款失败";
        return [self attstringWithString:string range:NSMakeRange(0, [string length]) font:_FONT(12) color:_COLOR(0xf4, 0x43, 0x36)];
    }
    else if (orderOfferStatus == 8){
        string = [NSString stringWithFormat:@"实付:¥%.2f", orderOfferPayPrice];
        return [self attstringWithString:string range:NSMakeRange(3, [string length] - 3) font:_FONT(18) color:_COLOR(0xf4, 0x43, 0x36)];
    }
    else if (orderOfferStatus == 9){
        string = desc;//@"保单过期";
        return [self attstringWithString:string range:NSMakeRange(0, [string length]) font:_FONT(12) color:_COLOR(0xf4, 0x43, 0x36)];
    }else{
        string = orderOfferStatusStr;
        if(string == nil)
            string = @"";
        return [self attstringWithString:string range:NSMakeRange(0, [string length]) font:_FONT(12) color:_COLOR(0xf4, 0x43, 0x36)];
    }
    
    return nil;
}

+ (void) checkOrderStatus:(NSInteger) orderOfferStatus orderOfferPrintStatus:(NSInteger) orderOfferPrintStatus orderOfferStatusStr:(NSString *) orderOfferStatusStr btn:(LeftImgButtonLeft *) btn
{
    NSString *title = @"";
    UIImage *image = nil;
    if(orderOfferStatus == 1){
        //        title = @"报价中";
        image = ThemeImage(@"price_loading");
    }
    else if(orderOfferStatus == 2){
        //        title = @"报价失败";
        image = ThemeImage(@"error");
    }
    else if (orderOfferStatus == 3){
        //        title = @"报价完成";
        image = ThemeImage(@"price_done");
    }
    else if (orderOfferStatus == 4){
        if(orderOfferPrintStatus == 2){
            //            title = @"出单配送";
            image = ThemeImage(@"deliver");
        }else{
            //            title = @"等待出单";
            image = ThemeImage(@"Issuing");
        }
    }
    else if (orderOfferStatus == 5){
        //        title = @"出单配送";
        image = ThemeImage(@"deliver");
    }
    else if (orderOfferStatus == 6){
        if(orderOfferPrintStatus == 2){
            //            title = @"出单配送";
            image = ThemeImage(@"deliver");
        }else{
            //            title = @"等待出单";
            image = ThemeImage(@"Issuing");
        }
    }
    else if (orderOfferStatus == 7){
        //        title = @"付款失败";
        image = ThemeImage(@"error");
    }
    else if (orderOfferStatus == 8){
        //        title = @"交易成功";
        image = ThemeImage(@"order_done");
    }
    else if (orderOfferStatus == 9){
        //        title = @"保单过期";
        image = ThemeImage(@"error");
    }else{
        image = ThemeImage(@"error");
    }
    
    title = orderOfferStatusStr;
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
}

+ (NSMutableAttributedString *) attstringWithString:(NSString *) string range:(NSRange) range font:(UIFont *) font color:(UIColor *)color
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attributedString addAttribute:NSFontAttributeName value:font range:range];
    
    return attributedString;
}

@end
