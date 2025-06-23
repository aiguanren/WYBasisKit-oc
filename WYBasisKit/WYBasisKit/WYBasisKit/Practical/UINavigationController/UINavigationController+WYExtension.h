//
//  UINavigationController+WYExtension.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/6/19.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

/*
 如果设置了导航栏的translucent = YES这时在添加子视图的坐标原点相对屏幕坐标是(0,0).如果设置了translucent = NO这时添加子视图的坐标原点相对屏幕坐标就是(0, navViewHeight)
 */

#import <UIKit/UIKit.h>


@interface UINavigationController (WYExtension)

/** 导航栏标题字体颜色 */
@property (nonatomic, strong) UIColor *wy_titleColor;

/** 导航栏标题字号 */
@property (nonatomic, strong) UIFont *wy_titleFont;

/** 导航栏背景色 */
@property (nonatomic, strong) UIColor *wy_barBackgroundColor;

/** 导航栏背景图片 */
@property (nonatomic, strong) UIImage *wy_barBackgroundImage;

/** 导航栏左侧返回按钮背景图片(若同时显示返回图标与文本则建议调用自定义方法设置，防止iOS11以下返回图标和文本错位) */
@property (nonatomic, strong) UIImage *wy_barReturnButtonImage;

/** 导航栏左侧返回按钮背景颜色 */
@property (nonatomic, strong) UIColor *wy_barReturnButtonColor;

/** 设置导航栏完全透明  会设置translucent = YES */
- (void)wy_navigationBarTransparent;

/** 让导航栏完全不透明 会设置translucent = NO */
- (void)wy_navigationBarOpaque;

/** 设置导航栏上滑收起,下滑显示(iOS8及以后有效) */
- (void)wy_hidesNavigationBarsOnSwipe;

/** 导航栏左侧返回按钮文本(若同时显示返回图标与文本则建议调用自定义方法设置，防止iOS11以下返回图标和文本错位) */
- (void)wy_pushControllerBarReturnButtonTitle:(NSString *)barReturnButtonTitle navigationItem:(UINavigationItem *)navigationItem;

/** 自定义leftBarButtonItem */
- (void)wy_customLeftBarButtonItem:(UINavigationItem *)navigationItem target:(id)target selector:(SEL)selector complete:(void(^)(UIButton *itemButton))complete;

/** 自定义rightBarButtonItem */
- (void)wy_customRightBarButtonItem:(UINavigationItem *)navigationItem target:(id)target selector:(SEL)selector complete:(void(^)(UIButton *itemButton))complete;

@end
