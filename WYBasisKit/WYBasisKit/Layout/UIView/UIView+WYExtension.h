//
//  UIView+WYExtension.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// UIView渐变方向
typedef NS_ENUM(NSInteger, WYGradientDirection) {
    /// 从上到下
    topToBottom = 0,
    /// 从左到右
    leftToRight = 1,
    /// 左上到右下
    leftToLowRight = 2,
    /// 右上到左下
    rightToLowLeft = 3,
};

@interface UIView (WYExtension)

/** view.width */
@property (nonatomic, assign) CGFloat wy_width;

/** view.height */
@property (nonatomic, assign) CGFloat wy_height;

/** view.origin.x */
@property (nonatomic, assign) CGFloat wy_left;

/** view.origin.y */
@property (nonatomic, assign) CGFloat wy_top;

/** view.origin.x + view.width */
@property (nonatomic, assign) CGFloat wy_right;

/** view.origin.y + view.height */
@property (nonatomic, assign) CGFloat wy_bottom;

/** view.center.x */
@property (nonatomic, assign) CGFloat wy_centerx;

/** view.center.y */
@property (nonatomic, assign) CGFloat wy_centery;

/** view.origin */
@property (nonatomic, assign) CGPoint wy_origin;

/** view.size */
@property (nonatomic, assign) CGSize wy_size;

/** 找到自己的所属viewController */
- (UIViewController *)wy_belongsViewController;

/** 找到当前显示的viewController */
- (UIViewController *)wy_currentViewController;

/** 创建view */
+ (UIView *)wy_createViewWithFrame:(CGRect)frame color:(UIColor *)color;

/** 添加手势点击事件 */
- (void)wy_addGestureAction:(id)target selector:(SEL)selector;

/**
 * 根据键盘的弹出与收回，自动调整控件位置，防止键盘遮挡输入框,注意，如果调用该方法，则必须在父控制器的dealloc方法中调用releaseKeyboardNotification方法,以释放键盘监听通知
 @ param mainView 要移动的主视图，控制器view(controller.view)
 */
- (void)wy_automaticFollowKeyboard:(UIView *)mainView;

/**
 * 释放监听键盘的通知,如果调用过automaticFollowKeyboard方法，则必须在父控制器的dealloc方法中调用本方法以释放键盘监听通知
 */
- (void)wy_releaseKeyboardNotification;

/** 添加收起键盘的手势 */
- (void)wy_gestureHidingkeyboard;

@end

@interface UIView (WYVisual)

/// 使用链式编程设置圆角、边框、阴影、渐变(调用方式类似Masonry，也可以.语法调用，点语法时需要自己在最后一个设置后面调用wy_showVisual后设置才会生效)
@property (nonatomic, copy, readonly) UIView *(^wy_makeVisual)(void (^)(UIView *make));

/// 圆角的位置，默认4角圆角
@property (nonatomic, copy, readonly) UIView *(^wy_rectCorner)(UIRectCorner rectCorner);

/// 圆角的半径，默认0.0
@property (nonatomic, copy, readonly) UIView *(^wy_cornerRadius)(CGFloat radius);

/// 边框颜色，默认透明
@property (nonatomic, copy, readonly) UIView *(^wy_borderColor)(UIColor *color);

/// 边框宽度，默认0.0
@property (nonatomic, copy, readonly) UIView *(^wy_borderWidth)(CGFloat width);

/// 阴影颜色，默认透明
@property (nonatomic, copy, readonly) UIView *(^wy_shadowColor)(UIColor *color);

/// 阴影偏移度 (width : 为正数时，向右偏移，为负数时，向左偏移，height : 为正数时，向下偏移，为负数时，向上偏移)，默认zero
@property (nonatomic, copy, readonly) UIView *(^wy_shadowOffset)(CGSize offset);

/// 阴影半径，默认0.0
@property (nonatomic, copy, readonly) UIView *(^wy_shadowRadius)(CGFloat radius);

/// 阴影模糊度(取值范围0~1)，默认0.5
@property (nonatomic, copy, readonly) UIView *(^wy_shadowOpacity)(CGFloat opacity);

/// 渐变色数组(设置渐变色时不能设置背景色，会有影响)
@property (nonatomic, copy, readonly) UIView *(^wy_gradualColors)(NSArray<UIColor *> *colors);

/// 渐变色方向，默认从左到右
@property (nonatomic, copy, readonly) UIView *(^wy_gradientDirection)(WYGradientDirection direction);

/// 设置圆角时，会去获取视图的Bounds属性，如果此时获取不到，则需要传入该参数，默认为 nil，如果传入该参数，会设置视图的frame为bounds
@property (nonatomic, copy, readonly) UIView *(^wy_viewBounds)(CGRect bounds);

/// 贝塞尔路径 默认nil (有值时，radius属性将失效)
@property (nonatomic, copy, readonly) UIView *(^wy_bezierPath)(UIBezierPath *path);

/// 显示(更新)边框、阴影、圆角、渐变
@property (nonatomic, copy, readonly) UIView *(^wy_showVisual)(void);

/// 清除边框、阴影、圆角、渐变
@property (nonatomic, copy, readonly) UIView *(^wy_clearVisual)(void);

@end

NS_ASSUME_NONNULL_END
