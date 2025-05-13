//
//  UIButton+WYEdgeInsets.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import "UIButton+WYEdgeInsets.h"
#import <objc/runtime.h>

@implementation UIButton (WYEdgeInsets)

- (void)wy_layouEdgeInsetsPosition:(WYButtonPosition)postion spacing:(CGFloat)spacing {
    
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    switch (postion) {
        case WYButtonPositionImageLeft_titleRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case WYButtonPositionImageRight_titleLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
            
        case WYButtonPositionImageTop_titleBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;
            
        case WYButtonPositionImageBottom_titleTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
    
}

#pragma mark - ************* 通过运行时动态添加关联 ******************
//定义关联的Key
static const char *titleRectKey = "titleRectKey";
- (CGRect)wy_titleRect {
    
    return [objc_getAssociatedObject(self, titleRectKey) CGRectValue];
}

- (void)setWy_titleRect:(CGRect)wy_titleRect {
    
    objc_setAssociatedObject(self, titleRectKey, [NSValue valueWithCGRect:wy_titleRect], OBJC_ASSOCIATION_RETAIN);
}

//定义关联的Key
static const char *imageRectKey = "imageRectKey";
- (CGRect)wy_imageRect {
    
    NSValue * rectValue = objc_getAssociatedObject(self, imageRectKey);
    
    return [rectValue CGRectValue];
}

- (void)setWy_imageRect:(CGRect)wy_imageRect {
    
    objc_setAssociatedObject(self, imageRectKey, [NSValue valueWithCGRect:wy_imageRect], OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - ************* 通过运行时动态替换方法 ******************
+ (void)load {
    MethodSwizzle(self,@selector(titleRectForContentRect:),@selector(wy_override_titleRectForContentRect:));
    MethodSwizzle(self,@selector(imageRectForContentRect:),@selector(wy_override_imageRectForContentRect:));
}

void MethodSwizzle(Class c,SEL origSEL,SEL overrideSEL)
{
    
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method overrideMethod= class_getInstanceMethod(c, overrideSEL);
    
    //运行时函数class_addMethod 如果发现方法已经存在，会失败返回，也可以用来做检查用:
    if(class_addMethod(c, origSEL, method_getImplementation(overrideMethod),method_getTypeEncoding(overrideMethod)))
    {
        //如果添加成功(在父类中重写的方法)，再把目标类中的方法替换为旧有的实现:
        class_replaceMethod(c,overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else
    {
        //addMethod会让目标类的方法指向新的实现，使用replaceMethod再将新的方法指向原先的实现，这样就完成了交换操作。
        method_exchangeImplementations(origMethod,overrideMethod);
    }
}

- (CGRect)wy_override_titleRectForContentRect:(CGRect)contentRect {
    
    if (!CGRectIsEmpty(self.wy_titleRect) && !CGRectEqualToRect(self.wy_titleRect, CGRectZero)) {
        return self.wy_titleRect;
    }
    return [self wy_override_titleRectForContentRect:contentRect];
    
}

- (CGRect)wy_override_imageRectForContentRect:(CGRect)contentRect {
    
    if (!CGRectIsEmpty(self.wy_imageRect) && !CGRectEqualToRect(self.wy_imageRect, CGRectZero)) {
        return self.wy_imageRect;
    }
    return [self wy_override_imageRectForContentRect:contentRect];
}

- (void)wy_layoutTitleRect:(CGRect)titleRect imageRect:(CGRect)imageRect {
    
    self.wy_titleRect = titleRect;
    self.wy_imageRect = imageRect;
}

@end
