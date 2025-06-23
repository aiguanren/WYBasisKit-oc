//
//  StateView.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/8/16.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StateView : UIView

/** 提示成功信息 */
+ (void)showSuccessInfo:(NSString *)info;

/** 提示错误信息 */
+ (void)showErrorInfo:(NSString *)info;

/** 提示警告信息 */
+ (void)showWarningInfo:(NSString *)info;

/** 移除弹窗 */
+ (void)dismiss;

/** 设置弹窗是否需要自动移除(需在弹窗前设置)  默认YES */
+ (void)automaticRemoveWindow:(BOOL)autoRemove;

/**
 设置弹窗延时策略(需在弹窗前设置)
 
 @param delayed 弹窗延时时间，默认1.5秒
 @param eachDelay 是否每次都按照该延时设置延时,默认NO
 */
+ (void)windowDelayed:(CGFloat)delayed eachDelay:(BOOL)eachDelay;

/** 弹窗时是否允许用户界面交互  默认允许 */
+ (void)userInteractionEnabled:(BOOL)userInteractionEnabled;

@end
