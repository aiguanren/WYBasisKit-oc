//
//  UILabel+WYExtension.h
//  WYBasisKit
//
//  Created by  guanren on 2018/11/27.
//  Copyright © 2018 guanren. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (WYExtension)

/** 获取UILable的行高(根据UILable的字号获取的，系统默认字号：17) */
@property (nonatomic, assign, readonly) CGFloat wy_lineHeight;

/** 设置标签文本距离边框的边距 */
@property (nonatomic, assign) UIEdgeInsets wy_textInsets;

/** 设置标签左对齐 */
- (void)wy_leftAlign;

/** 设置标签中心对齐 */
- (void)wy_centerAlign;

/** 设置标签右对齐 */
- (void)wy_rightAlign;

/** 创建lable */
+ (UILabel *)wy_createLabWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
