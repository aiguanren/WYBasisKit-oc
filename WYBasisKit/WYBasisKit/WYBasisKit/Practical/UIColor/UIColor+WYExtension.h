//
//  UIColor+WYExtension.h
//  WYBasisKit
//
//  Created by jacke－xu on 16/9/4.
//  Copyright © 2016年 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WYExtension)

/** 透明度固定为1，以0x开头的十六进制转换成的颜色 */
+ (UIColor *)wy_hexColor:(NSString *)hexColor;

/** 透明度固定为1，以0x开头的十六进制转换成的颜色,透明度可调整 */
+ (UIColor *)wy_hexColor:(NSString *)hexColor alpha:(float)opacity;

@end
