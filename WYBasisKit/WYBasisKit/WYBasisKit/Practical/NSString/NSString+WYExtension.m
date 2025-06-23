//
//  NSString+WYExtension.m
//  WYBasisKit
//
//  Created by guanren on 17/2/12.
//  Copyright © 2017年 com.guanren. All rights reserved.
//

#import "NSString+WYExtension.h"
#import "WYBoolJudge.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/utsname.h>
#import <CoreText/CoreText.h>

@implementation NSString (WYExtension)

+ (NSString *)wy_emptyStr:(NSString *)string {
    
    if(([string isKindOfClass:[NSNull class]]) || ([string isEqual:[NSNull null]]) || (string == nil) || (!string)) {
        
        string = @"";
    }
    
    return string;
}

+ (BOOL)wy_isEmptyStr:(NSString *)string {
    
    if(([string isKindOfClass:[NSNull class]]) || ([string isEqual:[NSNull null]]) || (string == nil) || (!string) || (string.length <= 0)) {
        
        return YES;
    }
    
    return NO;
}

/** 获取手机号运营商 */
+ (NSString *)wy_mobilePhoneOperators:(NSString *)string {
    
    return [WYBoolJudge wy_isMobilePperators:string] ? @"中国移动": ([WYBoolJudge wy_isUnicomPperators:string] ? @"中国联通": ([WYBoolJudge wy_isTelecomPperators:string] ? @"中国电信": @"未知"));
}

/** 返回一个计算好的字符串的高度和宽度 */
- (CGSize)wy_boundingRectWithSize:(CGSize)size withFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineSpacing];
    NSDictionary *attribute = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    CGSize retSize = [self boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
}

/** 获取每行显示的文本及显示完整总共需要的行数 */
- (NSArray *)wy_textShowLinesWithControlWidth:(CGFloat)controlWidth font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
    
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString wy_emptyStr:self]];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,controlWidth,MAXFLOAT));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [[NSString wy_emptyStr:self] substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    
    return (NSArray *)linesArray;
}

/** 计算显示文本到指定行数时需要的高度 */
- (CGFloat)wy_textHeightWithSpecifyRow:(NSInteger)specifyRow font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
    
    return (font.lineHeight+lineSpacing)*specifyRow;
}

/** 将中文转换成UTF8编码格式 */
+ (NSString *)wy_UTF8StrFromChinese:(NSString *)chineseStr {
    
    return [chineseStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

/** 将UTF8编码解码 */
+ (NSString *)wy_chineseStrFromUTF8Str:(NSString *)UTF8Str {
    
    return [UTF8Str stringByRemovingPercentEncoding];
}

/** 时间戳--->年月日-时间 */
+ (NSString *)wy_convertToDateTime:(NSString *)timestamp {
    
    NSTimeInterval time = [timestamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

/** 时间戳--->年月日 小时-分-秒 */
+ (NSString *)wy_convertToDateTimer:(NSString *)timestamp {
    
    NSTimeInterval time = [timestamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

/** 时间戳--->日期 */
+ (NSString *)wy_convertToDate:(NSString *)timestamp {
    
    NSTimeInterval time = [timestamp doubleValue];//如果不使用本地时区,因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

//** 时间戳--->时间 */
+ (NSString *)wy_convertToTime:(NSString *)timestamp {
    
    NSTimeInterval time = [timestamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

/** 时间---->时间戳 */
+ (NSString *)wy_convertTotimeSp:(NSString *)timeStr {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];//时间戳
    
    return timestamp;
}

/**
 *  获得与当前时间的差距
 */
+ (NSString *)wy_timeDifferenceWithNowTimer:(NSString *)timerSp {
    
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 后台时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime =[timerSp floatValue];
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
     //刚刚
     NSInteger small = time / 60;
     if (small <= 0) {
         return [NSString stringWithFormat:@"刚刚"];
     }
    
     //秒转分钟
     if (small < 60) {
         return [NSString stringWithFormat:@"%ld分钟前",(long)small];
     }
     
     // 秒转小时
     NSInteger hours = time/3600;
     if (hours<24) {
         return [NSString stringWithFormat:@"%ld小时前",(long)hours];
     }
     //秒转天数
     NSInteger days = time/3600/24;
     if (days < 30) {
         return [NSString stringWithFormat:@"%ld天前",(long)days];
     }
     //秒转月
     NSInteger months = time/3600/24/30;
     if (months < 12) {
         return [NSString stringWithFormat:@"%ld月前",(long)months];
     }
     //秒转年
     NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",(long)years];
    
     return [self wy_convertToDate:timerSp];
}

/** 时间戳转星座
 
 摩羯座 12月22日------1月19日
 水瓶座 1月20日-------2月18日
 双鱼座 2月19日-------3月20日
 白羊座 3月21日-------4月19日
 金牛座 4月20日-------5月20日
 双子座 5月21日-------6月21日
 巨蟹座 6月22日-------7月22日
 狮子座 7月23日-------8月22日
 处女座 8月23日-------9月22日
 天秤座 9月23日------10月23日
 天蝎座 10月24日-----11月21日
 射手座 11月22日-----12月21日
 
 */
+ (NSString *)wy_timestampToConstellation:(NSString *)timerSp {
    
    //计算月份
    NSString *date = [self wy_convertToDate:timerSp];
    NSString *retStr=@"";
    NSString *birthStr = [date substringFromIndex:5];
    int month=0;
    NSString *theMonth = [birthStr substringToIndex:2];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        month = [[theMonth substringFromIndex:1] intValue];
    }else{
        month = [theMonth intValue];
    }
    //计算天数
    int day=0;
    NSString *theDay = [birthStr substringFromIndex:3];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        day = [[theDay substringFromIndex:1] intValue];
    }else {
        day = [theDay intValue];
    }
    
    if (month<1 || month>12 || day<1 || day>31){
        return @"错误日期格式!";
    }
    if(month==2 && day>29) {
        return @"错误日期格式!!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    retStr=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    return [NSString stringWithFormat:@"%@座",retStr];
}

/** 根据时间戳算年龄 */
+ (NSString *)wy_timestampToAge:(NSString *)timerSp {
    
    NSString *dateString = [self wy_convertToDate:timerSp];
    NSString *year = [dateString substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [dateString substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [dateString substringWithRange:NSMakeRange(dateString.length-2, 2)];
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDateComponents *compomemts = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    NSInteger nowYear = compomemts.year;
    NSInteger nowMonth = compomemts.month;
    NSInteger nowDay = compomemts.day;
    
    // 计算年龄
    NSInteger userAge = nowYear - year.intValue - 1;
    if ((nowMonth > month.intValue) || (nowMonth == month.intValue && nowDay >= day.intValue)) {
        userAge++;
    }
    return [NSString stringWithFormat:@"%ld",(long)userAge];
}

/** 获取手机时间戳 */
+ (NSString *)wy_getCurrentTimeSp {
    
    NSDate *date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeSp;
}

/** 获取网络时间戳*/
+ (NSString *)wy_getNetworkTimeSp {
    
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
    
    return [NSString stringWithFormat:@"%ld", (long)[netDate timeIntervalSince1970]];
}

/** 图片转字符串 */
+ (NSString *)wy_UIImageToBase64Str:(UIImage *)image {
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedImageStr;
}

/** 去除字符串中的空格 */
+ (NSString *)wy_wipeSpaceFromStr:(NSString *)str {
    
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [str componentsSeparatedByCharactersInSet:whitespaces];//在空格处将字符串分割成一个 NSArray
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];//去除空串
    NSString *jointStr  = @"";
    str = [filteredArray componentsJoinedByString:jointStr];
    
    return str;
}

/** 去除字符串两端的空格 */
+ (NSString *)wy_wipeBothEndsSpaceFromStr:(NSString *)str {
    
    NSString *s = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//该方法是去掉两端的空格
    
    //NSString *s =  [s stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];//该方法也可以
    
    return s;
}

/** 去除字符串中的特定符号 */
+ (NSString *)wy_wipeAppointSymbolFromStr:(NSString *)str AppointSymbol:(NSString *)appointSymbol WithStr:(NSString *)replacement {
    
    NSString *b = [str stringByReplacingOccurrencesOfString:appointSymbol withString:replacement];//该方法是去掉指定符号
    return b;
}

/** 获取设备ip地址*/
+ (NSString *)wy_getDeviceIpAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

/** 返回一个包含匹配正则表达式的新字符串替换为模版字符串 */
+ (NSString *)wy_stringByReplacingRegex:(NSString *)regex
                             options:(NSRegularExpressionOptions)options
                          withString:(NSString *)replacement content:(NSString *)string {
    
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!pattern) return string;
    return [pattern stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:replacement];
}

/** 匹配正则表达式，并使用匹配的每个对象执行给定的块 */
+ (void)wy_enumerateRegexMatches:(NSString *)regex
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block content:(NSString *)string {
    
    if (regex.length == 0 || !block) return;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!regex) return;
    [pattern enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        block([string substringWithRange:result.range], result.range, stop);
    }];
}

/** 根据银行卡号获取所属银行 */
+ (NSString *)wy_getBankName:(NSString *)string {
    
    if(string==nil || string.length<16 || string.length>19){
        NSLog(@"传入的银行卡号不合法");
        return @"";
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"plist"];
    NSDictionary* resultDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *bankBin = resultDic.allKeys;
    
    //6位Bin号
    NSString *cardbin_6 = [string substringWithRange:NSMakeRange(0, 6)];
    //8位Bin号
    NSString *cardbin_8 = [string substringWithRange:NSMakeRange(0, 8)];
    
    if ([bankBin containsObject:cardbin_6]) {
        return [resultDic objectForKey:cardbin_6];
    }else if ([bankBin containsObject:cardbin_8]){
        return [resultDic objectForKey:cardbin_8];
    }else{
        NSLog(@"plist文件中不存在请自行添加对应卡种");
        return @"";
    }
    return @"";
}

/**
 获取苹果设备型号
 */
+ (NSString *)wy_appleDiviceType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

+ (NSString *)wy_spacingBankCardNumber:(NSString *)bankCardNumber {
    
    NSString *tmpStr = bankCardNumber;
    NSInteger size = (tmpStr.length / 4);
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++)
    {
        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    
    [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
    
    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
    
    return tmpStr;
}

+ (NSString *)wy_bankCardNumberRemoveSpacing:(NSString *)bankCardNumber {
    
    return [bankCardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (NSString *)wy_securityBankCard:(NSString *)bankCardNumber {
    
    NSString *IDCard =  bankCardNumber;
    if(IDCard.length > 10){
        return [NSString stringWithFormat:@"%@********%@",[IDCard substringToIndex:6], [IDCard substringFromIndex:IDCard.length-4]];
    }else if(IDCard.length > 4){
        return [NSString stringWithFormat:@"********%@", [IDCard substringFromIndex:IDCard.length-4]];
    }
    return IDCard;
}

//将 &lt 等类似的字符转化为HTML中的“<”等
+ (NSString *)wy_htmlEntityDecode:(NSString *)string {
    
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

/** 字符串反转 */
- (NSString *)wy_stringInversion {
    
    NSMutableString *reverString = [NSMutableString stringWithCapacity:self.length];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reverString appendString:substring];
    }];
    return reverString;
}

/** 获取汉字的拼音 */
- (NSString *)wy_pinyinTransform:(NSString *)chineseStr {
    
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chineseStr mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    //返回最近结果
    return pinyin;
}

@end
