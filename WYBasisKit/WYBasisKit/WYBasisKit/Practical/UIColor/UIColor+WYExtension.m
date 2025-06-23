//
//  UIColor+WYExtension.m
//  WYBasisKit
//
//  Created by jacke－xu on 16/9/4.
//  Copyright © 2016年 guanren. All rights reserved.
//

#import "UIColor+WYExtension.h"

@implementation UIColor (WYExtension)

+ (UIColor *)wy_hexColor:(NSString *)hexColor {
    
    if ([hexColor hasPrefix:@"0X"] ||[hexColor hasPrefix:@"0x"]) hexColor = [hexColor substringFromIndex:2];
    if ([hexColor hasPrefix:@"#"]) hexColor = [hexColor substringFromIndex:1];
    
    unsigned int red, green, blue;
    
    NSRange range;
    
    range.length = 2;
    
    range.location = 0;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/ 255.0f) green:(float)(green/ 255.0f) blue:(float)(blue/ 255.0f) alpha: 1.0f];
}

+ (UIColor *)wy_hexColor:(NSString *)hexColor alpha:(float)opacity {
    
    unsigned int red, green, blue;
    
    NSRange range;
    
    range.length = 2;
    
    range.location = 0;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/ 255.0f) green:(float)(green/ 255.0f) blue:(float)(blue/ 255.0f) alpha: opacity ? opacity : 1.0f];
}

@end
