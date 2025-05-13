//
//  UITextView+WYExtension.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (WYExtension)

/**
 *  占位文字
 */
@property (nonatomic, copy) NSString *wy_placeholderStr;

/**
 *  占位文字字号
 */
@property (nonatomic, strong) UIFont *wy_placeholderFont;

/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *wy_placeholderColor;

/**
 *  最大显示字符限制(会自动根据该属性截取文本字符长度)
 */
@property (nonatomic, assign) NSInteger wy_maximumLimit;

/**
 *  右下角字符长度提示(需要设置wy_maximumLimit属性)  默认NO
 */
@property (nonatomic, assign) BOOL wy_characterLengthPrompt;

/**
 *  占位文字原点位置  CGPointMake(5, 8)
 */
@property (nonatomic, assign) CGPoint wy_placeholderPoint;

/**
 *  是否禁止复制粘贴 默认允许
 */
@property (nonatomic, assign) BOOL wy_allowCopyPaste;

/**
 *  文本发生改变时回调
 */
- (void)wy_textDidChange:(void(^)(NSString *textStr))handle;

/**
 *  处理系统输入法导致的乱码,如果调用了maximumLimit属性，内部会默认处理乱码
 */
- (void)wy_fixMessyDisplay;

@end

NS_ASSUME_NONNULL_END
