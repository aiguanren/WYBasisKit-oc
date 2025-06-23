//
//  UITextField+WYExtension.m
//  WYBasisKit
//
//  Created by  guanren on 2018/11/27.
//  Copyright © 2018 guanren. All rights reserved.
//

#import "UITextField+WYExtension.h"
#include <objc/runtime.h>
#import "NSString+WYExtension.h"

@interface UITextField ()

@property (nonatomic, assign) BOOL wy_addNoti;

@property (nonatomic, copy) NSString *wy_lastTextStr;

@property (nonatomic, copy) void(^wy_textHandle) (NSString *textStr);

@end

@implementation UITextField (WYExtension)

- (void)setWy_placeholderColor:(UIColor *)wy_placeholderColor {
    
    if (self.placeholder == nil) {
        return;
    }
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                 attributes:@{
        NSForegroundColorAttributeName: wy_placeholderColor ?: [UIColor lightGrayColor]
    }];
}

- (UIColor *)wy_placeholderColor {
    
    return [self valueForKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setWy_clearButtonImage:(UIImage *)wy_clearButtonImage {
    
    if(wy_clearButtonImage == nil) return;
    
    objc_setAssociatedObject(self, @selector(wy_clearButtonImage), wy_clearButtonImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    [clearButton setImage:wy_clearButtonImage forState:UIControlStateNormal];
}

- (UIImage *)wy_clearButtonImage {
    
    return objc_getAssociatedObject(self, @selector(wy_clearButtonImage));
}

- (void)setWy_addNoti:(BOOL)wy_addNoti {
    
    objc_setAssociatedObject(self, @selector(wy_addNoti), [NSNumber numberWithBool:wy_addNoti], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)wy_addNoti {
    
    BOOL obj = [objc_getAssociatedObject(self, _cmd) boolValue];
    return obj;
}

- (void)setWy_maximumLimit:(NSInteger)wy_maximumLimit {
    
    objc_setAssociatedObject(self, @selector(wy_maximumLimit), @(wy_maximumLimit), OBJC_ASSOCIATION_ASSIGN);
    
    [self wy_fixMessyDisplay];
}

- (NSInteger)wy_maximumLimit {
    
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setWy_allowCopyPaste:(BOOL)wy_allowCopyPaste {
    
    wy_allowCopyPaste = !wy_allowCopyPaste;
    
    objc_setAssociatedObject(self, @selector(wy_allowCopyPaste), [NSNumber numberWithBool:wy_allowCopyPaste], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)wy_allowCopyPaste {
    
    BOOL obj = ![objc_getAssociatedObject(self, _cmd) boolValue];
    return obj;
}

- (void)setWy_textHandle:(void (^)(NSString *))wy_textHandle {
    
    objc_setAssociatedObject(self, @selector(wy_textHandle), wy_textHandle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSString *))wy_textHandle {
    
    return objc_getAssociatedObject(self, @selector(wy_textHandle));
}

- (void)setWy_lastTextStr:(NSString *)wy_lastTextStr {
    
    objc_setAssociatedObject(self, @selector(wy_lastTextStr), wy_lastTextStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)wy_lastTextStr {
    
    return [NSString wy_emptyStr:objc_getAssociatedObject(self, _cmd)];
}

/**
 *  监听文字改变
 */
- (void)wy_textDidChange {
    
    [self wy_characterTruncation];
}

- (void)wy_textDidChange:(void (^)(NSString * _Nonnull))handle {
    
    self.wy_textHandle = handle;
    [self wy_fixMessyDisplay];
}

- (void)wy_fixMessyDisplay {
    
    if(self.wy_maximumLimit <= 0) {self.wy_maximumLimit = MAXFLOAT;}
    [self wy_addTextChangeNoti];
}

- (void)wy_addTextChangeNoti {
    
    if(self.wy_addNoti == NO) {
        
        // 当UITextField的文字发生改变时，UITextField自己会发出一个UITextFieldTextDidChangeNotification通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wy_textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    }
    self.wy_addNoti = YES;
}

- (NSString *)wy_characterTruncation {
    
    //字符截取
    if(self.wy_maximumLimit > 0) {
        
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制,如果有高亮待选择的字，则暂不对文字进行统计和限制
        if ((position == nil) && (self.text.length > self.wy_maximumLimit)) {
            
            const char *res = [self.text substringToIndex:self.wy_maximumLimit].UTF8String;
            if (res == NULL) {
                self.text = [self.text substringToIndex:self.wy_maximumLimit - 1];
            }else{
                self.text = [self.text substringToIndex:self.wy_maximumLimit];
            }
        }
    }
    if((self.wy_textHandle) && (![self.text isEqualToString:self.wy_lastTextStr])) {
        
        self.wy_textHandle(self.text);
    }
    self.wy_lastTextStr = self.text;
    
    return self.text;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    // 禁止剪切
    if (action == @selector(cut:)) return self.wy_allowCopyPaste;
    
    // 禁止粘贴
    if (action == @selector(paste:)) return self.wy_allowCopyPaste;
    
    // 禁止选择
    if (action == @selector(select:)) return self.wy_allowCopyPaste;
    
    // 禁止全选
    if (action == @selector(selectAll:)) return self.wy_allowCopyPaste;
    
    return [super canPerformAction:action withSender:sender];
}

- (void)dealloc {
    
    if(self.wy_addNoti == YES) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }
}

@end
