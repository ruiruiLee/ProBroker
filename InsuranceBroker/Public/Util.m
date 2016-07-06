//
//  Util.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/18.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "Util.h"
#import "define.h"
#import <CommonCrypto/CommonDigest.h>
@implementation Util


+ (NSString *)md5Hash:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result);
    NSString *md5Result = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5Result;
}

+ (BOOL) isNilOrNull:(id) obj
{
    BOOL flag = NO;
    
    if(obj == nil)
        flag = YES;
    else if([obj isKindOfClass:[NSNull class]])
        flag = YES;
    
    return flag;
}

+ (CGFloat) getHeightByWidth:(CGFloat) owidth height:(CGFloat) oheight nwidth:(CGFloat)nwidth
{
    CGFloat result = 0;
    
    result = (oheight * nwidth) / owidth;
    
    return result;
}

+ (NSMutableAttributedString*) SetLabelLineSpace:(CGFloat) spacing Text:(NSString*) string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableParagraphStyle *
    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    style.lineSpacing = 10;//增加行高
//    style.headIndent = 10;//头部缩进，相当于左padding
//    style.tailIndent = -10;//相当于右padding
    style.lineHeightMultiple = spacing;//行间距是多少倍
    style.alignment = NSTextAlignmentCenter;//对齐方式
//    style.firstLineHeadIndent = 20;//首行头缩进
//    style.paragraphSpacing = 10;//段落后面的间距
//    style.paragraphSpacingBefore = 20;//段落之前的间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [string length])];
    
    return attributedString;
}

//绘图
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (NSString *)getCurrentVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;
}

+ (void) setValueForKeyWithDic:(NSMutableDictionary *) mDic value:(id) value key:(NSString *) key
{
    if(value != nil && ![value isKindOfClass:[NSNull class]])
        [mDic setObject:value forKey:key];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    //手机号以13， 15，18开头，八个 \d 数字字符  14,17
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9])|(14[0,0-9]))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
//    return [phoneTest evaluateWithObject:mobileNum];
    if([mobileNum length] > 9 && [mobileNum length] < 13)
        return YES;
    else
        return NO;
}

+ (BOOL)isMobilePhoeNumber:(NSString *)mobileNum
{
//手机号以13， 15，18开头，八个 \d 数字字符  14,17
    mobileNum = [Util formatPhoneNum:mobileNum];
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9])|(14[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    NSLog(@"phoneTest is %@",phoneTest);
    bool result = [phoneTest evaluateWithObject:mobileNum];
    return result;
}

+(BOOL) checkPhoneNumInput:(NSString *)phone {
    phone = [Util formatPhoneNum:phone];
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    BOOL res1 = [regextestmobile evaluateWithObject:phone];
    
    if (res1 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)formatPhoneNum:(NSString *)phone
{
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([phone hasPrefix:@"86"]) {
        NSString *formatStr = [phone substringWithRange:NSMakeRange(2, [phone length]-2)];
        return formatStr;
    }
    else if ([phone hasPrefix:@"+86"])
    {
        if ([phone hasPrefix:@"+86·"]) {
            NSString *formatStr = [phone substringWithRange:NSMakeRange(4, [phone length]-4)];
            return formatStr;
        }
        else
        {
            NSString *formatStr = [phone substringWithRange:NSMakeRange(3, [phone length]-3)];
            return formatStr;
        }
    }
    return phone;
}

+ (void)showAlertMessage:(NSString*)msg
{
    UIAlertView * mAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
    [mAlert show];
}

+ (NSString *) getShowingTime:(NSDate *)date
{
//    NSDateFormatter *dateFormatter = [Util dateFormatterWithFormat:@"yyyy-MM-dd HH:mm"];
//    NSString *result = [dateFormatter stringFromDate:date];
    return [self compareDate:date];//result;
}

/**
 *  仿QQ空间时间显示
 *  @param string eg:2015年5月24日 02时21分30秒
 */
+ (NSString *)format:(NSString *)string{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    [inputFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    NSDate*inputDate = [inputFormatter dateFromString:string];
    //NSLog(@"startDate= %@", inputDate);
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //get date str
    NSString *str= [outputFormatter stringFromDate:inputDate];
    //str to nsdate
    NSDate *strDate = [outputFormatter dateFromString:str];
    //修正8小时的差时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: strDate];
    NSDate *endDate = [strDate  dateByAddingTimeInterval: interval];
    //NSLog(@"endDate:%@",endDate);
    NSString *lastTime = [self compareDate:endDate];
    NSLog(@"lastTime = %@",lastTime);
    return str;
}

+ (NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    //修正8小时之差
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate *localeDate = [date1  dateByAddingTimeInterval: interval];
    
    //NSLog(@"nowdate=%@\nolddate = %@",localeDate,date);
    NSDate *today = localeDate;
    NSDate *yesterday,*beforeOfYesterday;
    //今年
    NSString *toYears;
    
    toYears = [[today description] substringToIndex:4];
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    NSString *dateString = [Util getDayString:date];//[[date description] substringToIndex:10];
    NSString *dateYears = [[date description] substringToIndex:4];
    
    NSString *dateContent;
    if ([dateYears isEqualToString:toYears]) {//同一年
        //今 昨 前天的时间
        NSString *time = [Util getTimeSecString:date];
        //其他时间
        NSString *time2 = [Util getDayAndTimeString:date];//[[date description] substringWithRange:(NSRange){5,11}];
        if ([dateString isEqualToString:todayString]){
            dateContent = [NSString stringWithFormat:@"今天 %@",time];
            return dateContent;
        } else if ([dateString isEqualToString:yesterdayString]){
            dateContent = [NSString stringWithFormat:@"昨天 %@",time];
            return dateContent;
        }else if ([dateString isEqualToString:beforeOfYesterdayString]){
            dateContent = [NSString stringWithFormat:@"前天 %@",time];
            return dateContent;
        }else{
            return time2;
        }
    }else{
        return dateString;
    }
}


+ (NSString *) getTimeString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [Util dateFormatterWithFormat:@"yyyy-MM-dd HH:mm"];
    NSString *result = [dateFormatter stringFromDate:date];
    return result;
}

+ (NSString *) getDayString:(NSDate *) date
{
    NSDateFormatter *dateFormatter = [Util dateFormatterWithFormat:@"yyyy-MM-dd"];
    NSString *result = [dateFormatter stringFromDate:date];
    return result;
}

+ (NSString *) getDayStringWithCh:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [Util dateFormatterWithFormat:@"yyyy年 MM月 dd日"];
    NSString *result = [dateFormatter stringFromDate:date];
    return result;
}

+ (NSString *) getTimeSecString:(NSDate *) date
{
    NSDateFormatter *dateFormatter = [Util dateFormatterWithFormat:@"HH:mm"];
    NSString *result = [dateFormatter stringFromDate:date];
    return result;
}

+ (NSString *) getDayAndTimeString:(NSDate *) date
{
    NSDateFormatter *dateFormatter = [Util dateFormatterWithFormat:@"MM-dd HH:mm"];
    NSString *result = [dateFormatter stringFromDate:date];
    return result;
}

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *) format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return dateFormatter;
}

// 打开照相机
+ (void)openCamera:(UIViewController*)currentViewController allowEdit:(BOOL)allowEdit completion:(void (^)(void))completion
{
    UIImagePickerController  *picker = [[UIImagePickerController alloc] init];
    //
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        picker.delegate      = (id)currentViewController;
        picker.allowsEditing = allowEdit;
        picker.sourceType    = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        //
        [currentViewController presentViewController:picker animated:YES completion:completion];
    }
}

//打开相册
+ (void)openPhotoLibrary:(UIViewController*)currentViewController allowEdit:(BOOL)allowEdit completion:(void (^)(void))completion
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    //
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        pickerImage.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        pickerImage.delegate      = (id)currentViewController;
        pickerImage.allowsEditing = allowEdit;
        //
        [currentViewController presentViewController:pickerImage animated:YES completion:completion];
    }
}

+ (void)openCamera:(UIViewController*)currentViewController delegate:(id) delegate allowEdit:(BOOL)allowEdit completion:(void (^)(void))completion
{
    UIImagePickerController  *picker = [[UIImagePickerController alloc] init];
    //
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        picker.delegate      = (id)delegate;
        picker.allowsEditing = allowEdit;
        picker.sourceType    = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        //
        [currentViewController presentViewController:picker animated:YES completion:completion];
    }
}

+ (void)openPhotoLibrary:(UIViewController*)currentViewController delegate:(id) delegate allowEdit:(BOOL)allowEdit completion:(void (^)(void))completion
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    //
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        pickerImage.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        pickerImage.delegate      = (id)delegate;
        pickerImage.allowsEditing = allowEdit;
        //
        [currentViewController presentViewController:pickerImage animated:YES completion:completion];
    }
}

//图像等比例压缩 .充满空隙

+(UIImage *)fitSmallImage:(UIImage *)image scaledToSize:(CGSize)tosize
{
    if (!image)
    {
        return nil;
    }
    if (image.size.width<tosize.width && image.size.height<tosize.height)
    {
        return image;
    }
    CGFloat wscale = image.size.width/tosize.width;
    CGFloat hscale = image.size.height/tosize.height;
    CGFloat scale = (wscale>hscale)?wscale:hscale;
    CGSize newSize = CGSizeMake(image.size.width/scale, image.size.height/scale);
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(newSize);
    }
    CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

//图片等比例缩放,空隙由白色填充
+(UIImage*)scaleToSize:(UIImage*)CGImage scaledToSize:(CGSize)size
{
    CGFloat width = CGImage.size.width;
    CGFloat height = CGImage.size.height;
    
    if(width <= size.width && height <= size.height)
        return CGImage;
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = 0;//(size.width - width)/2;
    int yPos = 0;//(size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    // 绘制改变大小的图片xPos,yPos
    [CGImage drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (NSDate*) convertDateFromString:(NSString*)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH"];
    NSDate *date=[formatter dateFromString:string];
    return date;
}


//获取性别
+ (NSString *) getSexStringWithSex:(NSInteger) sex
{
    NSString *sexString = @"男";
    if (sex == 2) {
        sexString = @"女";
    }else if (sex == 0)
        sexString = @"";
    
    return sexString;
}

+ (NSString *) getAddrWithProvience:(NSString *)province city:(NSString *)city
{
    if(province == nil && city == nil){
        return @"请选择用户所在地区";
    }
    
    if(province == nil)
        province = @"";
    if(city == nil)
        city = @"";
    
    return [NSString stringWithFormat:@"%@  %@", province, city];
}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)value
{
//    BOOL flag;
//    if (identityCard.length <= 0) {
//        flag = NO;
//        return flag;
//    }
//    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
//    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
//    return [identityCardPredicate evaluateWithObject:identityCard];
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}

//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//车型
+ (BOOL) validateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}

//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

+ (NSString *) getStringByPlanType:(NSInteger) planType
{//0未选择(默认），1强制型，2大众型，3加强型，4自定义
    switch (planType) {
        case 0:
        {
            return @"未选择";
        }
            break;
        case 1:
        {
            return @"强制型";
        }
            break;
        case 2:
        {
            return @"大众型";
        }
            break;
        case 3:
        {
            return @"加强型";
        }
            break;
        case 4:
        {
            return @"自定义";
        }
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *) getDecimalStyle:(CGFloat) num
{
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
//    [numFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
    [numFormatter setPositiveFormat:@"###,##0.00;"];
    return [numFormatter stringFromNumber:[NSNumber numberWithFloat:num]];
}

+ (NSMutableAttributedString *)getWarningString:(NSString*) string
{
    NSString *UnitPrice = string;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [UnitPrice rangeOfString:@"＊"];
    [attString addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf4, 0x43, 0x36) range:range];
    return attString;
}

+ (NSMutableAttributedString *)getAttributeString:(NSString*) string substr:(NSString *)substr
{
    NSString *UnitPrice = string;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [UnitPrice rangeOfString:substr];
    [attString addAttribute:NSForegroundColorAttributeName value:_COLOR(0xff, 0x66, 0x19) range:range];
    return attString;
}

//获取用户名称
+ (NSString *) getUserName:(UserInfoModel*) model
{
    NSString *userName = model.realName;
    if(userName == nil || [userName length] == 0)
        userName = model.nickname;
    
    return userName;
}


+ (NSString *) getUserNameWithModel:(BrokerInfoModel*) model
{
    NSString *userName = model.realName;
    if(userName == nil || [userName length] == 0)
        userName = model.userName;
    
    return userName;
}

+ (NSString *) getUserNameWithPresentModel:(ParentInfoModel*) model
{
    NSString *userName = model.parentRealName;
    if(userName == nil || [userName length] == 0)
        userName = model.parentUserName;
    
    return userName;
}

+ (BOOL) checkInfoFull:(CarInfoModel*) carInfo
{
    BOOL result = NO;
    
    NSString *carNo = carInfo.carNo;
    if(([Util validateCarNo:carNo] ||  [self isNilValue:carInfo.travelCard1]) && carInfo.carInsurStatus1 && [self isNilValue:carInfo.carInsurCompId1]){
        return YES;
    }
    
//    NSString *carOwnerCard = carInfo.carOwnerCard;//身份证号
    NSDate *carRegTime = carInfo.carRegTime;//注册日期
    NSString *carEngineNo = carInfo.carEngineNo;////发动机号
    NSString *carShelfNo = carInfo.carShelfNo;//车架号
    NSString *carTypeNo = carInfo.carTypeNo;//品牌型号
    BOOL isCarInfo = NO;
    if([self isNilValue:carInfo.travelCard1] || (carRegTime != nil && ![BaseModel dateIsNil:carRegTime] && [self isNilValue:carEngineNo] && [self isNilValue:carShelfNo] && [self isNilValue:carTypeNo] && ([self isNilValue:carNo] || !carInfo.newCarNoStatus))){
        isCarInfo = YES;
        
        return YES;
    }
//    if(isCarInfo && ([self isNilValue:carInfo.carOwnerCard1] || [Util validateIdentityCard:carOwnerCard])){
//        return YES;
//    }
    
    return result;
}

+ (BOOL) isNilValue:(NSString *) value
{
    if(value == nil || [value length] == 0)
        return NO;
    else
        return YES;
}

//电子邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (void) addImagePath:(NSString *) path pathArray:(NSMutableArray *) pathArray smallImage:(UIImage *) small imageArray:(NSMutableArray *) imageArray
{
    if(path != nil && [path length] > 0){
        [pathArray addObject:path];
        if(small){
            [imageArray addObject:small];
        }else{
            [imageArray addObject:[UIImage imageNamed:@""]];
        }
    }
        
}

+ (void) weChatPay
{
    NSString *res = [WXApiRequestHandler jumpToBizPay];
    if( ![@"" isEqual:res] ){
        [Util showAlertMessage:@"支付失败"];
    }
}

@end
