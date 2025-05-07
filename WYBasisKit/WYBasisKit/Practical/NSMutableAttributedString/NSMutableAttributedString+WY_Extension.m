//
//  NSMutableAttributedString+WY_Extension.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/6/15.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import "NSMutableAttributedString+WY_Extension.h"
#import "NSMutableParagraphStyle+WY_Extension.h"
#include <objc/runtime.h>

@implementation NSAttributedString (WY_Extension)

/** 计算富文本显示需要的宽度 */
- (CGFloat)calculateWidthWithHeight:(CGFloat)height {
    // 计算文本所需的宽度
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, height);  // 最大宽度为无穷大
    CGRect boundingRect = [self boundingRectWithSize:maxSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       context:nil];
    return CGRectGetWidth(boundingRect);  // 返回计算得到的宽度
}

/** 计算富文本显示需要的高度 */
- (CGFloat)calculateHeightWithWidth:(CGFloat)width {
    
    // 计算文本所需的高度
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);  // 最大高度为无穷大
    CGRect boundingRect = [self boundingRectWithSize:maxSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       context:nil];
    return CGRectGetHeight(boundingRect);  // 返回计算得到的高度
}

@end

@implementation NSMutableAttributedString (WY_Extension)

+ (NSMutableAttributedString *)wy_attributeWithStr:(NSString *)str {
    
    return [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str]];
}

- (void)wy_colorsOfRanges:(NSArray<NSDictionary *> *)colorsOfRanges {
    
    if(colorsOfRanges == nil) return;
    
    for (NSDictionary *dic in colorsOfRanges) {
        
        UIColor *color = (UIColor *)[dic.allKeys firstObject];
        if([[dic.allValues firstObject] isKindOfClass:[NSString class]]) {
            
            NSString *rangeStr = (NSString *)[dic.allValues firstObject];
            [self addAttribute:NSForegroundColorAttributeName value:color range:[self.string rangeOfString:rangeStr]];
            
        }else {
            
            NSArray *rangeAry = (NSArray *)[dic.allValues firstObject];
            [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange([[rangeAry firstObject] integerValue], [[rangeAry lastObject] integerValue])];
        }
    }
}

- (void)wy_fontsOfRanges:(NSArray<NSDictionary *> *)fontsOfRanges {
    
    if(fontsOfRanges == nil) return;
    
    for (NSDictionary *dic in fontsOfRanges) {
        
        UIFont *font = (UIFont *)[dic.allKeys firstObject];
        if([[dic.allValues firstObject] isKindOfClass:[NSString class]]) {
            
            NSString *rangeStr = (NSString *)[dic.allValues firstObject];
            [self addAttribute:NSFontAttributeName value:font range:[self.string rangeOfString:rangeStr]];
            
        }else {
            
            NSArray *rangeAry = (NSArray *)[dic.allValues firstObject];
            [self addAttribute:NSFontAttributeName value:font range:NSMakeRange([[rangeAry firstObject] integerValue], [[rangeAry lastObject] integerValue])];
        }
    }
}

- (void)wy_setLineSpacing:(CGFloat)lineSpacing string:(NSString *)string {
    
    NSMutableParagraphStyle *paragraphStyle = ([self attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil]);
    if(paragraphStyle == nil) {
        paragraphStyle = [NSMutableParagraphStyle wy_paragraphStyle];
    }
    
    [paragraphStyle setLineSpacing:lineSpacing];
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:[[NSString stringWithFormat:@"%@",self.string] rangeOfString:[NSString stringWithFormat:@"%@",string]]];
}

- (void)wy_setWordsSpacing:(CGFloat)wordsSpacing string:(NSString *)string {
    
    [self addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:wordsSpacing] range:[self.string rangeOfString:string]];
}

- (void)wy_setAlignment:(NSTextAlignment)textAlignment {
    
    NSMutableParagraphStyle *paragraphStyle = ([self attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil]);
    if(paragraphStyle == nil) {
        
        paragraphStyle = [NSMutableParagraphStyle wy_paragraphStyle];
    }
    paragraphStyle.alignment = textAlignment;
    
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.string.length)];
}

- (void)wy_addUnderlineWithString:(NSString *)string {
    
    [self addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[self.string rangeOfString:string]];
}

- (void)wy_addHorizontalLineWithString:(NSString *)string {
    
    [self addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[self.string rangeOfString:string]];
}

@end
