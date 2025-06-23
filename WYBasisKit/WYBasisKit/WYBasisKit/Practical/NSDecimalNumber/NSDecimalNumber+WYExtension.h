//
//  NSDecimalNumber+WYExtension.h
//  WYBasisKit
//
//  Created by guanren on 2019/4/27.
//  Copyright © 2019 guanren. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (WYExtension)

/// 返回保持精度后的float值
+ (float)floatWithDecimalNumber:(double)number;

/// 返回保持精度后的double值
+ (double)doubleWithDecimalNumber:(double)number;

/// 返回保持精度后的NSString值
+ (NSString *)stringWithDecimalNumber:(double)number;

@end

NS_ASSUME_NONNULL_END
