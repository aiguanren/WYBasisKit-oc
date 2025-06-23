//
//  UILabel+WYRichText.h
//  WYBasisKit
//
//  Created by  guanren on 2018/11/27.
//  Copyright © 2018 guanren. All rights reserved.
//  感谢https://github.com/lyb5834/YBAttributeTextTapAction

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WYRichTextDelegate <NSObject>
@optional
/**
 *  RichTextDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index   点击的字符在数组中的index
 */
- (void)wy_didClickRichText:(NSString *)string
                   range:(NSRange)range
                   index:(NSInteger)index;
@end

@interface UILabel (WYRichText)

/**
 *  是否打开点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL wy_enabledClickEffect;

/**
 *  点击效果颜色 默认lightGrayColor
 */
@property (nonatomic, strong) UIColor *wy_clickEffectColor;

/**
 *  给文本添加Block点击事件回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param clickAction 点击事件回调
 *
 *  如果设置了富文本，建议把字号通过富文本重新设置下，否则会出现点击区域不准确的可能性
 */
- (void)wy_clickRichTextWithStrings:(NSArray <NSString *> *)strings
                     clickAction:(void (^) (NSString *string, NSRange range, NSInteger index))clickAction;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate 富文本代理
 *
 *  如果设置了富文本，建议把字号通过富文本重新设置下，否则会出现点击区域不准确的可能性
 */
- (void)wy_clickRichTextWithStrings:(NSArray <NSString *> *)strings
                        delegate:(id <WYRichTextDelegate> )delegate;

@end

NS_ASSUME_NONNULL_END
