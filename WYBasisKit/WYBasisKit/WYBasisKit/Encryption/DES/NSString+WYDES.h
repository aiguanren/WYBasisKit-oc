//
//  NSString+WYDES.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (WYDES)

/**
 *  加密方法
 *
 *  @param string   需要加密的字符串
 *  @param key      加密key
 */
+ (NSString *)wy_DESEncry:(NSString *)string key:(NSString *)key;



/**
 *  解密方法
 *
 *  @param string   需要解密的字符串
 *  @param key      解密key(与加密key是一致的)
 */
+ (NSString *)wy_DESDecry:(NSString *)string key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
