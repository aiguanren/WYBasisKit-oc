//
//  UIApplication+WYExtension.h
//  WYBasisKit
//
//  Created by 官人 on 2025/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (WYExtension)

/// 获取当前正在显示的 keyWindow
@property (nonatomic, strong, readonly) UIWindow *wy_keyWindow;

@end

NS_ASSUME_NONNULL_END
