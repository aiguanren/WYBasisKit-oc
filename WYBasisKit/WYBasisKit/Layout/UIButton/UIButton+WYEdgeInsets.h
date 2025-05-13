//
//  UIButton+WYEdgeInsets.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WYButtonPosition) {
    
    /** 图片在左，文字在右，默认 */
    WYButtonPositionImageLeft_titleRight = 0,
    /** 图片在右，文字在左 */
    WYButtonPositionImageRight_titleLeft = 1,
    /** 图片在上，文字在下 */
    WYButtonPositionImageTop_titleBottom = 2,
    /** 图片在下，文字在上 */
    WYButtonPositionImageBottom_titleTop = 3,
};

@interface UIButton (WYEdgeInsets)

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)wy_layouEdgeInsetsPosition:(WYButtonPosition)postion spacing:(CGFloat)spacing;

/**
 *  利用运行时自由设置UIButton的titleLabel和imageView的显示位置
 */

/** 设置按钮图片控件位置 */
@property (nonatomic, assign) CGRect wy_imageRect;

/** 设置按钮图片控件位置 */
@property (nonatomic, assign) CGRect wy_titleRect;

/** 设置按钮图片控件位置 */
- (void)wy_layoutTitleRect:(CGRect )titleRect imageRect:(CGRect )imageRect;

@end

NS_ASSUME_NONNULL_END
