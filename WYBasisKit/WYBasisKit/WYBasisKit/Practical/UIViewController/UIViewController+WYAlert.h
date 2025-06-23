//
//  UIViewController+WYAlert.h
//  WYBasisKit
//
//  Created by bangtuike on 2019/6/27.
//  Copyright © 2019 guanren. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WYPreferredStyle) {
    
    /** UIAlertControllerStyleAlert，默认 */
    WYPreferredStyleAlert = 0,
    /** UIAlertControllerStyleActionSheet */
    WYPreferredStyleActionSheet = 1
};

@interface UIViewController (WYAlert)

/// 设置弹窗提醒模式 默认UIAlertControllerStyleAlert
@property (nonatomic, assign) WYPreferredStyle wy_preferredStyle;

/// styleAlert时是否需要点击空白处关闭弹窗 默认YES
@property (nonatomic, assign) BOOL wy_clickBlankClose;

/// 设置AlertController标题颜色
@property (nonatomic, strong, nullable) UIColor *wy_alertTitleColor;

/// 设置AlertController消息颜色
@property (nonatomic, strong, nullable) UIColor *wy_alertMessageColor;

/// 设置AlertController事件按钮颜色
@property (nonatomic, strong, nullable) NSArray <UIColor *>*wy_actionTitleColors;

/// 取消按钮颜色 优先级比wy_actionTitleColors高
@property (nonatomic, strong, nullable) UIColor *wy_cancelActionColor;

/// 其他按钮颜色 优先级比wy_actionTitleColors高
@property (nonatomic, strong, nullable) UIColor *wy_otherActionColor;

/// 设置AlertController标题字号
@property (nonatomic, strong, nullable) UIFont *wy_alertTitleFont;

/// 设置AlertController消息字号
@property (nonatomic, strong, nullable) UIFont *wy_alertMessageFont;

/// 获取AlertController标题
@property (nonatomic, copy, readonly) NSString *wy_alertTitle;

/// 获取AlertController消息
@property (nonatomic, copy, readonly) NSString *wy_alertMessage;

/// 获取AlertController事件按钮文本
@property (nonatomic, strong, readonly) NSArray <NSString *>*wy_actionTitles;

- (void)wy_showAlertControllerWithMessage:(NSString *_Nullable)alertMessage;


- (void)wy_showAlertControllerWithMessage:(NSString *_Nullable)alertMessage
                             actionTitles:(NSArray <NSString *>*_Nullable)actionTitles
                                  handler:(void(^__nullable)(UIAlertAction *alertAction, NSInteger actionIndex))handler;

- (void)wy_showAlertControllerWithAlertTitle:(NSString *_Nullable)alertTitle
                                alertMessage:(NSString *_Nullable)alertMessage;

- (void)wy_showAlertControllerWithAlertTitle:(NSString *_Nullable)alertTitle
                                alertMessage:(NSString *_Nullable)alertMessage
                                actionTitles:(NSArray <NSString *>*_Nullable)actionTitles
                                     handler:(void(^__nullable)(UIAlertAction *alertAction, NSInteger actionIndex))handler;

- (void)wy_showAlertControllerWithAttributedMessage:(NSAttributedString *_Nullable)alertMessage;

- (void)wy_showAlertControllerWithAttributedMessage:(NSAttributedString *_Nullable)alertMessage
                                       actionTitles:(NSArray <NSString *>*_Nullable)actionTitles
                                            handler:(void(^__nullable)(UIAlertAction *alertAction, NSInteger actionIndex))handler;

- (void)wy_showAlertControllerWithAlertAttributedTitle:(NSAttributedString *_Nullable)alertTitle
                                          alertMessage:(NSAttributedString *_Nullable)alertMessage;

- (void)wy_showAlertControllerWithAlertAttributedTitle:(NSAttributedString *_Nullable)alertTitle
                                alertMessage:(NSAttributedString *_Nullable)alertMessage
                                actionTitles:(NSArray <NSString *>*_Nullable)actionTitles
                                     handler:(void(^__nullable)(UIAlertAction *alertAction, NSInteger actionIndex))handler;

@end

NS_ASSUME_NONNULL_END
