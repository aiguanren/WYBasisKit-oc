//
//  UIImageView+WYExtension.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import "UIImageView+WYExtension.h"
#import "UIImageView+WebCache.h"
#include <objc/runtime.h>

@implementation UIImageView (WYExtension)

- (void)setWy_imageUrl:(NSString *)wy_imageUrl {
    
    [self sd_setImageWithURL:[NSURL URLWithString:wy_imageUrl] placeholderImage:self.wy_placeholderImage];
    
    objc_setAssociatedObject(self, &@selector(wy_imageUrl), wy_imageUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)wy_imageUrl {
    
    NSString *obj = objc_getAssociatedObject(self, &@selector(wy_imageUrl));
    return obj;
}

- (void)setWy_placeholderImage:(UIImage *)wy_placeholderImage {
    
    [self sd_setImageWithURL:[NSURL URLWithString:self.wy_imageUrl] placeholderImage:wy_placeholderImage];
    
    objc_setAssociatedObject(self, &@selector(wy_placeholderImage), wy_placeholderImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)wy_placeholderImage {
    
    UIImage *obj = objc_getAssociatedObject(self, &@selector(wy_placeholderImage));
    return obj;
}

- (void)wy_refreshImageUrl:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage {
    
    self.wy_imageUrl = imageUrl;
    self.wy_placeholderImage = placeholderImage;
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholderImage];
}

+ (UIImageView *)wy_createImageViewWithFrame:(CGRect)frame radius:(CGFloat)radius {
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.layer.cornerRadius = radius;
    imageView.clipsToBounds = YES;
    
    return imageView;
}

+ (UIImageView *)wy_createImageViewWithFrame:(CGRect)frame radius:(CGFloat)radius image:(nonnull UIImage *)image {
    
    UIImageView *imageView = [self wy_createImageViewWithFrame:frame radius:radius];
    imageView.image = image;
    
    return imageView;
}

@end
