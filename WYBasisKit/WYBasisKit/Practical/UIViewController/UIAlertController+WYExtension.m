//
//  UIAlertController+WYExtension.m
//  WYBasisKit
//
//  Created by bangtuike on 2019/6/28.
//  Copyright © 2019 jacke-xu. All rights reserved.
//

#import "UIAlertController+WYExtension.h"
#import "UIViewController+WYAlert.h"
#import <objc/runtime.h>

@interface UIAlertController ()<UIGestureRecognizerDelegate>

@property (nonatomic, copy) void(^wy_clickBlock)(void);

@end

@implementation UIAlertController (WYExtension)

- (void)wy_clickBlankCloseAlert:(void (^)(void))completion {
    
    NSArray *arrayViews = [UIApplication sharedApplication].keyWindow.subviews;
    
    if (arrayViews.count > 0) {
    //array会有两个对象，一个是UILayoutContainerView，另外一个是UITransitionView，我们找到最后一个
        UIView *backView = arrayViews.lastObject;
        
        backView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wy_closeAlert)];
        tap.delegate = self;
        [backView addGestureRecognizer:tap];
        
        self.wy_clickBlock = completion;
    }
}

- (void)wy_closeAlert {
    
    if(self.wy_clickBlock) {
        
        self.wy_clickBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    UIView *tapView = gestureRecognizer.view;
    CGPoint point = [touch locationInView:tapView];
    CGPoint conPoint = [self.view convertPoint:point fromView:tapView];
    BOOL isContains = CGRectContainsPoint(self.view.bounds, conPoint);
    if (isContains) {
        // 单击点包含在alert区域内 不响应tap手势
        return NO;
    }
    return YES;
}

- (void)setWy_clickBlock:(void (^)(void))wy_clickBlock {
    
    objc_setAssociatedObject(self, @selector(wy_clickBlock), wy_clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))wy_clickBlock {
    
    return objc_getAssociatedObject(self, _cmd);
}

@end
