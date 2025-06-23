//
//  UIViewController+WYAlert.m
//  WYBasisKit
//
//  Created by bangtuike on 2019/6/27.
//  Copyright © 2019 guanren. All rights reserved.
//

#import "UIViewController+WYAlert.h"
#import "UIAlertController+WYExtension.h"
#import <objc/runtime.h>
#import "NSString+WYExtension.h"
#import "MacroDefinition.h"

@interface UIViewController ()

@property (nonatomic, strong) NSArray *cancelTitleAry;

@property (nonatomic, strong) UIWindow *alertWindow;

@end

@implementation UIViewController (WYAlert)

- (void)wy_showAlertControllerWithMessage:(NSString *_Nullable)alertMessage {
    
    [self wy_showAlertControllerWithAlertTitle:nil alertMessage:alertMessage actionTitles:nil handler:nil];
}

- (void)wy_showAlertControllerWithMessage:(NSString *_Nullable)alertMessage
                             actionTitles:(NSArray<NSString *> * _Nullable)actionTitles handler:(void (^ _Nullable)(UIAlertAction * _Nonnull, NSInteger))handler {
    
    [self wy_showAlertControllerWithAlertTitle:nil alertMessage:alertMessage actionTitles:actionTitles handler:handler];
}

- (void)wy_showAlertControllerWithAlertTitle:(NSString *_Nullable)alertTitle
                                alertMessage:(NSString *_Nullable)alertMessage {
    
    [self wy_showAlertControllerWithAlertTitle:alertTitle alertMessage:alertMessage actionTitles:nil handler:nil];
}

- (void)wy_showAlertControllerWithAlertTitle:(NSString *_Nullable)alertTitle
                                alertMessage:(NSString *_Nullable)alertMessage
                                actionTitles:(NSArray<NSString *> * _Nullable)actionTitles handler:(void (^ _Nullable)(UIAlertAction * _Nonnull, NSInteger))handler {
    
    [self setValue:[NSString wy_emptyStr:alertTitle] forKey:NSStringFromSelector(@selector(wy_alertTitle))];
    [self setValue:[NSString wy_emptyStr:alertMessage] forKey:NSStringFromSelector(@selector(wy_alertMessage))];
    [self setValue:actionTitles forKey:NSStringFromSelector(@selector(wy_actionTitles))];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:([NSString wy_emptyStr:alertTitle].length > 0) ? alertTitle : nil  message:([NSString wy_emptyStr:alertMessage].length > 0) ? alertMessage : nil preferredStyle:(self.wy_preferredStyle == WYPreferredStyleAlert) ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    
    [self wy_modifyAlertControllerStyle:alertController];
    for (NSString *actionTitle in actionTitles) {
        
        UIAlertActionStyle alertActionStyle = UIAlertActionStyleDefault;
        if((self.wy_preferredStyle == WYPreferredStyleActionSheet) && (([actionTitles indexOfObject:actionTitle] == 0) || ([actionTitles indexOfObject:actionTitle] == (actionTitles.count-1))) && ([self.cancelTitleAry containsObject:actionTitle] == YES)) {
            
            alertActionStyle = UIAlertActionStyleCancel;
        }
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:[NSString wy_emptyStr:actionTitle] style:alertActionStyle handler:^(UIAlertAction * _Nonnull action) {
            
            // 弹窗关闭时将各属性恢复成默认
            [self wy_defaultProperty];
            
            if(handler) {
                
                handler(action,[actionTitles indexOfObject:action.title]);
            }
        }];
        [self wy_modifyAlertControllerActionTitleStyle:alertController alertAction:alertAction];
        [alertController addAction:alertAction];
    }
    wy_weakSelf(self);
    [self.alertWindow.rootViewController presentViewController:alertController animated:YES completion:^{
        
        if((self.wy_clickBlankClose == YES) && (self.wy_preferredStyle == WYPreferredStyleAlert)) {
            
            [alertController wy_clickBlankCloseAlert:^{
                
                [weakself wy_defaultProperty];
            }];
        }
    }];
}

- (void)wy_showAlertControllerWithAttributedMessage:(NSAttributedString *_Nullable)alertMessage {
    
    [self wy_showAlertControllerWithAlertAttributedTitle:nil alertMessage:alertMessage];
}

- (void)wy_showAlertControllerWithAttributedMessage:(NSAttributedString *_Nullable)alertMessage
                                       actionTitles:(NSArray <NSString *>*_Nullable)actionTitles
                                            handler:(void(^__nullable)(UIAlertAction *alertAction, NSInteger actionIndex))handler {
    
    [self wy_showAlertControllerWithAlertAttributedTitle:nil alertMessage:alertMessage actionTitles:actionTitles handler:handler];
}

- (void)wy_showAlertControllerWithAlertAttributedTitle:(NSAttributedString *_Nullable)alertTitle
                                          alertMessage:(NSAttributedString *_Nullable)alertMessage {
    
    [self wy_showAlertControllerWithAlertAttributedTitle:alertTitle alertMessage:alertMessage actionTitles:nil handler:nil];
}

- (void)wy_showAlertControllerWithAlertAttributedTitle:(NSAttributedString *_Nullable)alertTitle
                                          alertMessage:(NSAttributedString *_Nullable)alertMessage
                                          actionTitles:(NSArray <NSString *>*_Nullable)actionTitles
                                               handler:(void(^__nullable)(UIAlertAction *alertAction, NSInteger actionIndex))handler {
    
    [self setValue:[NSString wy_emptyStr:alertTitle.string] forKey:NSStringFromSelector(@selector(wy_alertTitle))];
    [self setValue:[NSString wy_emptyStr:alertMessage.string] forKey:NSStringFromSelector(@selector(wy_alertMessage))];
    [self setValue:actionTitles forKey:NSStringFromSelector(@selector(wy_actionTitles))];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:([NSString wy_emptyStr:alertTitle.string].length > 0) ? alertTitle.string : nil  message:([NSString wy_emptyStr:alertMessage.string].length > 0) ? alertMessage.string : nil preferredStyle:(self.wy_preferredStyle == WYPreferredStyleAlert) ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    
    [alertController setValue:alertTitle forKey:@"attributedTitle"];
    [alertController setValue:alertMessage forKey:@"attributedMessage"];
    for (NSString *actionTitle in actionTitles) {
        
        UIAlertActionStyle alertActionStyle = UIAlertActionStyleDefault;
        if((self.wy_preferredStyle == WYPreferredStyleActionSheet) && (([actionTitles indexOfObject:actionTitle] == 0) || ([actionTitles indexOfObject:actionTitle] == (actionTitles.count-1))) && ([self.cancelTitleAry containsObject:actionTitle] == YES)) {
            
            alertActionStyle = UIAlertActionStyleCancel;
        }
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:[NSString wy_emptyStr:actionTitle] style:alertActionStyle handler:^(UIAlertAction * _Nonnull action) {
            
            // 弹窗关闭时将各属性恢复成默认
            [self wy_defaultProperty];
            
            if(handler) {
                
                handler(action,[actionTitles indexOfObject:action.title]);
            }
        }];
        [self wy_modifyAlertControllerActionTitleStyle:alertController alertAction:alertAction];
        [alertController addAction:alertAction];
    }
    wy_weakSelf(self);
    [self.alertWindow.rootViewController presentViewController:alertController animated:YES completion:^{
        
        if((self.wy_clickBlankClose == YES) && (self.wy_preferredStyle == WYPreferredStyleAlert)) {
            
            [alertController wy_clickBlankCloseAlert:^{
                
                [weakself wy_defaultProperty];
            }];
        }
    }];
}

- (void)wy_modifyAlertControllerStyle:(UIAlertController *)alertController {
    
    if([NSString wy_emptyStr:alertController.title].length > 0) {
        
        if((self.wy_alertTitleColor != nil) ||
           (self.wy_alertTitleFont != nil)) {
            
            NSMutableAttributedString *titleAttributed = [[NSMutableAttributedString alloc] initWithString:alertController.title];
            NSRange titleRange = [alertController.title rangeOfString:alertController.title];
            if(self.wy_alertTitleColor != nil) {
                
                [titleAttributed addAttribute:NSForegroundColorAttributeName value:self.wy_alertTitleColor range:titleRange];
            }
            
            if(self.wy_alertTitleFont != nil) {
                
                [titleAttributed addAttribute:NSFontAttributeName value:self.wy_alertTitleFont range:titleRange];
            }
            [alertController setValue:titleAttributed forKey:@"attributedTitle"];
        }
    }
    
    if([NSString wy_emptyStr:alertController.message].length > 0) {
        
        if((self.wy_alertMessageColor != nil) ||
           (self.wy_alertMessageFont != nil)) {
            
            NSMutableAttributedString *messageAttributed = [[NSMutableAttributedString alloc] initWithString:alertController.message];
            NSRange messageRange = [alertController.message rangeOfString:alertController.message];
            if(self.wy_alertMessageColor != nil) {
                
                [messageAttributed addAttribute:NSForegroundColorAttributeName value:self.wy_alertMessageColor range:messageRange];
            }
            
            if(self.wy_alertMessageFont != nil) {
                
                [messageAttributed addAttribute:NSFontAttributeName value:self.wy_alertMessageFont range:messageRange];
            }
            [alertController setValue:messageAttributed forKey:@"attributedMessage"];
        }
    }
}

- (void)wy_modifyAlertControllerActionTitleStyle:(UIAlertController *)alertController alertAction:(UIAlertAction *)alertAction {
    
    if(WY_iOSVersionAbove(8.4)) {
        
        NSInteger actionIndex = [self.wy_actionTitles indexOfObject:alertAction.title];
        UIColor *actionColor = nil;
        if(((self.wy_cancelActionColor != nil) && ([self.cancelTitleAry containsObject:alertAction.title] == YES) && ((actionIndex == 0) || (actionIndex == (self.wy_actionTitles.count-1))))) {
            
            actionColor = self.wy_cancelActionColor;
        }else {
            
            if(self.wy_otherActionColor != nil) {
                
                actionColor = self.wy_otherActionColor;
            }else {
                actionColor = self.wy_actionTitleColors[actionIndex];
            }
        }
        if((actionColor != nil) && ([actionColor isKindOfClass:[UIColor class]])) {
            
            [alertAction setValue:actionColor forKey:@"titleTextColor"];
        }
    }
}

- (void)wy_defaultProperty {
    
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    
    self.wy_preferredStyle = WYPreferredStyleAlert;
    self.wy_clickBlankClose = YES;
    self.wy_alertTitleColor = nil;
    self.wy_alertMessageColor = nil;
    self.wy_actionTitleColors = nil;
    self.wy_cancelActionColor = nil;
    self.wy_otherActionColor = nil;
    self.wy_alertTitleFont = nil;
    self.wy_alertMessageFont = nil;
    [self setValue:nil forKey:NSStringFromSelector(@selector(wy_alertTitle))];
    [self setValue:nil forKey:NSStringFromSelector(@selector(wy_alertMessage))];
    [self setValue:nil forKey:NSStringFromSelector(@selector(wy_actionTitles))];
    self.cancelTitleAry = @[@"取消",@"知道了",@"朕知道了"];
}

- (void)setWy_preferredStyle:(WYPreferredStyle)wy_preferredStyle {
    
    objc_setAssociatedObject(self, @selector(wy_preferredStyle), @(wy_preferredStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (WYPreferredStyle)wy_preferredStyle {
    
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setWy_clickBlankClose:(BOOL)wy_clickBlankClose {
    
    wy_clickBlankClose = !wy_clickBlankClose;
    objc_setAssociatedObject(self, @selector(wy_clickBlankClose), @(wy_clickBlankClose), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)wy_clickBlankClose {
    
    return ![objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setWy_alertTitleColor:(UIColor *)wy_alertTitleColor {
    
    objc_setAssociatedObject(self, @selector(wy_alertTitleColor), wy_alertTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)wy_alertTitleColor {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWy_alertMessageColor:(UIColor *)wy_alertMessageColor {
    
    objc_setAssociatedObject(self, @selector(wy_alertMessageColor), wy_alertMessageColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)wy_alertMessageColor {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWy_actionTitleColors:(NSArray<UIColor *> *)wy_actionTitleColors {
    
    objc_setAssociatedObject(self, @selector(wy_actionTitleColors), wy_actionTitleColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<UIColor *> *)wy_actionTitleColors {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWy_alertTitleFont:(UIFont *)wy_alertTitleFont {
    
    objc_setAssociatedObject(self, @selector(wy_alertTitleFont), wy_alertTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)wy_alertTitleFont {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWy_alertMessageFont:(UIFont *)wy_alertMessageFont {
    
    objc_setAssociatedObject(self, @selector(wy_alertMessageFont), wy_alertMessageFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)wy_alertMessageFont {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWy_alertTitle:(NSString * _Nonnull)wy_alertTitle {
    
    objc_setAssociatedObject(self, @selector(wy_alertTitle), wy_alertTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)wy_alertTitle {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWy_alertMessage:(NSString * _Nonnull)wy_alertMessage {
    
    objc_setAssociatedObject(self, @selector(wy_alertMessage), wy_alertMessage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)wy_alertMessage {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWy_actionTitles:(NSArray<NSString *> * _Nonnull)wy_actionTitles {
    
    objc_setAssociatedObject(self, @selector(wy_actionTitles), wy_actionTitles, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<NSString *> *)wy_actionTitles {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCancelTitleAry:(NSArray *)cancelTitleAry {
    
    objc_setAssociatedObject(self, @selector(cancelTitleAry), cancelTitleAry, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)cancelTitleAry {
    
    NSArray *ary = objc_getAssociatedObject(self, _cmd);
    if((ary == nil) || (ary.count <= 0)) {ary = @[@"取消",@"知道了",@"朕知道了"];}
    return ary;
}

- (void)setWy_cancelActionColor:(UIColor *)wy_cancelActionColor {
    
    objc_setAssociatedObject(self, @selector(wy_cancelActionColor), wy_cancelActionColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)wy_cancelActionColor {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWy_otherActionColor:(UIColor *)wy_otherActionColor {
    
    objc_setAssociatedObject(self, @selector(wy_otherActionColor), wy_otherActionColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)wy_otherActionColor {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (UIWindow *)alertWindow {
    
    UIWindow *showWindow = objc_getAssociatedObject(self, @selector(alertWindow));
    
    if(showWindow == nil) {
        
        showWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        showWindow.rootViewController = [[UIViewController alloc]init];
        
        objc_setAssociatedObject(self, @selector(alertWindow), showWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [showWindow makeKeyAndVisible];
    
    return showWindow;
}

@end
