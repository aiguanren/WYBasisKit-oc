//
//  UIImage+WYUserAvatar.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/12/29.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///字符显示模式
typedef NS_ENUM(NSUInteger, WYAvatarImageType) {
    
    ///全部显示(字符长度尽量短,否则可能出现文字超出图片边界的情况)
    WYAvatarImageTypeShowAll             = 0,
    ///显示第一位字符
    WYAvatarImageTypeFirstCharacter      = 1,
    ///显示最后一位字符
    WYAvatarImageTypeLastCharacter       = 2,
};

@interface WYUserAvatarOptional : NSObject

///要生成的图片的size,默认60*60
@property (nonatomic, assign) CGSize avatarSize;

///要生成的图片的圆角半径,默认图片宽/2
@property (nonatomic, assign) CGFloat avatarRadius;

///要生成的图片的背景色,默认17c295
@property (nonatomic, strong) UIColor *avatarBackgroundColor;

///要生成的图片的哈希背景色数组,默认[@"17c295",@"b38979",@"f2725e",@"f7b55e",@"4da9eb",@"5f70a7",@"568aad"]
@property (nonatomic, strong) NSArray <UIColor *>*hashBackgroundColorAry;

///要生成的图片的背景色是否采用哈希背景色数组,默认YES
@property (nonatomic, assign) BOOL adoptHash;

///要生成的图片的文字颜色,默认白色
@property (nonatomic, strong) UIColor *avatarTitleColor;

///要生成的图片的文字字号,默认系统15号字体
@property (nonatomic, strong) UIFont *avatarTitleFont;

///是否需要过滤特殊符号,如中划线、下划线等,默认YES
@property (nonatomic, assign) BOOL filterSpecial;

///要生成的图片的文字显示配置,默认显示全部
@property (nonatomic, assign) WYAvatarImageType avatarImageType;

@end

@interface UIImage (WYUserAvatar)


/**
 根据传入的字符串生成图片(可用于生成用户头像等)
 
 @param character 要生成图片的字符串
 @param optional 要生成的图片的可选设置项
 @return 返回生成好的图片
 */
+ (UIImage *)wy_generateAvatarImageWithCharacter:(NSString *)character optional:(WYUserAvatarOptional *_Nullable)optional;

@end

NS_ASSUME_NONNULL_END
