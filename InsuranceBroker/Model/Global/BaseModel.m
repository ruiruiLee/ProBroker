//
//  BaseModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/5.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (NSDate *)dateFromString:(NSString *)string
{
    @try {
        NSString *dateString = [string substringWithRange:NSMakeRange(0, 19)];
        NSDateFormatter *dateFormatter = [BaseModel dateFormatter];
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        return date;
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
        
    }
    
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return dateFormatter;
}

+ (NSString *)stringFromDate:(NSDate *)date;
{
    NSDateFormatter *dateFormatter = [BaseModel dateFormatter];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromInteger:(long long )integer
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:integer/1000];
    return date;
}

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    return nil;
}

+ (NSArray *) modelArrayFromArray:(NSArray *)array
{
    return nil;
}

//1 为空
+ (BOOL) dateIsNil:(NSDate *) date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger year= [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    if(day == 1 && month == 1 && year == 1900 && hour == 0 && minute == 0)
    {
        return YES;
    }
    
    return NO;
}

@end
