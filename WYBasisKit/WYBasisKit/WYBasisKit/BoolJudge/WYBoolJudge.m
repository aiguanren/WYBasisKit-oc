//
//  WY_BoolJudge.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//
/**
 *  正则表达式简单说明
 *  语法：
 .       匹配除换行符以外的任意字符
 \\w      匹配字母或数字或下划线或汉字
 \\s      匹配任意的空白符
 \\d      匹配数字
 \\b      匹配单词的开始或结束
 ^       匹配字符串的开始
 $       匹配字符串的结束
 *       重复零次或更多次
 +       重复一次或更多次
 ?       重复零次或一次
 {n}     重复n次
 {n,}     重复n次或更多次
 {n,m}     重复n到m次
 \\W      匹配任意不是字母，数字，下划线，汉字的字符
 \\S      匹配任意不是空白符的字符
 \\D      匹配任意非数字的字符
 \\B      匹配不是单词开头或结束的位置
 [^x]     匹配除了x以外的任意字符
 [^aeiou]匹配除了aeiou这几个字母以外的任意字符
 *?      重复任意次，但尽可能少重复
 +?      重复1次或更多次，但尽可能少重复
 ??      重复0次或1次，但尽可能少重复
 {n,m}?     重复n到m次，但尽可能少重复
 {n,}?     重复n次以上，但尽可能少重复
 \\a      报警字符(打印它的效果是电脑嘀一声)
 \\b      通常是单词分界位置，但如果在字符类里使用代表退格
 \\t      制表符，Tab
 \\r      回车
 \\v      竖向制表符
 \\f      换页符
 \\n      换行符
 \\e      Escape
 \\0nn     ASCII代码中八进制代码为nn的字符
 \\xnn     ASCII代码中十六进制代码为nn的字符
 \\unnnn     Unicode代码中十六进制代码为nnnn的字符
 \\cN     ASCII控制字符。比如\\cC代表Ctrl+C
 \\A      字符串开头(类似^，但不受处理多行选项的影响)
 \\Z      字符串结尾或行尾(不受处理多行选项的影响)
 \\z      字符串结尾(类似$，但不受处理多行选项的影响)
 \\G      当前搜索的开头
 \\p{name}     Unicode中命名为name的字符类，例如\\p{IsGreek}
 (?>exp)     贪婪子表达式
 (?<x>-<y>exp)     平衡组
 (?im-nsx:exp)     在子表达式exp中改变处理选项
 (?im-nsx)       为表达式后面的部分改变处理选项
 (?(exp)yes|no)     把exp当作零宽正向先行断言，如果在这个位置能匹配，使用yes作为此组的表达式；否则使用no
 (?(exp)yes)     同上，只是使用空表达式作为no
 (?(name)yes|no) 如果命名为name的组捕获到了内容，使用yes作为表达式；否则使用no
 (?(name)yes)     同上，只是使用空表达式作为no
 
 捕获
 (exp)               匹配exp,并捕获文本到自动命名的组里
 (?<name>exp)        匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp)
 (?:exp)             匹配exp,不捕获匹配的文本，也不给此分组分配组号
 零宽断言
 (?=exp)             匹配exp前面的位置
 (?<=exp)            匹配exp后面的位置
 (?!exp)             匹配后面跟的不是exp的位置
 (?<!exp)            匹配前面不是exp的位置
 注释
 (?#comment)         这种类型的分组不对正则表达式的处理产生任何影响，用于提供注释让人阅读
 */

#import "WYBoolJudge.h"
#import <CoreLocation/CoreLocation.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "NetworkMonitoring.h"

@implementation WYBoolJudge

/** 判断是否为纯数字 */
+ (BOOL)wy_isPureDigitalStr:(NSString *)string {
    
    NSString *regex =@"[0-9]*";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 判断是否为纯字母 */
+ (BOOL)wy_isPureLetters:(NSString *)string {
    
    NSString *regex = @"[a-zA-Z]*";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 判断是否为纯汉字 */
+ (BOOL)wy_isChineseCharacters:(NSString *)string {
    
    //中文编码范围是0x4e00~0x9fa5
    NSString *regex = @"[\u4e00-\u9fa5]+";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 判断是否包含字母 */
+ (BOOL)wy_isContainLetters:(NSString *)string {
    
    if (!string) {return NO;}
    
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    
    //count是str中包含[A-Za-z]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {return YES;}
    
    return NO;
}

/** 判断4-8位汉字：位数可更改 */
+ (BOOL)wy_combinationChineseCharacters:(NSString *)string {
    
    NSString *regex = @"^[\u4e00-\u9fa5]{4,8}$";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 判断仅字母或数字 */
+ (BOOL)wy_isLettersOrNumbers:(NSString *)string {
    
    NSString *regex =@"[a-zA-Z0-9]*";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 判断6-18位字母或数字组合：位数可更改 */
+ (BOOL)wy_combinationOfLettersOrNumbers:(NSString *)string {
    
    NSString *regex = @"^[A-Za-z0-9]{6,18}+$";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 判断仅中文、字母或数字 */
+ (BOOL)wy_isChineseOrLettersOrNumbers:(NSString *)string {
    
    NSString *regex = @"^[A-Za-z0-9\\u4e00-\u9fa5]+?$";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 判断6~18位字母开头，只能包含“字母”，“数字”，“下划线”：位数可更改 */
+ (BOOL)wy_isValidPassword:(NSString *)string {
    
    NSString *regex = @"^([a-zA-Z]|[a-zA-Z0-9_]|[0-9]){6,18}$";
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 判断是否为大写字母 */
+ (BOOL)wy_isCapitalLetters:(NSString *)string {
    
    NSString *regex =@"[A-Z]*";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 判断是否为小写字母 */
+ (BOOL)wy_isLowercaseLetters:(NSString *)string {
    
    NSString *regex =@"[a-z]*";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 判断是否以字母开头 */
+ (BOOL)wy_isLettersBegin:(NSString *)string {
    
    if(string.length <= 0) {
        
        return NO;
        
    }else {
        
        NSString *firstStr = [string substringToIndex:1];
        
        NSString *regex = @"[a-zA-Z]*";
        
        return [self wy_isValidateByRegex:regex Object:firstStr];
    }
}

/** 判断是否以汉字开头 */
+ (BOOL)wy_isChineseBegin:(NSString *)string {
    
    if(string.length <= 0) {
        
        return NO;
        
    }else {
        
        NSString *firstStr = [string substringToIndex:1];
        
        NSString *regex = @"[\u4e00-\u9fa5]+";
        
        return [self wy_isValidateByRegex:regex Object:firstStr];
    }
}

/** 验证手机号 非严谨:1开头11位纯数字 */
+ (BOOL)wy_isMobileNumber:(NSString *)string {
    
    if(string.length <= 0) {
        
        return NO;
    }
    if(![[string substringToIndex:1]isEqualToString:@"1"]) {
        return NO;
    }
    if(![self wy_isPureDigitalStr:string]) {
        return NO;
    }
    if(string.length != 11) {
        return NO;
    }
    return YES;
}

/** 验证手机号 严谨:运营商号段 */
+ (BOOL)wy_isPhoneNumber:(NSString *)string {
    
    if(string.length != 11) {
        
        return NO;
    }else {
        
        /**
         * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         * 联通号段: 130,131,132,155,156,185,186,145,176,1709
         * 电信号段: 133,153,180,181,189,177,1700
         */
        
        /**
         * 手机号段正则表达式
         */
        NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
        
        return [self wy_isValidateByRegex:MOBILE Object:string];
    }
}

/** 验证运营商:移动 */
+ (BOOL)wy_isMobilePperators:(NSString *)string {
    
    if(string.length != 11) {
        
        return NO;
    }else {
        
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        
        return [self wy_isValidateByRegex:CM_NUM Object:string];
    }
}

/** 验证运营商:联通 */
+ (BOOL)wy_isUnicomPperators:(NSString *)string {
    
    if(string.length != 11) {
        
        return NO;
    }else {
        
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        return [self wy_isValidateByRegex:CU_NUM Object:string];
    }
}

/** 验证运营商:电信 */
+ (BOOL)wy_isTelecomPperators:(NSString *)string {
    
    if(string.length != 11) {
        
        return NO;
    }else {
        
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
        
        return [self wy_isValidateByRegex:CT_NUM Object:string];
    }
}

/** 验证邮箱 */
+ (BOOL)wy_isValidateEmail:(NSString *)string {
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 简单验证身份证 */
+ (BOOL)wy_simpleVerifyIdentityCard:(NSString *)string {
    
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 精确验证15或18位身份证 */
+ (BOOL)wy_accurateVerifyIDCardNumber:(NSString *)string {
    
    /*
     身份证基础知识：
     身份证是国民的身份编号，编号是有一定规律的，这里介绍身份证验证规则比较详细。项目中经常会需要对身份证进行校验，我们先了解一些基本知识，然后分析代码
     居民身份证号码，根据〖中华人民共和国国家标准 GB 11643-1999〗中有关公民身份号码的规定，公民身份号码是特征组合码，由十七位数字本体码和一位数字校验码组成。排列顺序从左至右依次为：六位数字地址码，八位数字出生日期码，三位数字顺序码和一位数字校验码。 居民身份证是国家法定的证明公民个人身份的有效证件。
     结构和形式
     1．号码的结构
     　  公民身份号码是特征组合码，由十七位数字本体码和一位校验码组成。排列顺序从左至右依次为：六位数字地址码，八位数字出生日期码，三位数字顺序码和一位数字校验码。
     2．地址码
     　  表示编码对象常住户口所在县（市、旗、区）的行政区划代码，按GB/T2260的规定执行。
     3．出生日期码
     　  表示编码对象出生的年、月、日，按GB/T7408的规定执行，年、月、日代码之间不用分隔符。
     4．顺序码
     　  表示在同一地址码所标识的区域范围内，对同年、同月、同日出生的人编定的顺序号，顺序码的奇数分配给男性，偶数分配给女性。
     5．校验码
     　 根据前面十七位数字码，按照ISO7064:1983.MOD11-2校验码计算出来的检验码。
     地址码
     华北地区： 北京市|110000，天津市|120000，河北省|130000，山西省|140000，内蒙古自治区|150000，
     东北地区： 辽宁省|210000，吉林省|220000，黑龙江省|230000，
     华东地区： 上海市|310000，江苏省|320000，浙江省|330000，安徽省|340000，福建省|350000，江西省|360000，山东省|370000，
     华中地区： 河南省|410000，湖北省|420000，湖南省|430000，
     华南地区： 广东省|440000，广西壮族自治区|450000，海南省|460000，
     西南地区： 重庆市|500000，四川省|510000，贵州省|520000，云南省|530000，西藏自治区|540000，
     西北地区： 陕西省|610000，甘肃省|620000，青海省|630000，宁夏回族自治区|640000，新疆维吾尔自治区|650000，
     特别地区：台湾地区(886)|710000，香港特别行政区（852)|810000，澳门特别行政区（853)|820000
     中国大陆居民身份证号码中的地址码的数字编码规则为：
     第一、二位表示省（自治区、直辖市、特别行政区）。
     第三、四位表示市（地级市、自治州、盟及国家直辖市所属市辖区和县的汇总码）。其中，01-20，51-70表示省直辖市；21-50表示地区（自治州、盟）。
     第五、六位表示县（市辖区、县级市、旗）。01-18表示市辖区或地区（自治州、盟）辖县级市；21-80表示县（旗）；81-99表示省直辖县级市。
     生日期码
     （身份证号码第七位到第十四位）表示编码对象出生的年、月、日，其中年份用四位数字表示，年、月、日之间不用分隔符。例如：1981年05月11日就用19810511表示。
     顺序码
     （身份证号码第十五位到十七位）地址码所标识的区域范围内，对同年、月、日出生的人员编定的顺序号。其中第十七位奇数分给男性，偶数分给女性
     校验码
     作为尾号的校验码，是由号码编制单位按统一的公式计算出来的，如果某人的尾号是0-9，都不会出现X，但如果尾号是10，那么就得用X来代替，因为如果用10做尾号，那么此人的身份证就变成了19位，而19位的号码违反了国家标准，并且中国的计算机应用系统也不承认19位的身份证号码。Ⅹ是罗马数字的10，用X来代替10，可以保证公民的身份证符合国家标准。
     身份证校验码的计算方法
     1、将前面的身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。
     2、将这17位数字和系数相乘的结果相加。
     3、用加出来和除以11，看余数是多少？
     4、余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字。其分别对应的最后一位身份证的号码为1－0－X－9－8－7－6－5－4－3－2。(即余数0对应1，余数1对应0，余数2对应X...)
     5、通过上面得知如果余数是3，就会在身份证的第18位数字上出现的是9。如果对应的数字是2，身份证的最后一位号码就是罗马数字x。
     例如：某男性的身份证号码为【53010219200508011x】，我们看看这个身份证是不是合法的身份证。
     首先我们得出前17位的乘积和【(5*7)+(3*9)+(0*10)+(1*5)+(0*8)+(2*4)+(1*2)+(9*1)+(2*6)+(0*3)+(0*7)+(5*9)+(0*10)+(8*5)+(0*8)+(1*4)+(1*2)】是189，然后用189除以11得出的结果是189/11=17----2，也就是说其余数是2。最后通过对应规则就可以知道余数2对应的检验码是X。所以，可以判定这是一个正确的身份证号码。
     */
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!string) {
        return NO;
    }else {
        length = (int)string.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [string substringToIndex:2];
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
            year = [string substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:string
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, string.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [string substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:string
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, string.length)];
            
            if(numberofMatch >0) {
                int S = ([string substringWithRange:NSMakeRange(0,1)].intValue + [string substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([string substringWithRange:NSMakeRange(1,1)].intValue + [string substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([string substringWithRange:NSMakeRange(2,1)].intValue + [string substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([string substringWithRange:NSMakeRange(3,1)].intValue + [string substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([string substringWithRange:NSMakeRange(4,1)].intValue + [string substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([string substringWithRange:NSMakeRange(5,1)].intValue + [string substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([string substringWithRange:NSMakeRange(6,1)].intValue + [string substringWithRange:NSMakeRange(16,1)].intValue) *2 + [string substringWithRange:NSMakeRange(7,1)].intValue *1 + [string substringWithRange:NSMakeRange(8,1)].intValue *6 + [string substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[string substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

/** 精确验证18位身份证 */
+ (BOOL)wy_validationCardNumberFor18:(NSString *)string {
    
    if (string.length!=18) {
        return NO;
    }
    
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:string];
    
    if (!flag) {
        return flag;  //格式错误
    }else {
        //格式正确在判断是否合法
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++){
            NSInteger subStrIndex = [[string substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            idCardWiSum+= subStrIndex * idCardWiIndex;
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [string substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]){
                return YES;
            }else{
                return NO;
            }
        }
    }
}

/** 验证车型 */
+ (BOOL)wy_validateCarType:(NSString *)string {
    
    NSString *regex = @"^[\\u4E00-\\u9FFF]+$";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 车牌号的有效性验证 */
+ (BOOL)wy_isLicensePlate:(NSString *)string {
    
    //车牌号:湘K-DE829 香港车牌号码:粤Z-J499港
    //其中\\u4e00-\\u9fa5表示unicode编码中汉字已编码部分，\\u9fa5-\\u9fff是保留部分，将来可能会添加
    NSString *regex = @"^[\\u4e00-\\u9fff]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\\u4e00-\\u9fff]$";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** IP地址有效性 */
+ (BOOL)wy_isIPAddress:(NSString *)string {
    
    NSString *regex = [NSString stringWithFormat:@"^(\\\\d{1,3})\\\\.(\\\\d{1,3})\\\\.(\\\\d{1,3})\\\\.(\\\\d{1,3})$"];
    BOOL rc = [self wy_isValidateByRegex:regex Object:string];
    
    if (rc) {
        
        NSArray *componds = [string componentsSeparatedByString:@","];
        
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }
        return v;
    }
    return NO;
}

/** MAC地址有效性 */
+ (BOOL)wy_isMacAddress:(NSString *)string {
    
    NSString *regex = @"([A-Fa-f\\\\d]{2}:){5}[A-Fa-f\\\\d]{2}";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 邮编有效性 */
+ (BOOL)wy_isValidPostalcode:(NSString *)string {
    
    NSString *regex = @"^[0-8]\\\\d{5}(?!\\\\d)$";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 验证表情 */
+ (BOOL)wy_stringContainsEmoji:(NSString *)string {
    
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

/** 工商税号有效性 */
+ (BOOL)wy_isValidTaxNumber:(NSString *)string {
    
    NSString *regex = @"[0-9]\\\\d{13}([0-9]|X)$";
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 判断是否开启了定位 */
+ (BOOL)wy_isOpenLocationService {
    
    CLAuthorizationStatus type = [CLLocationManager authorizationStatus];
    if (![CLLocationManager locationServicesEnabled] || type == kCLAuthorizationStatusDenied) {
        
        //[CLLocationManager locationServicesEnabled]是检测系统定位是否打开。
        //[CLLocationManager authorizationStatus];是检测用户是否对本应用打开定位权限。
        return NO;
    }
    
    return YES;
}

/** 验证银行卡号有效性 */
+ (BOOL)wy_isBankCardNumber:(NSString *)string {
    
    NSString * lastNum = [[string substringFromIndex:(string.length-1)] copy];//取出最后一位
    NSString * forwardNum = [[string substringToIndex:(string.length -1)] copy];//前15或18位
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<forwardNum.length; i++) {
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i=0; i< forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i%2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }else{//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }else{
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal%10 ==0)?YES:NO;
}

/** 是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字 */
+ (BOOL)wy_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal
                       content:(NSString *)string {
    
    NSString *hanzi = containChinese ? @"\\u4e00-\\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    
    NSString *regex = [NSString stringWithFormat:@"%@[%@A-Za-z0-9_]{%d,%d}", first, hanzi, (int)(minLenth-1), (int)(maxLenth-1)];
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字 */
+ (BOOL)wy_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
                 containDigtal:(BOOL)containDigtal
                 containLetter:(BOOL)containLetter
         containOtherCharacter:(NSString *)containOtherCharacter
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal
                       content:(NSString *)string {
    
    NSString *hanzi = containChinese ? @"\\u4e00-\\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    NSString *lengthRegex = [NSString stringWithFormat:@"(?=^.{%@,%@}$)", @(minLenth), @(maxLenth)];
    NSString *digtalRegex = containDigtal ? @"(?=(.*\\\\d.*){1})" : @"";
    NSString *letterRegex = containLetter ? @"(?=(.*[a-zA-Z].*){1})" : @"";
    NSString *characterRegex = [NSString stringWithFormat:@"(?:%@[%@A-Za-z0-9%@]+)", first, hanzi, containOtherCharacter ? containOtherCharacter : @""];
    NSString *regex = [NSString stringWithFormat:@"%@%@%@%@", lengthRegex, digtalRegex, letterRegex, characterRegex];
    
    return [self wy_isValidateByRegex:regex Object:string];
}

/** 是否能够匹配正则表达式 */
+ (BOOL)wy_matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options content:(NSString *)string {
    
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:NULL];
    if (!pattern) return NO;
    
    return ([pattern numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)] > 0);
}

//验证正则表达式
+ (BOOL)wy_isValidateByRegex:(NSString *)regex Object:(NSString *)object {
    
    if(object.length <= 0) {
        
        return NO;
    }else {
        
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return [pre evaluateWithObject:object];
    }
}

//权限判断
+ (BOOL)wy_authorityManagement:(WYPermissionType)mediaType superController:(UIViewController *)superController {
    
    if(mediaType == WYPermissionTypeCamera) {
        
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {//判断操作是否被允许
            
            //提醒用户打开权限开关
            [self wy_showAlert:@"相机" superController:superController];
            return NO;
        }
    }
    
    else if (mediaType == WYPermissionTypeAlbum) {
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
            
            //提醒用户打开权限开关
            [self wy_showAlert:@"相册" superController:superController];
            return NO;
        }
    }
    
    else if (mediaType == WYPermissionTypeMicrophone) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        
        int status = 0;
        switch (authStatus) {
            case AVAuthorizationStatusNotDetermined:
                //表明用户尚未选择关于客户端是否可以访问硬件
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    if (granted) {
                        NSLog(@"请求完成！");
                    } else {
                        NSLog(@"失败");
                    }
                }];
                status = 2;
                break;
            case AVAuthorizationStatusRestricted:
                //未授权，家长限制
                break;
            case AVAuthorizationStatusDenied:
                //用户已经明确否认了这个应用程序访问权限
                break;
            case AVAuthorizationStatusAuthorized:
                //已授权
                status = 1;
                break;
            default:
                break;
        }
        if (status == 0) {
            //提醒用户打开权限开关
            [self wy_showAlert:@"麦克风" superController:superController];
        }
        return status;
    }
    else  {
        
        if([NetworkMonitoring sharedNetworkMonitoring].networkStatus == NetworkStatusNotReachable) {
            
            [self wy_showAlertStr:@"网络连接错误，请检查您的网络设置!" superController:superController];
            return NO;
            
        }else {
            
            CLAuthorizationStatus type = [CLLocationManager authorizationStatus];
            if (![CLLocationManager locationServicesEnabled] || type == kCLAuthorizationStatusDenied) {//判断定位操作是否被允许
                
                //提醒用户打开权限开关
                [self wy_showAlert:@"定位" superController:superController];
                
                return NO;
            }
        }
    }
    
    return YES;
}

+ (void)wy_showAlert:(NSString *)mediaType superController:(UIViewController *)superController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您尚未开启%@权限，立即开启?",mediaType] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    
    [superController presentViewController:alert animated:YES completion:nil];
}

+ (void)wy_showAlertStr:(NSString *)alertStr superController:(UIViewController *)superController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];
    [alert addAction:sureAction];
    
    [superController presentViewController:alert animated:YES completion:nil];
}

@end
