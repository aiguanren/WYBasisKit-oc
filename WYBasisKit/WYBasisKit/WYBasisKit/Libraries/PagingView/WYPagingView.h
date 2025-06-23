//
//  WYPagingView.h
//  WYBasisKit
//
//  Created by jacke-xu on 2019/6/1.
//  Copyright © 2019 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYPagingView : UIView

/**
 * 初始化方法
 *
 * @param frame 控件frame
 * @param superViewController 父控制器
 *
 * @return 返回一个实例化好的对象
 */
- (instancetype)wy_initWithFrame:(CGRect)frame
             superViewController:(UIViewController *)superViewController;


/**
 * 调用后开始布局,标签下面没有图标
 *
 * @param controllerAry 控制器数组
 * @param titleAry 标题数组
 */
- (void)wy_layoutPagingControllerAry:(NSArray <UIViewController *> *)controllerAry
                            titleAry:(NSArray<NSString *> *)titleAry;


/**
 *调用后开始布局,标签下面有图标
 *
 * @param controllerAry 控制器数组
 * @param titleAry 标题数组
 * @param defaultImageAry 未选中状态图片数组，可以是NSString,也可以是UIImage
 * @param selectedImageAry 选中状态图片数组，可以是NSString,也可以是UIImage
 */
- (void)wy_layoutPagingControllerAry:(NSArray <UIViewController *> *)controllerAry
                            titleAry:(NSArray<NSString *> *)titleAry
                     defaultImageAry:(NSArray *)defaultImageAry
                    selectedImageAry:(NSArray *)selectedImageAry;

/**
 * 点击事件
 *
 * @param scrollAction 点击或滚动事件的block
 */
- (void)wy_scrollPagingToIndex:(void(^)(NSInteger pagingIndex))scrollAction;



/***********************  以下为选传项，如果传入请在调用布局方法前传入  *****************/

/// 分页栏宽度 默认对应每页标题文本宽度(若传入则整体使用传入宽度)
@property (nonatomic, assign) CGFloat bar_Width;

/// 分页栏的高度 默认45;
@property (nonatomic, assign) CGFloat bar_Height;

/// 分页栏左起始点距离(第一个标题栏距离屏幕边界的距离) 默认0
@property (nonatomic, assign) CGFloat bar_originlLeftSpace;

/// 分页栏右起始点距离(最后一个标题栏距离屏幕边界的距离) 默认0
@property (nonatomic, assign) CGFloat bar_originlRightSpace;

/// 左右分页栏之间的间距(默认20像素,个别极端情况下内部会强制调整这个值)
@property (nonatomic, assign) CGFloat bar_dividingSpace;

/// 内部按钮图片和文字的上下间距 默认5
@property (nonatomic, assign) CGFloat barButton_dividingSpace;

/// 分页栏默认背景色 默认白色
@property (nonatomic, strong) UIColor *bar_bg_defaultColor;

/// 分页栏选中背景色 默认白色
@property (nonatomic, strong) UIColor *bar_bg_selectedColor;

/// 分页栏标题默认颜色 默认<#7B809E>
@property (nonatomic, strong) UIColor *bar_title_defaultColor;

/// 分页栏标题选中颜色 默认<#2D3952>
@property (nonatomic, strong) UIColor *bar_title_selectedColor;

/// 分页栏底部分隔带背景色 默认<#F2F2F2>
@property (nonatomic, strong) UIColor *bar_dividingStripColor;

/// 滑动线条背景色 默认<#2D3952>
@property (nonatomic, strong) UIColor *bar_scrollLineColor;

/// 滑动线条宽度 默认25像素
@property (nonatomic, assign) CGFloat bar_scrollLineWidth;

/// 滑动线条距离分页栏顶部的距离 默认距离为bar_Height-5
@property (nonatomic, assign) CGFloat bar_scrollLineTop;

/// 分隔带高度 默认2像素
@property (nonatomic, assign) CGFloat bar_dividingStripHeight;

/// 滑动线条高度 默认2像素
@property (nonatomic, assign) CGFloat bar_scrollLineHeight;

/// 分页栏标题默认字号 默认14号；
@property (nonatomic, assign) UIFont *bar_title_defaultFont;

/// 分页栏标题选中字号 默认粗体17号；
@property (nonatomic, assign) UIFont *bar_title_selectedFont;

/// 初始选中第几项(也可后期根据情况设置滚动到第几项)  默认0
@property (nonatomic, assign) NSInteger bar_selectedIndex;

/// 徽章值填充色 默认系统红色
@property (nonatomic, strong) UIColor *bar_badgeValueFillColor;

/// 徽章值文字颜色 默认系统白色
@property (nonatomic, strong) UIColor *bar_badgeValueTextColor;

/// 徽章值文字字号 默认系统9号字
@property (nonatomic, strong) UIFont *bar_badgeValueTextFont;

/// 徽章值文字边界距离 默认UIEdgeInsetsMake(0, 0, 0, 0)
@property (nonatomic, assign) UIEdgeInsets bar_badgeValueInsets;

/// 徽章值原点距离文字按钮的偏移量  默认相对于文字按钮右上角居中(x为正，y为负)
@property (nonatomic, assign) CGPoint bar_badgeValueOffset;


/**
 设置徽章值的显示或隐藏

 @param show 是否需要显示或者隐藏某个徽章值
 @param index 需要显示或者隐藏的徽章值的下标位置
 */

/**
 设置徽章值的显示或隐藏

 @param show 是否需要显示或者隐藏某个徽章值
 @param value 需要显示的徽章,只能是图片或文字(设置隐藏时可以传空)
 @param index 需要显示或者隐藏的徽章值的下标位置
 */
- (void)wy_showBadge:(BOOL)show value:(id)value atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
