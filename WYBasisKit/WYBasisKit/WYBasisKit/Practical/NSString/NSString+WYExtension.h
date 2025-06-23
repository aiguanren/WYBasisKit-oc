//
//  NSString+WYExtension.h
//  WYBasisKit
//
//  Created by guanren on 17/2/12.
//  Copyright © 2017年 com.guanren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (WYExtension)

/**
 获取非空字符串
 */
+ (NSString *)wy_emptyStr:(NSString *)string;

/**
 是否是空字符串
 */
+ (BOOL)wy_isEmptyStr:(NSString *)string;

/** 获取手机号运营商 */
+ (NSString *)wy_mobilePhoneOperators:(NSString *)string;

/** 根据银行卡号获取所属银行 */
+ (NSString *)wy_getBankName:(NSString *)string;

/** 正常号转银行卡号 － 增加4位间的空格 */
+ (NSString *)wy_spacingBankCardNumber:(NSString *)bankCardNumber;

/** 银行卡号转正常号 － 去除4位间的空格 */
+ (NSString *)wy_bankCardNumberRemoveSpacing:(NSString *)bankCardNumber;

/** 银行卡号安全化 格式为****1234保留最后4位 */
+ (NSString *)wy_securityBankCard:(NSString *)bankCardNumber;

/** 格式化HTML代码 */
+ (NSString *)wy_htmlEntityDecode:(NSString *)string;

/** 字符串反转 */
- (NSString *)wy_stringInversion;

/** 获取汉字的拼音 */
- (NSString *)wy_pinyinTransform:(NSString *)chineseStr;

/** 返回一个计算好的字符串的高度和宽度 */
- (CGSize)wy_boundingRectWithSize:(CGSize)size withFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

/** 获取每行显示的文本及显示完整总共需要的行数(array.count即需要的行数) */
- (NSArray *)wy_textShowLinesWithControlWidth:(CGFloat)controlWidth font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

/** 计算显示文本到指定行数时需要的高度 */
- (CGFloat)wy_textHeightWithSpecifyRow:(NSInteger)specifyRow font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

/** 将中文转换成UTF8编码格式 */
+ (NSString *)wy_UTF8StrFromChinese:(NSString *)chineseStr;

/** 将UTF8编码解码 */
+ (NSString *)wy_chineseStrFromUTF8Str:(NSString *)UTF8Str;

/** 时间戳--->年月日 小时-分 */
+ (NSString *)wy_convertToDateTime:(NSString *)timestamp;

/** 时间戳--->年月日 小时-分-秒 */
+ (NSString *)wy_convertToDateTimer:(NSString *)timestamp;

/** 时间戳--->日期 */
+ (NSString *)wy_convertToDate:(NSString *)timestamp;

//** 时间戳--->时间 */
+ (NSString *)wy_convertToTime:(NSString *)timestamp;

/** 时间---->时间戳 */
+ (NSString *)wy_convertTotimeSp:(NSString *)timeStr;

/**
 *  获得与当前时间的差距
 */
+ (NSString *)wy_timeDifferenceWithNowTimer:(NSString *)timerSp;

/** 时间戳转星座 */
+ (NSString *)wy_timestampToConstellation:(NSString *)timerSp;

/** 根据时间戳算年龄 */
+ (NSString *)wy_timestampToAge:(NSString *)timerSp;

/** 获取手机时间戳 */
+ (NSString *)wy_getCurrentTimeSp;

/** 获取网络时间戳*/
+ (NSString *)wy_getNetworkTimeSp;

/** 图片转字符串 */
+ (NSString *)wy_UIImageToBase64Str:(UIImage *)image;

/** 去除字符串中的空格 */
+ (NSString *)wy_wipeSpaceFromStr:(NSString *)str;

/** 去除字符串两端的空格 */
+ (NSString *)wy_wipeBothEndsSpaceFromStr:(NSString *)str;

/**
 
 *  去除字符串中的特定符号
 
 *  @param str 需要去除指定字符的字符串
 
 *  @param appointSymbol  指定的字符,如#、!
 
 *  @param replacement  要替换的字符(可以为空)
 
 */
+ (NSString *)wy_wipeAppointSymbolFromStr:(NSString *)str AppointSymbol:(NSString *)appointSymbol WithStr:(NSString *)replacement;

/** 获取设备ip地址*/
+ (NSString *)wy_getDeviceIpAddress;

/**
 返回一个包含匹配正则表达式的新字符串替换为模版字符串。
 
 @param regex       正则表达式
 @param options     上报的匹配选项.
 @param replacement 用来替换匹配到的内容.
 @param  string 需要匹配的字符串
 
 @return 返回一个用指定字符串替换匹配字符串后的字符串.
 */
+ (NSString *)wy_stringByReplacingRegex:(NSString *)regex
                             options:(NSRegularExpressionOptions)options
                          withString:(NSString *)replacement content:(NSString *)string;

/**
 匹配正则表达式，并使用匹配的每个对象执行给定的块。
 
 @param regex    正则表达式
 @param options  上报的匹配选项.
 @param block    应用于在数组元素中匹配的块.
 该块需要四个参数:
 match: 匹配的子串.
 matchRange: 匹配选项.
 stop: 一个布尔值的引用。块可以设置YES来停止处理阵列。stop参数是一个唯一的输出。你应该给块设置YES。
 @param  string 需要匹配的字符串
 */
+ (void)wy_enumerateRegexMatches:(NSString *)regex
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block content:(NSString *)string;

/**
 获取苹果设备型号
 */
+ (NSString *)wy_appleDiviceType;


@end
