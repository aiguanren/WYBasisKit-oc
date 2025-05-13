//
//  NSString+WYMD5.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (WYMD5)

/**
 *  16位MD5加密
 *
 *  @param isUppercase 是否需要大写加密
 */
+ (NSString *)wy_MD5_16BitEncry:(NSString *)MD5String isUppercase:(BOOL)isUppercase;

/**
 *  16位牛叉_MD5加密
 *
 *  @param isUppercase 是否需要大写加密
 */
+ (NSString *)wy_MD5_NB16BitEncry:(NSString *)MD5String isUppercase:(BOOL)isUppercase;

/**
 *  32位MD5加密
 *
 *  @param isUppercase 是否需要大写加密
 */
+ (NSString *)wy_MD5_32BitEncry:(NSString *)MD5String isUppercase:(BOOL)isUppercase;

/**
 *  32位牛叉NB_MD5加密
 *
 *  @param isUppercase 是否需要大写加密
 */
+ (NSString *)wy_MD5_NB32BitEncry:(NSString *)MD5String isUppercase:(BOOL)isUppercase;

@end

NS_ASSUME_NONNULL_END
