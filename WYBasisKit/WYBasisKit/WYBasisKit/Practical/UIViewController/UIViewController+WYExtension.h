//
//  UIViewController+WYExtension.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/6/19.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerHandlerProtocol <NSObject>

@optional

/** 重写下面的方法以拦截导航栏pop事件，返回 YES 则 pop，NO 则不 pop  默认返回上一页 */
- (BOOL)wy_navigationBarWillReturn;

@end

///viewController显示模式
typedef NS_ENUM(NSInteger, WYDisplaMode) {
    /** push */
    WYDisplaModePush = 0,
    /** present */
    WYDisplaModePresent,
};

@interface UIViewController (WYExtension)<ViewControllerHandlerProtocol>

/** 从导航控制器栈中查找ViewController，没有时返回nil */
- (UIViewController *)wy_findViewController:(NSString *)className;

/** 删除指定的视图控制器 */
- (void)wy_deleteViewController:(NSString *)className complete:(void(^)(void))complete;

/** 跳转到指定的视图控制器 */
- (void)wy_showViewController:(NSString *)className animated:(BOOL)animated displaMode:(WYDisplaMode)displaMode;

/** 跳转到指定的视图控制器，此方法可防止循环跳转 */
- (void)wy_showOnlyViewController:(NSString *)className animated:(BOOL)animated displaMode:(WYDisplaMode)displaMode;

/** 返回到指定的视图控制器 */
- (void)wy_gobackViewController:(NSString *)className animated:(BOOL)animated;

/** viewController是push还是present的方式显示的 */
- (WYDisplaMode)wy_viewControllerDisplaMode;


@end
