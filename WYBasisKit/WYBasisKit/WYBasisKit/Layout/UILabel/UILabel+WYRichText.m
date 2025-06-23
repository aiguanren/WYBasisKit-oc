//
//  UILabel+WYRichText.m
//  WYBasisKit
//
//  Created by  guanren on 2018/11/27.
//  Copyright © 2018 guanren. All rights reserved.
//

#import "UILabel+WYRichText.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>

#define weakSelf(type)      __weak typeof(type) weak##type = type;

@interface WYRichTextModel : NSObject

@property (nonatomic, copy) NSString *wy_str;

@property (nonatomic, assign) NSRange wy_range;

@end

@implementation WYRichTextModel

@end

@implementation UILabel (WYRichText)

#pragma mark - AssociatedObjects

- (NSMutableArray *)wy_attributeStrings {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWy_attributeStrings:(NSMutableArray *)wy_attributeStrings {
    
    objc_setAssociatedObject(self, @selector(wy_attributeStrings), wy_attributeStrings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)wy_effectDic {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWy_effectDic:(NSMutableDictionary *)wy_effectDic {
    
    objc_setAssociatedObject(self, @selector(wy_effectDic), wy_effectDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wy_isClickAction {
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setWy_isClickAction:(BOOL)wy_isClickAction {
    
    objc_setAssociatedObject(self, @selector(wy_isClickAction), @(wy_isClickAction), OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)(NSString * _Nonnull, NSRange, NSInteger))wy_clickBlock {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWy_clickBlock:(void (^)(NSString * _Nonnull, NSRange, NSInteger))wy_clickBlock {
    
    objc_setAssociatedObject(self, @selector(wy_clickBlock), wy_clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id<WYRichTextDelegate>)delegate {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDelegate:(id<WYRichTextDelegate>)delegate {
    
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)wy_enabledClickEffect {
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setWy_enabledClickEffect:(BOOL)wy_enabledClickEffect {
    
    objc_setAssociatedObject(self, @selector(wy_enabledClickEffect), @(wy_enabledClickEffect), OBJC_ASSOCIATION_ASSIGN);
    self.wy_isClickEffect = wy_enabledClickEffect;
}

- (UIColor *)wy_clickEffectColor {
    
    UIColor *obj = objc_getAssociatedObject(self, _cmd);
    if(obj == nil) {obj = [UIColor lightGrayColor];}
    return obj;
}

- (void)setWy_clickEffectColor:(UIColor *)wy_clickEffectColor {
    
    objc_setAssociatedObject(self, @selector(wy_clickEffectColor), wy_clickEffectColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wy_isClickEffect {
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setWy_isClickEffect:(BOOL)wy_isClickEffect {
    
    objc_setAssociatedObject(self, @selector(wy_isClickEffect), @(wy_isClickEffect), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - mainFunction
- (void)wy_clickRichTextWithStrings:(NSArray<NSString *> *)strings clickAction:(void (^)(NSString *, NSRange, NSInteger))clickAction {
    
    [self wy_richTextRangesWithStrings:strings];
    
    if (self.wy_clickBlock != clickAction) {
        self.wy_clickBlock = clickAction;
    }
}

- (void)wy_clickRichTextWithStrings:(NSArray<NSString *> *)strings delegate:(id<WYRichTextDelegate>)delegate {
    
    [self wy_richTextRangesWithStrings:strings];
    
    if ([self delegate] != delegate) {
        
        [self setDelegate:delegate];
    }
}

#pragma mark - touchAction
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.wy_isClickAction) {
        return;
    }
    
    if (objc_getAssociatedObject(self, @selector(wy_enabledClickEffect))) {
        self.wy_isClickEffect = self.wy_enabledClickEffect;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    weakSelf(self);
    [self wy_richTextFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        
        if (weakself.wy_clickBlock) {
            weakself.wy_clickBlock (string , range , index);
        }
        
        if ([weakself delegate] && [[weakself delegate] respondsToSelector:@selector(wy_didClickRichText:range:index:)]) {
            [[weakself delegate] wy_didClickRichText:string range:range index:index];
        }
        
        if (weakself.wy_isClickEffect) {
            
            [weakself wy_saveEffectDicWithRange:range];
            
            [weakself wy_clickEffectWithStatus:YES];
        }
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if((self.wy_isClickAction) && ([self wy_richTextFrameWithTouchPoint:point result:nil])) {
        
        return self;
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - getClickFrame
- (BOOL)wy_richTextFrameWithTouchPoint:(CGPoint)point result:(void (^) (NSString *string , NSRange range , NSInteger index))resultBlock
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    CFRange range = CTFrameGetVisibleStringRange(frame);
    
    if (self.attributedText.length > range.length) {
        
        UIFont *font = nil;
        
        if ([self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil]) {
            
            font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
            
        }else if (self.font){
            font = self.font;
            
        }else {
            font = [UIFont systemFontOfSize:17];
        }
        
        CGFloat lineSpace = 0.0f;
        if ([self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil]) {
            
            lineSpace = [[[self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil] valueForKey:@"_lineSpacing"] floatValue];
        }
        
        CGPathRelease(Path);
        
        Path = CGPathCreateMutable();
        
        CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + font.lineHeight - lineSpace));
        
        frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    if (!lines) {
        if(frame) {CFRelease(frame);}
        if(framesetter) {CFRelease(framesetter);}
        if(Path) {CGPathRelease(Path);}
        return NO;
    }
    
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint origins[count];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CGAffineTransform transform = [self wy_transformForCoreText];
    
    CGFloat verticalOffset = 0;
    
    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect flippedRect = [self wy_getLineBounds:line point:linePoint];
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        rect = CGRectInset(rect, 0, 0);
        
        rect = CGRectOffset(rect, 0, verticalOffset);
        
        NSParagraphStyle *style = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        
        CGFloat lineSpace;
        
        if (style) {
            lineSpace = style.lineSpacing;
        }else {
            lineSpace = 0;
        }
        
        CGFloat lineOutSpace = (self.bounds.size.height - lineSpace * (count - 1) -rect.size.height * count) / 2;
        
        rect.origin.y = lineOutSpace + rect.size.height * i + lineSpace * i;
        
        if (CGRectContainsPoint(rect, point)) {
            
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            
            CGFloat offset;
            
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            
            NSInteger link_count = self.wy_attributeStrings.count;
            
            for (int j = 0; j < link_count; j++) {
                
                WYRichTextModel *model = self.wy_attributeStrings[j];
                
                NSRange link_range = model.wy_range;
                if (NSLocationInRange(index, link_range)) {
                    if (resultBlock) {
                        resultBlock (model.wy_str , model.wy_range , (NSInteger)j);
                    }
                    if(frame){CFRelease(frame);}
                    if(framesetter){CFRelease(framesetter);}
                    if(Path){CGPathRelease(Path);}
                    return YES;
                }
            }
        }
    }
    if(frame){CFRelease(frame);}
    if(framesetter){CFRelease(framesetter);}
    if(Path){CGPathRelease(Path);}
    return NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.wy_isClickEffect) {
        
        [self performSelectorOnMainThread:@selector(wy_clickEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.wy_isClickEffect) {
        
        [self performSelectorOnMainThread:@selector(wy_clickEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
}

- (CGAffineTransform)wy_transformForCoreText
{
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)wy_getLineBounds:(CTLineRef)line point:(CGPoint)point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + fabs(descent) + leading;
    
    return CGRectMake(point.x, point.y , width, height);
}

#pragma mark - clickEffect
- (void)wy_clickEffectWithStatus:(BOOL)status
{
    if (self.wy_isClickEffect) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        NSMutableAttributedString *subAtt = [[NSMutableAttributedString alloc] initWithAttributedString:[[self.wy_effectDic allValues] firstObject]];
        
        NSRange range = NSRangeFromString([[self.wy_effectDic allKeys] firstObject]);
        
        if (status) {
            [subAtt addAttribute:NSBackgroundColorAttributeName value:self.wy_clickEffectColor range:NSMakeRange(0, subAtt.string.length)];
            
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }else {
            
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }
        self.attributedText = attStr;
    }
}

- (void)wy_saveEffectDicWithRange:(NSRange)range
{
    self.wy_effectDic = [NSMutableDictionary dictionary];
    
    NSAttributedString *subAttribute = [self.attributedText attributedSubstringFromRange:range];
    
    [self.wy_effectDic setObject:subAttribute forKey:NSStringFromRange(range)];
}

#pragma mark - getRange
- (void)wy_richTextRangesWithStrings:(NSArray <NSString *>  *)strings
{
    if (self.attributedText == nil) {
        self.wy_isClickAction = NO;
        return;
    }
    
    self.wy_isClickAction = YES;
    
    self.wy_isClickEffect = YES;
    
    __block  NSString *totalStr = self.attributedText.string;
    
    self.wy_attributeStrings = [NSMutableArray array];
    
    weakSelf(self);
    [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSRange range = [totalStr rangeOfString:obj];
        
        if (range.length != 0) {
            
            totalStr = [totalStr stringByReplacingCharactersInRange:range withString:[weakself wy_getStringWithRange:range]];
            
            WYRichTextModel *model = [[WYRichTextModel alloc]init];
            
            model.wy_range = range;
            
            model.wy_str = obj;
            
            [weakself.wy_attributeStrings addObject:model];
        }
    }];
}

- (NSString *)wy_getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    
    for (int i = 0; i < range.length ; i++) {
        
        [string appendString:@" "];
    }
    return string;
}

@end
