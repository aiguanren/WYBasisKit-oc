//
//  UIView+WYExtension.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import "UIView+WYExtension.h"
#include <objc/runtime.h>
#import "MacroDefinition.h"
#import "UIFont+WYExtension.h"
#import "UIColor+WYExtension.h"
#import "UITextView+WYExtension.h"

@interface UIView ()

@property (nonatomic, weak) UIView *wy_mainView;

@property (nonatomic, assign) CGRect wy_mainViewFrame;

@end

@implementation UIView (WYExtension)

- (CGFloat)wy_width {return self.frame.size.width;}
- (void)setWy_width:(CGFloat)wy_width {
    
    CGRect frame = self.frame;
    frame.size.width = wy_width;
    self.frame = frame;
}

- (CGFloat)wy_height {return self.frame.size.height;}
- (void)setWy_height:(CGFloat)wy_height {
    
    CGRect frame = self.frame;
    frame.size.height = wy_height;
    self.frame = frame;
}

- (CGFloat)wy_left {return self.frame.origin.x;}
- (void)setWy_left:(CGFloat)wy_left {
    
    CGRect frame = self.frame;
    frame.origin.x = wy_left;
    self.frame = frame;
}

- (CGFloat)wy_top {return self.frame.origin.y;}
- (void)setWy_top:(CGFloat)wy_top {
    
    CGRect frame = self.frame;
    frame.origin.y = wy_top;
    self.frame = frame;
}

- (CGFloat)wy_right {return self.frame.origin.x+self.frame.size.width;}
- (void)setWy_right:(CGFloat)wy_right {
    
    CGRect frame = self.frame;
    frame.origin.x = wy_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)wy_bottom {return self.frame.origin.y+self.frame.size.height;};
- (void)setWy_bottom:(CGFloat)wy_bottom {
    
    CGRect frame = self.frame;
    frame.origin.y = wy_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)wy_centerx {return self.center.x;}
- (void)setWy_centerx:(CGFloat)wy_centerx {
    
    self.center = CGPointMake(wy_centerx, self.center.y);
}

- (CGFloat)wy_centery {return self.center.y;}
- (void)setWy_centery:(CGFloat)wy_centery {
    
    self.center = CGPointMake(self.center.x, wy_centery);
}

- (CGPoint)wy_origin {return self.frame.origin;}
- (void)setWy_origin:(CGPoint)wy_origin {
    
    CGRect frame = self.frame;
    frame.origin = wy_origin;
    self.frame = frame;
}

- (CGSize)wy_size {return self.frame.size;}
- (void)setWy_size:(CGSize)wy_size {
    
    CGRect frame = self.frame;
    frame.size = wy_size;
    self.frame = frame;
}

- (UIViewController *)wy_belongsViewController {
    
    for (UIView *next = self; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UIViewController *)wy_currentViewController {
    
    return [self wy_getCurrentViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
}

//递归查找
- (UIViewController *)wy_getCurrentViewController:(UIViewController *)controller {
    
    if ([controller isKindOfClass:[UITabBarController class]]) {
        
        UINavigationController *nav = ((UITabBarController *)controller).selectedViewController;
        return [nav.viewControllers lastObject];
    }
    else if ([controller isKindOfClass:[UINavigationController class]]) {
        
        return [((UINavigationController *)controller).viewControllers lastObject];
    }
    else if ([controller isKindOfClass:[UIViewController class]]) {
        
        return controller;
    }
    else {
        
        return nil;
    }
}

+ (UIView *)wy_createViewWithFrame:(CGRect)frame color:(UIColor *)color {
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor  = color;
    
    return view;
}

- (void)wy_addGestureAction:(id)target selector:(SEL)selector {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (void)wy_automaticFollowKeyboard:(UIView *)mainView {
    
    //监听键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wy_showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wy_hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    self.wy_mainView = mainView;
    self.wy_mainViewFrame = mainView.frame;
}

- (void)setWy_mainView:(UIView *)wy_mainView {
    
    objc_setAssociatedObject(self, &@selector(wy_mainView), wy_mainView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)wy_mainView {
    
    id obj = objc_getAssociatedObject(self, &@selector(wy_mainView));
    return obj;
}

- (void)setWy_mainViewFrame:(CGRect)wy_mainViewFrame {
    
    objc_setAssociatedObject(self, &@selector(wy_mainViewFrame), [NSValue valueWithCGRect:wy_mainViewFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)wy_mainViewFrame {
    
    id obj = objc_getAssociatedObject(self, &@selector(wy_mainViewFrame));
    return [obj CGRectValue];
}

- (void)wy_showKeyboard:(NSNotification *)noti {
    
    if(self.isFirstResponder == YES) {
        
        //键盘出现后的位置
        CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
        //键盘弹起时的动画效果
        UIViewAnimationOptions option = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
        //键盘动画时长
        NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
        
        CGFloat bottom = [self.superview convertPoint:self.frame.origin toView:self.wy_mainView].y+self.frame.size.height;
        
        ///如果self是UITextView，则需判断是否显示了右下角提示文本，如显示，则需要加上提示文本的高度25
        if([self isKindOfClass:[UITextView class]]) {
            
            UITextView *textView = (UITextView *)self;
            if(textView.wy_characterLengthPrompt == YES) {
                
                bottom = bottom+25;
            }
        }
        CGFloat extraHeight = [self wy_hasSystemNavigationBarExtraHeight];
        
        __weak typeof(self) textFieldSelf = self;
        if((bottom+extraHeight) > keyboardFrame.origin.y) {
            
            [UIView animateWithDuration:duration delay:0 options:option animations:^{
                
                textFieldSelf.wy_mainView.wy_top = -(bottom-keyboardFrame.origin.y);
                
            } completion:^(BOOL finished) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //为了显示动画
                    [textFieldSelf layoutIfNeeded];
                });
            }];
        }
    }
}

- (void)wy_hideKeyboard:(NSNotification *)noti {
    
    UIViewAnimationOptions option= [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    __weak typeof(self) textFieldSelf = self;
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        
        CGFloat extraHeight = [textFieldSelf wy_hasSystemNavigationBarExtraHeight];
        textFieldSelf.wy_mainView.wy_top = textFieldSelf.wy_mainViewFrame.origin.y+extraHeight;
        
    } completion:^(BOOL finished) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //为了显示动画
            [textFieldSelf layoutIfNeeded];
        });
    }];
}

//计算键盘弹出时的额外高度
- (CGFloat)wy_hasSystemNavigationBarExtraHeight {
    
    //相对于导航栏高度开始的 如果设置了导航栏的translucent = YES这时在添加子视图的坐标原点相对屏幕坐标是(0,0).如果设置了translucent = NO这时添加子视图的坐标原点相对屏幕坐标就是(0, navViewHeight)
    if(([self wy_belongsViewController].navigationController != nil) && ([self wy_belongsViewController].navigationController.navigationBar.hidden == NO) && ([self wy_belongsViewController].navigationController.navigationBar.translucent == NO)) {
        
        //判断是否隐藏的电池条
        if([UIApplication sharedApplication].statusBarHidden == NO) {
            
            return [[UIApplication sharedApplication] statusBarFrame].size.height+[self wy_belongsViewController].navigationController.navigationBar.frame.size.height;
            
        }else {
            
            return [self wy_belongsViewController].navigationController.navigationBar.frame.size.height;
        }
    }
    //相对于零点开始的
    return 0.0;
}

- (void)wy_gestureHidingkeyboard {
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wy_keyboardHide)];
    gesture.numberOfTapsRequired = 1;
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    gesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:gesture];
}

- (void)wy_keyboardHide {
    
    [self endEditing:YES];
}

- (void)wy_releaseKeyboardNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end

@implementation UIView (WYVisual)

/// 使用链式编程设置圆角、边框、阴影、渐变(调用方式类似Masonry，也可以.语法调用，点语法时需要自己在最后一个设置后面调用wy_showVisual后设置才会生效)
- (UIView *(^)(void (^)(UIView *)))wy_makeVisual {
    return ^UIView *(void (^block)(UIView *)) {
        if (block) {
            block(self);
        }
        return self.wy_showVisual();
    };
}

/// 圆角的位置，默认4角圆角
- (UIView *(^)(UIRectCorner))wy_rectCorner {
    return ^UIView *(UIRectCorner rectCorner) {
        self.privateRectCorner = rectCorner;
        return self;
    };
}

/// 圆角的半径，默认0.0
- (UIView *(^)(CGFloat))wy_cornerRadius {
    return ^UIView *(CGFloat radius) {
        self.privateConrnerRadius = radius;
        return self;
    };
}

/// 边框颜色，默认透明
- (UIView *(^)(UIColor *))wy_borderColor {
    return ^UIView *(UIColor *color) {
        self.privateBorderColor = color;
        return self;
    };
}

/// 边框宽度，默认0.0
- (UIView *(^)(CGFloat))wy_borderWidth {
    return ^UIView *(CGFloat width) {
        if ((self.privateAdjustBorderWidth != width) && (self.privateAdjustBorderWidth == 0)) {
            self.privateAdjustBorderWidth = self.privateBorderWidth;
        }
        if (self.privateAdjustBorderWidth > width) {
            self.privateAdjustBorderWidth = self.privateAdjustBorderWidth - width;
        }
        if (self.privateAdjustBorderWidth == width) {
            self.privateAdjustBorderWidth = self.privateAdjustBorderWidth - (width / 2);
        }
        self.privateBorderWidth = width;
        return self;
    };
}

/// 阴影颜色，默认透明
- (UIView *(^)(UIColor *))wy_shadowColor {
    return ^UIView *(UIColor *color) {
        self.privateShadowColor = color;
        return self;
    };
}

/// 阴影偏移度 (width : 为正数时，向右偏移，为负数时，向左偏移，height : 为正数时，向下偏移，为负数时，向上偏移)，默认zero
- (UIView *(^)(CGSize))wy_shadowOffset {
    return ^UIView *(CGSize offset) {
        self.privateShadowOffset = offset;
        return self;
    };
}

/// 阴影半径，默认0.0
- (UIView *(^)(CGFloat))wy_shadowRadius {
    return ^UIView *(CGFloat radius) {
        self.privateShadowRadius = radius;
        return self;
    };
}

/// 阴影模糊度(取值范围0~1)，默认0.5
- (UIView *(^)(CGFloat))wy_shadowOpacity {
    return ^UIView *(CGFloat opacity) {
        self.privateShadowOpacity = opacity;
        return self;
    };
}

/// 渐变色数组(设置渐变色时不能设置背景色，会有影响)
- (UIView *(^)(NSArray<UIColor *> *))wy_gradualColors {
    return ^UIView *(NSArray<UIColor *> *colors) {
        self.privateGradualColors = colors;
        return self;
    };
}


/// 渐变色方向，默认从左到右
- (UIView *(^)(WYGradientDirection))wy_gradientDirection {
    return ^UIView *(WYGradientDirection direction) {
        self.privateGradientDirection = direction;
        return self;
    };
}

/// 设置圆角时，会去获取视图的Bounds属性，如果此时获取不到，则需要传入该参数，默认为 nil，如果传入该参数，会设置视图的frame为bounds
- (UIView *(^)(CGRect))wy_viewBounds {
    return ^UIView *(CGRect bounds) {
        self.privateViewBounds = bounds;
        return self;
    };
}

/// 贝塞尔路径 默认nil (有值时，radius属性将失效)
- (UIView *(^)(UIBezierPath *))wy_bezierPath {
    return ^UIView *(UIBezierPath *path) {
        self.privateBezierPath = path;
        return self;
    };
}

/// 显示(更新)边框、阴影、圆角、渐变
- (UIView *(^)(void))wy_showVisual {
    return ^UIView *{
        // 强制更新布局以确保获取最新尺寸
        [self.superview layoutIfNeeded];
        [self layoutIfNeeded];
        
        // 抗锯齿边缘
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        // 添加边框、圆角
        [self wy_addBorderAndRadius];
        // 添加渐变
        [self wy_addGradual];
        // 添加阴影
        [self wy_addShadow];
        return self;
    };
}

/// 清除边框、阴影、圆角、渐变
- (UIView *(^)(void))wy_clearVisual {
    return ^UIView *{
        // 阴影
        if (self.shadowBackgroundView != nil) {
            [self.shadowBackgroundView removeFromSuperview];
            self.shadowBackgroundView = nil;
        }
        
        // 圆角、边框、渐变
        [self wy_removeLayerWithKey:UIView.boardLayerNameKey];
        [self wy_removeLayerWithKey:UIView.gradientLayerNameKey];
        
        // 恢复默认设置
        self.privateRectCorner          = UIRectCornerAllCorners;
        self.privateConrnerRadius       = 0.0;
        self.privateBorderColor         = UIColor.clearColor;
        self.privateBorderWidth         = 0.0;
        self.privateAdjustBorderWidth   = 0.0;
        self.privateShadowOpacity       = 0.0;
        self.privateShadowRadius        = 0.0;
        self.privateShadowOffset        = CGSizeZero;
        self.privateViewBounds          = CGRectZero;
        self.privateShadowColor         = UIColor.clearColor;
        self.privateGradualColors       = nil;
        self.privateGradientDirection   = leftToRight;
        self.shadowBackgroundView       = nil;
        
        self.layer.cornerRadius   = 0.0;
        self.layer.borderWidth    = 0.0;
        self.layer.borderColor    = UIColor.clearColor.CGColor;
        self.layer.shadowOpacity  = 0.0;
        self.layer.shadowPath     = nil;
        self.layer.shadowRadius   = 0.0;
        self.layer.shadowColor    = UIColor.clearColor.CGColor;
        self.layer.shadowOffset   = CGSizeZero;
        self.layer.mask           = nil;
        
        return self;
    };
}

/// 添加阴影
- (void)wy_addShadow {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIView *shadowView = self;
        
        if (self.shadowBackgroundView != nil) {
            [self.shadowBackgroundView removeFromSuperview];
            self.shadowBackgroundView = nil;
        }
        
        // 同时存在阴影和圆角
        if (((self.privateShadowOpacity > 0) && (self.privateConrnerRadius > 0)) || (self.privateBezierPath != nil)) {
            
            if (self.superview == nil) {
                NSLog(@"添加阴影和圆角时，请先将view加到父视图上");
            }
            
            shadowView = [[UIView alloc] initWithFrame:self.frame];
            shadowView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.superview insertSubview:shadowView belowSubview:self];
            
            [self.superview addConstraints:@[
                [NSLayoutConstraint constraintWithItem:shadowView
                                             attribute:NSLayoutAttributeTop
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                             attribute:NSLayoutAttributeTop
                                            multiplier:1.0
                                              constant:0],
                [NSLayoutConstraint constraintWithItem:shadowView
                                             attribute:NSLayoutAttributeLeft
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                             attribute:NSLayoutAttributeLeft
                                            multiplier:1.0
                                              constant:0],
                [NSLayoutConstraint constraintWithItem:shadowView
                                             attribute:NSLayoutAttributeRight
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                             attribute:NSLayoutAttributeRight
                                            multiplier:1.0
                                              constant:0],
                [NSLayoutConstraint constraintWithItem:shadowView
                                             attribute:NSLayoutAttributeBottom
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                             attribute:NSLayoutAttributeBottom
                                            multiplier:1.0
                                              constant:0]
            ]];
            
            self.shadowBackgroundView = shadowView;
        }
        
        // 圆角
        if ((self.privateConrnerRadius > 0) || (self.privateBezierPath != nil)) {
            UIBezierPath *shadowPath = self.wy_sharedBezierPath;
            shadowView.layer.shadowPath = shadowPath.CGPath;
        }
        
        // 阴影
        shadowView.layer.shadowOpacity = (float)self.privateShadowOpacity;
        shadowView.layer.shadowRadius  = self.privateShadowRadius;
        shadowView.layer.shadowOffset  = self.privateShadowOffset;
        shadowView.layer.shadowColor   = self.privateShadowColor.CGColor;
    });
}

/// 添加圆角和边框
- (void)wy_addBorderAndRadius {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 移除旧边框图层
        [self wy_removeLayerWithKey:UIView.boardLayerNameKey];
        self.layer.mask = nil;
        
        // 圆角或阴影或自定义曲线
        if ((self.privateConrnerRadius > 0) || (self.privateShadowOpacity > 0) || (self.privateBezierPath != nil)) {
            // 圆角
            if ((self.privateConrnerRadius > 0) || (self.privateBezierPath != nil)) {
                UIBezierPath *bezierPath = self.wy_sharedBezierPath;
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = self.wy_sharedBounds;
                maskLayer.path = bezierPath.CGPath;
                self.layer.mask = maskLayer;
            }
            
            // 边框
            if ((self.privateBorderWidth > 0) || (self.privateBezierPath != nil)) {
                
                UIBezierPath *bezierPath = self.wy_sharedBezierPath;
                CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
                borderLayer.name = UIView.boardLayerNameKey;
                borderLayer.frame = self.wy_sharedBounds;
                borderLayer.path = bezierPath.CGPath;
                borderLayer.lineWidth = (self.privateConrnerRadius > 0) ? (self.privateBorderWidth * 2) : self.privateBorderWidth;
                borderLayer.strokeColor = self.privateBorderColor.CGColor;
                borderLayer.fillColor = UIColor.clearColor.CGColor;
                borderLayer.lineCap = kCALineCapSquare;
                borderLayer.lineJoin = kCALineJoinMiter;
                [self.layer addSublayer:borderLayer];
            }
            
        }else {
            // 只有边框
            CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
            borderLayer.path = [self.wy_sharedBezierPath CGPath];
            borderLayer.fillColor = UIColor.clearColor.CGColor;
            borderLayer.strokeColor = self.privateBorderColor.CGColor;
            borderLayer.lineWidth = self.privateBorderWidth;
            borderLayer.frame = self.wy_sharedBounds;
            borderLayer.lineCap = kCALineCapSquare;
            borderLayer.lineJoin = kCALineJoinMiter;
            [self.layer addSublayer:borderLayer];
        }
    });
}

/// 添加渐变色
- (void)wy_addGradual {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 渐变色数组个数必须大于1才能满足渐变要求
        if (self.privateGradualColors.count <= 1) {
            NSLog(@"渐变色数组个数必须大于1才能满足渐变要求");
            return;
        }
        
        NSMutableArray *CGColors = [NSMutableArray arrayWithCapacity:self.privateGradualColors.count];
        for (UIColor *gradualColor in self.privateGradualColors) {
            //CGColorRef originalColor = gradualColor.CGColor;
            [CGColors addObject:(__bridge id)gradualColor.CGColor];
        }
        
        CGPoint startPoint = CGPointZero;
        CGPoint endPoint = CGPointZero;
        
        switch (self.privateGradientDirection) {
            case topToBottom:
                startPoint = CGPointMake(0.0, 0.0);
                endPoint = CGPointMake(0.0, 1.0);
                break;
            case leftToRight:
                startPoint = CGPointMake(0.0, 0.0);
                endPoint = CGPointMake(1.0, 0.0);
                break;
            case leftToLowRight:
                startPoint = CGPointMake(0.0, 0.0);
                endPoint = CGPointMake(1.0, 1.0);
                break;
            case rightToLowLeft:
                startPoint = CGPointMake(1.0, 0.0);
                endPoint = CGPointMake(0.0, 1.0);
                break;
        }
        
        // 新增GradientLayer前先移除上次新增的GradientLayer
        [self wy_removeLayerWithKey:UIView.gradientLayerNameKey];
        
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.name = UIView.gradientLayerNameKey;
        gradientLayer.frame = self.wy_sharedBounds;
        gradientLayer.colors = CGColors;
        gradientLayer.startPoint = startPoint;
        gradientLayer.endPoint = endPoint;
        [self.layer insertSublayer:gradientLayer atIndex:0];
    });
}

- (CGRect)wy_sharedBounds {
    
    // 获取在自动布局前的视图大小
    if (CGRectEqualToRect(self.privateViewBounds, CGRectZero) == NO) {
        return self.privateViewBounds;
    }else {
        if (self.superview != nil) {
            [self.superview layoutIfNeeded];
        }
        
        if (CGRectEqualToRect(self.bounds, CGRectZero)) {
            NSLog(@"设置圆角、边框、阴影、渐变时需要view拥有frame或约束");
        }
        return self.bounds;
    }
}

- (UIBezierPath *)wy_sharedBezierPath {
    
    if (self.privateBezierPath != nil) {
        return self.privateBezierPath;
        
    }else {
        CGRect bounds = self.wy_sharedBounds;
        
        // 内缩量为边框宽度的一半
        CGFloat borderInset = (self.privateBorderWidth / 2.0);
        // 减去privateAdjustBorderWidth是因为要补全上次减去的边框宽度
        CGFloat adjustBorderWidth = self.privateAdjustBorderWidth;
        if ((adjustBorderWidth == 0) && (self.privateConrnerRadius > 0)) {
            adjustBorderWidth = (self.privateBorderWidth / 2);
        }
        if ((adjustBorderWidth != 0) && (self.privateConrnerRadius == 0)) {
            adjustBorderWidth = 0;
        }
        
        CGRect adjustedRect = CGRectInset(bounds, borderInset - adjustBorderWidth, borderInset - adjustBorderWidth);

        // 调整圆角半径防止负值
        CGFloat adjustedRadius = MAX(0, self.privateConrnerRadius - borderInset);

        return [UIBezierPath bezierPathWithRoundedRect:adjustedRect
                                   byRoundingCorners:self.privateRectCorner
                                         cornerRadii:CGSizeMake(adjustedRadius, adjustedRadius)];
    }
}

- (UIRectCorner)privateRectCorner {
    NSNumber *obj = objc_getAssociatedObject(self, &@selector(privateRectCorner));
    return obj ? (UIRectCorner)[obj unsignedIntegerValue] : UIRectCornerAllCorners;
}

- (void)setPrivateRectCorner:(UIRectCorner)privateRectCorner {
    objc_setAssociatedObject(self,
                                &@selector(privateRectCorner),
                                @(privateRectCorner),
                                OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)privateConrnerRadius {
    NSNumber *obj = objc_getAssociatedObject(self, &@selector(privateConrnerRadius));
    return obj ? [obj doubleValue] : 0.0;
}

- (void)setPrivateConrnerRadius:(CGFloat)privateConrnerRadius {
    objc_setAssociatedObject(self,
                             &@selector(privateConrnerRadius),
                            @(privateConrnerRadius),
                            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)privateBorderColor {
    UIColor *obj = objc_getAssociatedObject(self, &@selector(privateBorderColor));
    return obj ? obj : [UIColor clearColor];
}

- (void)setPrivateBorderColor:(UIColor *)privateBorderColor {
    objc_setAssociatedObject(self, &@selector(privateBorderColor), privateBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)privateBorderWidth {
    NSNumber *obj = objc_getAssociatedObject(self, &@selector(privateBorderWidth));
    return obj ? [obj doubleValue] : 0.0;
}

- (void)setPrivateBorderWidth:(CGFloat)privateBorderWidth {
    objc_setAssociatedObject(self,
                             &@selector(privateBorderWidth),
                            @(privateBorderWidth),
                            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)privateAdjustBorderWidth {
    NSNumber *obj = objc_getAssociatedObject(self, &@selector(privateAdjustBorderWidth));
    return obj ? [obj doubleValue] : 0.0;
}

- (void)setPrivateAdjustBorderWidth:(CGFloat)privateAdjustBorderWidth {
    objc_setAssociatedObject(self,
                             &@selector(privateAdjustBorderWidth),
                            @(privateAdjustBorderWidth),
                            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)privateShadowColor {
    UIColor *obj = objc_getAssociatedObject(self, &@selector(privateShadowColor));
    return obj ? obj : [UIColor clearColor];
}

- (void)setPrivateShadowColor:(UIColor *)privateShadowColor {
    objc_setAssociatedObject(self, &@selector(privateShadowColor), privateShadowColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)privateShadowOffset {
    return [objc_getAssociatedObject(self, &@selector(privateShadowOffset)) CGSizeValue];
}

- (void)setPrivateShadowOffset:(CGSize)privateShadowOffset {
    objc_setAssociatedObject(self, &@selector(privateShadowOffset), [NSValue valueWithCGSize:privateShadowOffset], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)privateShadowRadius {
    NSNumber *obj = objc_getAssociatedObject(self, &@selector(privateShadowRadius));
    return obj ? [obj doubleValue] : 0.0;
}

- (void)setPrivateShadowRadius:(CGFloat)privateShadowRadius {
    objc_setAssociatedObject(self,
                             &@selector(privateShadowRadius),
                            @(privateShadowRadius),
                            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)privateShadowOpacity {
    NSNumber *obj = objc_getAssociatedObject(self, &@selector(privateShadowOpacity));
    return obj ? [obj doubleValue] : 0.5;
}

- (void)setPrivateShadowOpacity:(CGFloat)privateShadowOpacity {
    objc_setAssociatedObject(self,
                             &@selector(privateShadowOpacity),
                            @(privateShadowOpacity),
                            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WYGradientDirection)privateGradientDirection {
    
    NSNumber *obj = objc_getAssociatedObject(self, _cmd);
    return obj ? (WYGradientDirection)[obj unsignedIntegerValue] : leftToRight;
}

- (void) setPrivateGradientDirection:(WYGradientDirection)privateGradientDirection {
    objc_setAssociatedObject(self, @selector(privateGradientDirection), @(privateGradientDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray <UIColor *>*)privateGradualColors {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPrivateGradualColors:(NSArray <UIColor *>*)privateGradualColors {
    objc_setAssociatedObject(self, @selector(privateGradualColors), privateGradualColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)privateViewBounds {
    return [objc_getAssociatedObject(self, &@selector(privateViewBounds)) CGRectValue];
}

- (void)setPrivateViewBounds:(CGRect)privateViewBounds {
    objc_setAssociatedObject(self, &@selector(privateViewBounds), [NSValue valueWithCGRect:privateViewBounds], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIBezierPath *)privateBezierPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPrivateBezierPath:(UIBezierPath *)privateBezierPath {
    objc_setAssociatedObject(self, @selector(privateBezierPath), privateBezierPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIView *)shadowBackgroundView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setShadowBackgroundView:(UIView *)shadowBackgroundView {
    objc_setAssociatedObject(self, @selector(shadowBackgroundView), shadowBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// 移除上次添加的layer
- (void)wy_removeLayerWithKey:(NSString *)layerKey {
    NSMutableArray *layersToRemove = [NSMutableArray array];
    for (CALayer *sublayer in self.layer.sublayers) {
        if ([sublayer.name isEqualToString:layerKey]) {
            [layersToRemove addObject:sublayer];
        }
    }
    for (CALayer *layer in layersToRemove) {
        [layer removeFromSuperlayer];
    }
}

+ (NSString *)boardLayerNameKey {    
    static NSString *boardLayerNameKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        boardLayerNameKey = [NSString stringWithFormat:@"%p", @(@"boardLayerNameKey".hash)];
    });
    return boardLayerNameKey;
}

+ (NSString *)gradientLayerNameKey {
    static NSString *gradientLayerNameKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gradientLayerNameKey = [NSString stringWithFormat:@"%p", @(@"gradientLayerNameKey".hash)];
    });
    return gradientLayerNameKey;
}

@end
