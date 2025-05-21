//
//  UIButton+WYExtension.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import "UIButton+WYExtension.h"

@implementation UIButton (WYExtension)

- (void)setWy_nTitle:(NSString *)wy_nTitle {
    
    [self setTitle:wy_nTitle forState:UIControlStateNormal];
}

- (NSString *)wy_nTitle {
    
    return [self titleForState:UIControlStateNormal];
}

- (void)setWy_hTitle:(NSString *)wy_hTitle {
    
    [self setTitle:wy_hTitle forState:UIControlStateHighlighted];
}

- (NSString *)wy_hTitle {
    
    return [self titleForState:UIControlStateHighlighted];
}

- (void)setWy_sTitle:(NSString *)wy_sTitle {
    
    [self setTitle:wy_sTitle forState:UIControlStateSelected];
}

- (NSString *)wy_sTitle {
    
    return [self titleForState:UIControlStateSelected];
}

- (void)setWy_title_nColor:(UIColor *)wy_title_nColor {
    
    [self setTitleColor:wy_title_nColor forState:UIControlStateNormal];
}

- (UIColor *)wy_title_nColor {
    
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setWy_title_hColor:(UIColor *)wy_title_hColor {
    
    [self setTitleColor:wy_title_hColor forState:UIControlStateHighlighted];
}

- (UIColor *)wy_title_hColor {
    
    return [self titleColorForState:UIControlStateHighlighted];
}

- (void)setWy_title_sColor:(UIColor *)wy_title_sColor {
    
    [self setTitleColor:wy_title_sColor forState:UIControlStateSelected];
}

- (UIColor *)wy_title_sColor {
    
    return [self titleColorForState:UIControlStateSelected];
}

- (void)setWy_nImage:(UIImage *)wy_nImage {
    
    [self setImage:wy_nImage forState:UIControlStateNormal];
}

- (UIImage *)wy_nImage {
    
    return [self imageForState:UIControlStateNormal];
}

- (void)setWy_hImage:(UIImage *)wy_hImage {
    
    [self setImage:wy_hImage forState:UIControlStateHighlighted];
}

- (UIImage *)wy_hImage {
    
    return [self imageForState:UIControlStateHighlighted];
}

- (void)setWy_sImage:(UIImage *)wy_sImage {
    
    [self setImage:wy_sImage forState:UIControlStateSelected];
}

- (UIImage *)wy_sImage {
    
    return [self imageForState:UIControlStateSelected];
}

- (void)setWy_bg_nImage:(UIImage *)wy_bg_nImage {
    
    [self setBackgroundImage:wy_bg_nImage forState:UIControlStateNormal];
}

- (UIImage *)wy_bg_nImage {
    
    return [self backgroundImageForState:UIControlStateNormal];
}

- (void)setWy_bg_hImage:(UIImage *)wy_bg_hImage {
    
    [self setBackgroundImage:wy_bg_hImage forState:UIControlStateHighlighted];
}

- (UIImage *)wy_bg_hImage {
    
    return [self backgroundImageForState:UIControlStateHighlighted];
}

- (void)setWy_bg_sImage:(UIImage *)wy_bg_sImage {
    
    [self setBackgroundImage:wy_bg_sImage forState:UIControlStateSelected];
}

- (UIImage *)wy_bg_sImage {
    
    return [self backgroundImageForState:UIControlStateSelected];
}

- (void)setWy_bg_nImageColor:(UIColor *)wy_bg_nImageColor {
    
    [self setBackgroundImage:[UIImage wy_createImage:wy_bg_nImageColor] forState:UIControlStateNormal];
}

- (UIColor *)wy_bg_nImageColor {
    
    return [UIImage wy_colorFromImage:[self backgroundImageForState:UIControlStateNormal]];
}

- (void)setWy_bg_hImageColor:(UIColor *)wy_bg_hImageColor {
    
    [self setBackgroundImage:[UIImage wy_createImage:wy_bg_hImageColor] forState:UIControlStateHighlighted];
}

- (UIColor *)wy_bg_hImageColor {
    
    return [UIImage wy_colorFromImage:[self backgroundImageForState:UIControlStateHighlighted]];
}

- (void)setWy_bg_sImageColor:(UIColor *)wy_bg_sImageColor {
    
    [self setBackgroundImage:[UIImage wy_createImage:wy_bg_sImageColor] forState:UIControlStateSelected];
}

- (UIColor *)wy_bg_sImageColor {
    
    return [UIImage wy_colorFromImage:[self backgroundImageForState:UIControlStateSelected]];
}

- (void)setWy_titleFont:(UIFont *)wy_titleFont {
    
    self.titleLabel.font = wy_titleFont;
}

- (UIFont *)wy_titleFont {
    
    return self.titleLabel.font;
}

- (void)wy_setBackgroundColor:(UIColor *)color state:(UIControlState)state {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage:image forState:state];
}

- (void)wy_radius:(CGFloat)radius {
    
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}

- (void)wy_leftAlign {
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

- (void)wy_centerAlign {
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

- (void)wy_rightAlign {
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

- (void)wy_topAlign {
    
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
}

- (void)wy_bottomAlign {
    
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
}

- (void)wy_addTarget:(id)target selector:(SEL)selector {
    
    [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end
