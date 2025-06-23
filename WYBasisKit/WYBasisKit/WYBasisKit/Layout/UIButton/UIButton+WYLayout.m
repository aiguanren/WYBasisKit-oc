//
//  UIButton+WYLayout.m
//  WYBasisKit
//
//  Created by  guanren on 2018/11/27.
//  Copyright © 2018 guanren. All rights reserved.
//

#import "UIButton+WYLayout.h"
#import <objc/runtime.h>

@implementation UIButton (WYLayout)

- (void)wy_adjustWithPosition:(WYButtonPosition)position spacing:(CGFloat)spacing {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.imageView.image || self.currentTitle.length == 0) {
            return;
        }
        
        [self.superview layoutIfNeeded];
        
        if (@available(iOS 15.0, *)) {
            
            UIButtonConfiguration *configuration = self.configuration ? [self.configuration copy] : [UIButtonConfiguration plainButtonConfiguration];
            
            switch (position) {
                case WYButtonPositionImageLeftTitleRight:
                    configuration.imagePlacement = NSDirectionalRectEdgeLeading;
                    break;
                    
                case WYButtonPositionImageRightTitleLeft:
                    configuration.imagePlacement = NSDirectionalRectEdgeTrailing;
                    break;
                    
                case WYButtonPositionImageTopTitleBottom:
                    configuration.imagePlacement = NSDirectionalRectEdgeTop;
                    break;
                    
                case WYButtonPositionImageBottomTitleTop:
                    configuration.imagePlacement = NSDirectionalRectEdgeBottom;
                    break;
            }
            
            configuration.imagePadding = spacing;
            self.configuration = configuration;
            [self setNeedsUpdateConfiguration];
            
        } else {
            
            CGFloat imageWidth = self.imageView.frame.size.width;
            CGFloat imageHeight = self.imageView.frame.size.height;
            CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
            CGFloat labelHeight = self.titleLabel.intrinsicContentSize.height;
            
            CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
            CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
            CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
            CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
            
            switch (position) {
                case WYButtonPositionImageLeftTitleRight:
                    self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
                    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
                    break;
                    
                case WYButtonPositionImageRightTitleLeft:
                    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
                    self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
                    break;
                    
                case WYButtonPositionImageTopTitleBottom:
                    self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
                    self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
                    break;
                    
                case WYButtonPositionImageBottomTitleTop:
                    self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
                    self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
                    break;
                    
                default:
                    break;
            }
        }
        
        // 强制更新布局
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
    });
}

#pragma mark - ************* 通过运行时动态添加关联 ******************
- (void)setWy_titleRect:(CGRect)wy_titleRect {
    objc_setAssociatedObject(self, @selector(wy_titleRect), [NSValue valueWithCGRect:wy_titleRect], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [UIButton swizzleLayoutSubviews];
    [self setNeedsLayout];
}

- (CGRect)wy_titleRect {
    return [objc_getAssociatedObject(self, @selector(wy_titleRect)) CGRectValue];
}

- (void)setWy_imageRect:(CGRect)wy_imageRect {
    objc_setAssociatedObject(self, @selector(wy_imageRect), [NSValue valueWithCGRect:wy_imageRect], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [UIButton swizzleLayoutSubviews];
    [self setNeedsLayout];
}

- (CGRect)wy_imageRect {
    return [objc_getAssociatedObject(self, @selector(wy_imageRect)) CGRectValue];
}

#pragma mark - Method Swizzling

+ (void)swizzleLayoutSubviews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(wy_custom_layoutSubviews);
        
        Method originalMethod = class_getInstanceMethod(cls, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)wy_custom_layoutSubviews {
    [self wy_custom_layoutSubviews]; // 调用原始 layoutSubviews
    
    [self.titleLabel sizeToFit];
    [self.imageView sizeToFit];
    
    NSValue *imageRectValue = objc_getAssociatedObject(self, @selector(wy_imageRect));
    if (imageRectValue) {
        self.imageView.frame = [imageRectValue CGRectValue];
    }
    
    NSValue *titleRectValue = objc_getAssociatedObject(self, @selector(wy_titleRect));
    if (titleRectValue) {
        self.titleLabel.frame = [titleRectValue CGRectValue];
    }
}

@end
