//
//  LoadingView.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/8/14.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

/** 自定义图片模式 */
+ (void)showMessage:(NSString *)message;

/** 自定义图片模式  superView只能是控制器view或则keyWindow */
+ (void)showMessage:(NSString *)message superView:(UIView *)superView;

/** 系统小菊花模式 */
+ (void)showInfo:(NSString *)info;

/** 系统小菊花模式  superView只能是控制器view或则keyWindow */
+ (void)showInfo:(NSString *)info  superView:(UIView *)superView;

/** 移除弹窗 */
+ (void)dismiss;

/** 弹窗时是否允许用户界面交互  默认允许 */
+ (void)userInteractionEnabled:(BOOL)userInteractionEnabled;

@end
