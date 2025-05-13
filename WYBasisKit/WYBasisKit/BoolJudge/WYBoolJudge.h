//
//  WYBoolJudge.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///申请判断权限的类型
typedef NS_ENUM(NSInteger, WYPermissionType) {
    
    WYPermissionTypeLocation = 0,//定位
    WYPermissionTypeAlbum,  //相册
    WYPermissionTypeCamera, //相机
    WYPermissionTypeMicrophone, //麦克风
};

@interface WYBoolJudge : NSObject

/** 判断是否为纯数字 */
+ (BOOL)wy_isPureDigitalStr:(NSString *)string;

/** 判断是否为纯字母 */
+ (BOOL)wy_isPureLetters:(NSString *)string;

/** 判断是否为纯汉字 */
+ (BOOL)wy_isChineseCharacters:(NSString *)string;

/** 判断是否包含字母 */
+ (BOOL)wy_isContainLetters:(NSString *)string;

/** 判断4-8位汉字：位数可更改 */
+ (BOOL)wy_combinationChineseCharacters:(NSString *)string;

/** 判断仅字母或数字 */
+ (BOOL)wy_isLettersOrNumbers:(NSString *)string;

/** 判断6-18位字母或数字组合：位数可更改 */
+ (BOOL)wy_combinationOfLettersOrNumbers:(NSString *)string;

/** 判断仅中文、字母或数字 */
+ (BOOL)wy_isChineseOrLettersOrNumbers:(NSString *)string;

/** 判断6~18位字母开头，只能包含“字母”，“数字”，“下划线”：位数可更改 */
+ (BOOL)wy_isValidPassword:(NSString *)string;

/** 判断是否为大写字母 */
+ (BOOL)wy_isCapitalLetters:(NSString *)string;

/** 判断是否为小写字母 */
+ (BOOL)wy_isLowercaseLetters:(NSString *)string;

/** 判断是否以字母开头 */
+ (BOOL)wy_isLettersBegin:(NSString *)string;

/** 判断是否以汉字开头 */
+ (BOOL)wy_isChineseBegin:(NSString *)string;

/** 验证手机号 非严谨:1开头11位纯数字 */
+ (BOOL)wy_isMobileNumber:(NSString *)string;

/** 验证手机号 严谨:运营商号段，正则号段可能有不全，自己可以添加 */
+ (BOOL)wy_isPhoneNumber:(NSString *)string;

/** 验证运营商:移动 */
+ (BOOL)wy_isMobilePperators:(NSString *)string;

/** 验证运营商:联通 */
+ (BOOL)wy_isUnicomPperators:(NSString *)string;

/** 验证运营商:电信 */
+ (BOOL)wy_isTelecomPperators:(NSString *)string;

/** 验证邮箱 */
+ (BOOL)wy_isValidateEmail:(NSString *)string;

/** 简单验证身份证:15或18位 */
+ (BOOL)wy_simpleVerifyIdentityCard:(NSString *)string;

/** 精确验证15或18位身份证 */
+ (BOOL)wy_accurateVerifyIDCardNumber:(NSString *)string;

/** 精确验证18位身份证 */
+ (BOOL)wy_validationCardNumberFor18:(NSString *)string;

/** 验证车型 */
+ (BOOL)wy_validateCarType:(NSString *)string;

/** 车牌号的有效性验证 */
+ (BOOL)wy_isLicensePlate:(NSString *)string;

/** IP地址有效性 */
+ (BOOL)wy_isIPAddress:(NSString *)string;

/** MAC地址有效性 */
+ (BOOL)wy_isMacAddress:(NSString *)string;

/** 邮编有效性 */
+ (BOOL)wy_isValidPostalcode:(NSString *)string;

/** 验证表情 */
+ (BOOL)wy_stringContainsEmoji:(NSString *)string;

/** 工商税号有效性 */
+ (BOOL)wy_isValidTaxNumber:(NSString *)string;

/** 判断是否开启了定位 */
+ (BOOL)wy_isOpenLocationService;

/** 验证银行卡号有效性
 *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 *  16 位卡号校验位采用 Luhm 校验方法计算：
 *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 *  3，将加法和加上校验位能被 10 整除。
 */
+ (BOOL)wy_isBankCardNumber:(NSString *)string;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
+ (BOOL)wy_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal
                       content:(NSString *)string;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
+ (BOOL)wy_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
                 containDigtal:(BOOL)containDigtal
                 containLetter:(BOOL)containLetter
         containOtherCharacter:(NSString *)containOtherCharacter
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal
                       content:(NSString *)string;

/**
 是否能够匹配正则表达式
 
 @param regex  正则表达式
 @param options     普配方式.
 @return YES：如果可以匹配正则表达式; 否则,NO.
 @param  string 需要匹配的字符串
 */
+ (BOOL)wy_matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options content:(NSString *)string;

/**
 根据传入的媒体类型进行权限判断，如果没有相应权限，会自动弹出友情提示窗
 
 @param mediaType 要判断的权限的类型
 @param superController 控制器
 @return 返回是否有权限
 */
+ (BOOL)wy_authorityManagement:(WYPermissionType)mediaType superController:(UIViewController *)superController;

@end

NS_ASSUME_NONNULL_END
