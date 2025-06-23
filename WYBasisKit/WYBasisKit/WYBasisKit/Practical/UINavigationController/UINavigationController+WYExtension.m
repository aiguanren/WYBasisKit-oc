//
//  UINavigationController+WYExtension.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/6/19.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import "UINavigationController+WYExtension.h"
#include <objc/runtime.h>
#import "UIImage+WYExtension.h"
#import "UIViewController+WYExtension.h"

static NSString *const barReturnButtonDelegate = @"barReturnButtonDelegate";

@implementation UINavigationController (WYExtension)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(wy_viewDidLoad);
        
        Method originMethod = class_getInstanceMethod(class, originSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class,
                                            originSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originMethod),
                                method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)wy_viewDidLoad
{
    [self wy_viewDidLoad];
    
    objc_setAssociatedObject(self, [barReturnButtonDelegate UTF8String], self.interactivePopGestureRecognizer.delegate, OBJC_ASSOCIATION_ASSIGN);
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)wy_navigationBarTransparent {
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationBar.translucent = YES;
}

- (void)wy_navigationBarOpaque {
    
    self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:nil];
}

- (UIColor *)wy_titleColor {
    
    UIColor *obj = objc_getAssociatedObject(self, &@selector(wy_titleColor));
    
    return obj;
}
- (void)setWy_titleColor:(UIColor *)wy_titleColor {
    
    objc_setAssociatedObject(self, &@selector(wy_titleColor), wy_titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : (wy_titleColor ? wy_titleColor : [UIColor blackColor]),
                                                 NSFontAttributeName : (self.wy_titleFont ? self.wy_titleFont : [UIFont fontWithName:@"Helvetica-Bold" size:17])}];
}

- (UIFont *)wy_titleFont {
    
    UIFont *obj = objc_getAssociatedObject(self, &@selector(wy_titleFont));
    
    return obj;
}
- (void)setWy_titleFont:(UIFont *)wy_titleFont {
    
    objc_setAssociatedObject(self, &@selector(wy_titleFont), wy_titleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : (self.wy_titleColor ? self.wy_titleColor : [UIColor blackColor]),
                                                 NSFontAttributeName : (wy_titleFont ? wy_titleFont : [UIFont fontWithName:@"Helvetica-Bold" size:17])}];
}

- (UIColor *)wy_barBackgroundColor {
    
    UIColor *obj = objc_getAssociatedObject(self, &@selector(wy_barBackgroundColor));
    
    return obj;
}
- (void)setWy_barBackgroundColor:(UIColor *)wy_barBackgroundColor {
    
    objc_setAssociatedObject(self, &@selector(wy_barBackgroundColor), wy_barBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationBar setBackgroundImage:[UIImage wy_createImage:wy_barBackgroundColor] forBarMetrics:UIBarMetricsDefault];
}

- (UIImage *)wy_barBackgroundImage {
    
    UIImage *obj = objc_getAssociatedObject(self, &@selector(wy_barBackgroundImage));
    
    return obj;
}

- (void)setWy_barBackgroundImage:(UIImage *)wy_barBackgroundImage {

    objc_setAssociatedObject(self, &@selector(wy_barBackgroundImage), wy_barBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationBar setBackgroundImage:wy_barBackgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (void)wy_hidesNavigationBarsOnSwipe {
    
    self.hidesBarsOnSwipe = YES;
}

- (UIImage *)wy_barReturnButtonImage {
    
    UIImage *obj = objc_getAssociatedObject(self, &@selector(wy_barReturnButtonImage));
    
    return obj;
}

- (void)setWy_barReturnButtonImage:(UIImage *)wy_barReturnButtonImage {
    
    objc_setAssociatedObject(self, &@selector(wy_barReturnButtonImage), wy_barReturnButtonImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.navigationBar.backIndicatorTransitionMaskImage = wy_barReturnButtonImage;
    self.navigationBar.backIndicatorImage = wy_barReturnButtonImage;
}

- (UIColor *)wy_barReturnButtonColor {
    
    UIColor *obj = objc_getAssociatedObject(self, &@selector(wy_barReturnButtonColor));
    
    return obj;
}

- (void)setWy_barReturnButtonColor:(UIColor *)wy_barReturnButtonColor {
    
    objc_setAssociatedObject(self, &@selector(wy_barReturnButtonColor), wy_barReturnButtonColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self.navigationBar setTintColor:wy_barReturnButtonColor];
}

- (void)wy_pushControllerBarReturnButtonTitle:(NSString *)barReturnButtonTitle navigationItem:(UINavigationItem *)navigationItem {
    
    if(navigationItem.backBarButtonItem == nil) {
        
        navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:barReturnButtonTitle style:UIBarButtonItemStylePlain target:nil action:nil];
    }else {
        
        navigationItem.backBarButtonItem.title = barReturnButtonTitle;
    }
}

- (void)wy_customLeftBarButtonItem:(UINavigationItem *)navigationItem target:(id)target selector:(SEL)selector complete:(void (^)(UIButton *))complete {
    
    navigationItem.leftBarButtonItem = [self barButtonItemWithItemType:0 target:target selector:selector complete:complete];
}

- (void)wy_customRightBarButtonItem:(UINavigationItem *)navigationItem target:(id)target selector:(SEL)selector complete:(void (^)(UIButton *))complete {
    
    navigationItem.rightBarButtonItem = [self barButtonItemWithItemType:1 target:target selector:selector complete:complete];
}

- (UIBarButtonItem *)barButtonItemWithItemType:(NSInteger)itemType target:(id)target selector:(SEL)selector complete:(void (^)(UIButton *))complete {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.contentHorizontalAlignment = (itemType == 0) ? UIControlContentHorizontalAlignmentLeft : UIControlContentHorizontalAlignmentRight;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    if(complete) {complete(button);}
    
    return barButtonItem;
}

#pragma mark - 按钮
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(wy_navigationBarWillReturn)]) {
        shouldPop = [vc wy_navigationBarWillReturn];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // 取消 pop 后，复原返回按钮的状态
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}

#pragma mark - 手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        UIViewController *vc = [self topViewController];
        if([vc respondsToSelector:@selector(wy_navigationBarWillReturn)]) {
            return [vc wy_navigationBarWillReturn];
        }
        id<UIGestureRecognizerDelegate> originDelegate = objc_getAssociatedObject(self, [barReturnButtonDelegate UTF8String]);
        return [originDelegate gestureRecognizerShouldBegin:gestureRecognizer];
    }
    return YES;
}

@end
