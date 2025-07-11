//
//  NSMutableAttributedString+WYExtension.m
//  WYBasisKit
//
//  Created by  guanren on 2018/6/15.
//  Copyright © 2018年 guanren. All rights reserved.
//

#import "NSMutableAttributedString+WYExtension.h"
#import "NSMutableParagraphStyle+WYExtension.h"
#include <objc/runtime.h>

@implementation NSAttributedString (WYExtension)

/** 计算富文本显示需要的宽度 */
- (CGFloat)wy_calculateWidthWithHeight:(CGFloat)height {
    // 计算文本所需的宽度
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, height);  // 最大宽度为无穷大
    CGRect boundingRect = [self boundingRectWithSize:maxSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       context:nil];
    return CGRectGetWidth(boundingRect);  // 返回计算得到的宽度
}

/** 计算富文本显示需要的高度 */
- (CGFloat)wy_calculateHeightWithWidth:(CGFloat)width {
    
    // 计算文本所需的高度
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);  // 最大高度为无穷大
    CGRect boundingRect = [self boundingRectWithSize:maxSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       context:nil];
    return CGRectGetHeight(boundingRect);  // 返回计算得到的高度
}

@end

@implementation NSMutableAttributedString (WYExtension)

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
    
    if (self.string.length <= 0) {
        return;
    }
    
    NSMutableParagraphStyle *paragraphStyle = ([self attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil]);
    if(paragraphStyle == nil) {
        paragraphStyle = [NSMutableParagraphStyle wy_paragraphStyle];
    }
    
    [paragraphStyle setLineSpacing:lineSpacing];
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:[[NSString stringWithFormat:@"%@",self.string] rangeOfString:[NSString stringWithFormat:@"%@",string]]];
}

- (void)wy_setLineSpacings:(CGFloat)lineSpacing
              beforeString:(NSString *)beforeString
               afterString:(NSString *)afterString
                 alignment:(NSTextAlignment)alignment {

    if (lineSpacing <= 0 ||
        beforeString.length == 0 ||
        afterString.length  == 0) {
        return;
    }

    NSString *full = self.string;

    // 找到 beforeString 首次出现的位置
    NSRange beforeRange = [full rangeOfString:beforeString];
    if (beforeRange.location == NSNotFound) return;

    // 仅在 beforeString 之后搜索 afterString，避免同名提前命中
    NSRange searchRange = NSMakeRange(NSMaxRange(beforeRange),
                                      full.length - NSMaxRange(beforeRange));
    NSRange afterRange  = [full rangeOfString:afterString options:0 range:searchRange];
    if (afterRange.location == NSNotFound) return;

    // 获取 beforeString 所在段落范围
    NSRange paragraphRange =
        [full paragraphRangeForRange:beforeRange]; // 含末尾换行符

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacing = lineSpacing;
    style.alignment = (alignment == nil) ? NSTextAlignmentLeft : alignment;

    // 应用到 beforeString 段落
    [self addAttribute:NSParagraphStyleAttributeName
                value:style
                range:paragraphRange];
}

- (void)wy_setWordsSpacing:(CGFloat)wordsSpacing string:(NSString *)string {
    
    [self addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:wordsSpacing] range:[self.string rangeOfString:string]];
}

- (void)wy_setAlignment:(NSTextAlignment)textAlignment {
    
    if (self.string.length <= 0) {
        return;
    }
    
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
