//
//  UIImageView+WYExtension.h
//  WYBasisKit
//
//  Created by  guanren on 2018/11/27.
//  Copyright © 2018 guanren. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (WYExtension)

/** 通过SDWebImage设置imageUrl */
@property (nonatomic, copy) NSString *wy_imageUrl;

/** 通过SDWebImage设置placeholderImage */
@property (nonatomic, strong) UIImage *wy_placeholderImage;

/** 通过SDWebImage设置imageUrl和placeholderImage */
- (void)wy_refreshImageUrl:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage;

/** 创建imageView */
+ (UIImageView *)wy_createImageViewWithFrame:(CGRect)frame radius:(CGFloat)radius;

/** 创建本地图片imageView */
+ (UIImageView *)wy_createImageViewWithFrame:(CGRect)frame radius:(CGFloat)radius image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
