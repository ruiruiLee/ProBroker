//
//  OrderUtil.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/21.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderManagerTableViewCell;
@class PolicyInfoTableViewCell;

@interface OrderUtil : NSObject

+ (void) setPolicyStatusWithTableCell:(PolicyInfoTableViewCell *) cell orderOfferStatus:(NSInteger) orderOfferStatus orderOfferStatusStr:(NSString*) orderOfferStatusStr orderOfferPrintStatus:(NSInteger) orderOfferPrintStatus;

+ (void) setPolicyStatusWithCell:(OrderManagerTableViewCell *) cell orderOfferStatus:(NSInteger) orderOfferStatus orderOfferStatusStr:(NSString *) orderOfferStatusStr orderOfferPrintStatus:(NSInteger) orderOfferPrintStatus;

+ (NSMutableAttributedString *) getAttributedString:(NSString *)desc orderOfferNums:(NSInteger) orderOfferNums orderOfferStatus:(NSInteger) orderOfferStatus orderOfferPayPrice:(float) orderOfferPayPrice orderOfferStatusStr:(NSString *) orderOfferStatusStr orderOfferGatherStatus:(BOOL) orderOfferGatherStatus;

+ (NSMutableAttributedString *) attstringWithString:(NSString *) string range:(NSRange) range font:(UIFont *) font color:(UIColor *)color;

@end