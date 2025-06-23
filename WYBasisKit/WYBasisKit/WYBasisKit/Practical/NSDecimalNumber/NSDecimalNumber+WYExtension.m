//
//  NSDecimalNumber+WYExtension.m
//  WYBasisKit
//
//  Created by guanren on 2019/4/27.
//  Copyright © 2019 guanren. All rights reserved.
//

#import "NSDecimalNumber+WYExtension.h"

@implementation NSDecimalNumber (WYExtension)

+ (float)floatWithDecimalNumber:(double)number {
    
    return [[self decimalNumber:number] floatValue];
}

+ (double)doubleWithDecimalNumber:(double)number {
    
    return [[self decimalNumber:number] doubleValue];
}

+ (NSString *)stringWithDecimalNumber:(double)number {
    
    return [[self decimalNumber:number] stringValue];
}

+ (NSDecimalNumber *)decimalNumber:(double)number {
    
    NSString *numberStr = [NSString stringWithFormat:@"%lf",number];
    
    return [NSDecimalNumber decimalNumberWithString:numberStr];
}

@end
