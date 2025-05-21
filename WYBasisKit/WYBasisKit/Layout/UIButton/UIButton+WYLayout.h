//
//  UIButton+WYLayout.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WYButtonPosition) {
    
    /** 图片在左，文字在右，默认 */
    WYButtonPositionImageLeftTitleRight = 0,
    /** 图片在右，文字在左 */
    WYButtonPositionImageRightTitleLeft = 1,
    /** 图片在上，文字在下 */
    WYButtonPositionImageTopTitleBottom = 2,
    /** 图片在下，文字在上 */
    WYButtonPositionImageBottomTitleTop = 3,
};

@interface UIButton (WYLayout)

/**
 *  利用运行时自由设置UIButton的titleLabel和imageView的显示位置
 */

/** 设置按钮图片控件位置 */
@property (nonatomic, assign) CGRect wy_imageRect;

/** 设置按钮图片控件位置 */
@property (nonatomic, assign) CGRect wy_titleRect;

/**
 *  利用configuration或EdgeInsets自由设置UIButton的titleLabel和imageView的显示位置
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *  什么都不设置默认为图片在左，文字在右，居中且挨着排列的
 *  @param spacing 图片和文字的间隔
 */
- (void)wy_adjustWithPosition:(WYButtonPosition)position spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
