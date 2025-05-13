//
//  UILabel+WYExtension.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import "UILabel+WYExtension.h"
#import <objc/runtime.h>

@implementation UILabel (WYExtension)

+ (void)load {
    
    method_exchangeImplementations(class_getInstanceMethod(self.class, @selector(textRectForBounds:limitedToNumberOfLines:)),
                                   class_getInstanceMethod(self.class, @selector(wy_textRectForBounds:wy_limitedToNumberOfLines:)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, @selector(drawTextInRect:)),
                                   class_getInstanceMethod(self.class, @selector(wy_drawTextInRect:)));
}

- (CGFloat)wy_lineHeight {return self.font.lineHeight;}

- (void)setWy_textInsets:(UIEdgeInsets)wy_textInsets {
    
    NSArray *textInsets = @[@(wy_textInsets.top),@(wy_textInsets.left),@(wy_textInsets.bottom),@(wy_textInsets.right)];
    objc_setAssociatedObject(self, @selector(wy_textInsets), textInsets, OBJC_ASSOCIATION_RETAIN);
}

- (UIEdgeInsets)wy_textInsets {
    
    NSArray *textInsets = objc_getAssociatedObject(self, @selector(wy_textInsets));
    return UIEdgeInsetsMake([textInsets[0] floatValue], [textInsets[1] floatValue], [textInsets[2] floatValue], [textInsets[3] floatValue]);
}

- (void)wy_leftAlign {self.textAlignment = NSTextAlignmentLeft;}

- (void)wy_centerAlign {self.textAlignment = NSTextAlignmentCenter;}

- (void)wy_rightAlign {self.textAlignment = NSTextAlignmentRight;}

+ (UILabel *)wy_createLabWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font {
    
    UILabel *lab = [[UILabel alloc]initWithFrame:frame];
    lab.textColor = textColor;
    lab.font = font;
    
    return lab;
}

- (CGRect)wy_textRectForBounds:(CGRect)bounds wy_limitedToNumberOfLines:(NSInteger)numberOfLines {
    
    /*
     注意传入的UIEdgeInsetsInsetRect(bounds, self.edgeInsets),bounds是真正的绘图区域
     CGRect rect = [super textRectForBounds: limitedToNumberOfLines:numberOfLines];
     类别中不能使用 super   用黑魔法替换方法
     */
    CGRect rect = [self wy_textRectForBounds:UIEdgeInsetsInsetRect(bounds,self.wy_textInsets) wy_limitedToNumberOfLines:numberOfLines];
    //根据edgeInsets，修改绘制文字的bounds
    rect.origin.x -= self.wy_textInsets.left;
    rect.origin.y -= self.wy_textInsets.top;
    rect.size.width += self.wy_textInsets.left + self.wy_textInsets.right;
    rect.size.height += self.wy_textInsets.top + self.wy_textInsets.bottom;
    
    return rect;
}
//绘制文字
- (void)wy_drawTextInRect:(CGRect)rect {
    
    //令绘制区域为原始区域，增加的内边距区域不绘制
    [self wy_drawTextInRect:UIEdgeInsetsInsetRect(rect, self.wy_textInsets)];
}

@end
