//
//  WaterfallFlow.m
//  WYBasisKit
//
//  Created by jacke-xu on 2017/7/7.
//  Copyright © 2017年 jacke-xu. All rights reserved.
//

#import "WaterfallFlow.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "MacroDefinition.h"

@implementation WaterfallFlow

+ (CGSize)zoomImageSizeFromImage:(UIImage *)image placeholderSize:(CGSize)placeholderSize {
    
    CGSize size = CGSizeMake(placeholderSize.width, placeholderSize.height);
    CGSize originalSize = image.size;
    if(originalSize.width > 0) {
        
        if(originalSize.width > size.width) {
            
            size = CGSizeMake(size.width, originalSize.height/(originalSize.width/size.width));
            
        }else {
            
            size = CGSizeMake(size.width, originalSize.height*(size.width/originalSize.width));
        }
    }
    
    return size;
}

+ (CGSize)zoomImageSizeFromUrl:(NSString *)imageUrl placeholderSize:(CGSize)placeholderSize {
    
    CGSize size = CGSizeMake(placeholderSize.width, placeholderSize.height);
    UIImage *cacaeImage = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:imageUrl];
    if (cacaeImage != nil) {
        
        CGSize originalSize = cacaeImage.size;
        if(originalSize.width > 0) {
            
            if(originalSize.width > size.width) {
                
                size = CGSizeMake(size.width, originalSize.height/(originalSize.width/size.width));
                
            }else {
                
                size = CGSizeMake(size.width, originalSize.height*(size.width/originalSize.width));
            }
        }
    }
    
    return size;
}

+ (void)downloadImageFromUrl:(NSString *)imageUrl reloadView:(UIView *)reloadView imageView:(UIImageView *)imageView placeholderImage:(UIImage *)placeholderImage progress:(void (^)(NSInteger, NSInteger))progress completed:(void (^)(UIImage *, NSString *))completed {
    
    UIImage *cacaeImage = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:imageUrl];
    if(cacaeImage == nil) {
        
        wy_weakSelf(self);
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
            if(progress) {
                
                progress(receivedSize, expectedSize);
            }
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            [weakself completedWithImage:image imageUrl:imageURL reloadView:reloadView completed:completed];
        }];
    }else {
        
        imageView.image = cacaeImage;
        if(completed) {
            
            completed(cacaeImage, imageUrl);
        }
    }
}

+ (void)completedWithImage:(UIImage *)image imageUrl:(NSURL *)imageUrl reloadView:(UIView *)reloadView completed:(void(^)(UIImage *image, NSString *imageURL))completed {
    
    WY_GCD_MainThread(^{
        
        if(completed) {
            
            completed(image, [imageUrl absoluteString]);
        }
        
        if([reloadView isKindOfClass:[UITableView class]]) {
            
            UITableView *tableView = (UITableView *)reloadView;
            [tableView reloadData];
            
            
        }else if ([reloadView isKindOfClass:[UICollectionView class]]) {
            
            UICollectionView *collectionView = (UICollectionView *)reloadView;
            [collectionView reloadData];
            
        }else {
            
            NSLog(@"不支持reloadData的view");
        }
    });
}

@end
