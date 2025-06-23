//
//  NSMutableAttributedString+WYExtension.h
//  WYBasisKit
//
//  Created by  guanren on 2018/6/15.
//  Copyright © 2018年 guanren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (WYExtension)

/** 计算富文本显示需要的宽度 */
- (CGFloat)wy_calculateWidthWithHeight:(CGFloat)height;

/** 计算富文本显示需要的高度 */
- (CGFloat)wy_calculateHeightWithWidth:(CGFloat)width;

@end

@interface NSMutableAttributedString (WYExtension)

/** 返回AttributedString属性 */
+ (NSMutableAttributedString *)wy_attributeWithStr:(NSString *)str;

/**
 
 *  需要修改的字符颜色数组及量程，由字典组成  key = 颜色   value = 量程或需要修改的字符串
 *  例：NSArray *colorsOfRanges = @[@{color:@[@"0",@"1"]},@{color:@[@"1",@"2"]}]
 *  或：NSArray *colorsOfRanges = @[@{color:str},@{color:str}]
 */
- (void)wy_colorsOfRanges:(NSArray <NSDictionary *>*)colorsOfRanges;

/**
 
 *  需要修改的字符字体数组及量程，由字典组成  key = 颜色   value = 量程或需要修改的字符串
 *  例：NSArray *fontsOfRanges = @[@{font:@[@"0",@"1"]},@{font:@[@"1",@"2"]}]
 *  或：NSArray *fontsOfRanges = @[@{font:str},@{font:str}]
 */
- (void)wy_fontsOfRanges:(NSArray <NSDictionary *>*)fontsOfRanges;

/** 设置行间距 */
- (void)wy_setLineSpacing:(CGFloat)lineSpacing string:(NSString *)string;

/** 设置字间距 */
- (void)wy_setWordsSpacing:(CGFloat)wordsSpacing string:(NSString *)string;

/** 设置文字方向 */
- (void)wy_setAlignment:(NSTextAlignment)textAlignment;

/** 添加下划线 */
- (void)wy_addUnderlineWithString:(NSString *)string;

/** 添加中划线 */
- (void)wy_addHorizontalLineWithString:(NSString *)string;

@end
