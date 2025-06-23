//
//  UITextField+WYExtension.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (WYExtension)

/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *wy_placeholderColor;

/**
 *  清除按钮图片
 */
@property (nonatomic, strong) UIImage *wy_clearButtonImage;

/**
 *  文本最大支持多少个字符，设置后会自动根据该属性截取文本字符长度
 */
@property (nonatomic, assign) NSInteger wy_maximumLimit;

/**
 *  是否禁止复制粘贴 默认允许
 */
@property (nonatomic, assign) BOOL wy_allowCopyPaste;

/**
 *  文本发生改变时回调
 */
- (void)wy_textDidChange:(void(^)(NSString *textStr))handle;

/**
 *  处理系统输入法导致的乱码
 */
- (void)wy_fixMessyDisplay;

@end

NS_ASSUME_NONNULL_END
