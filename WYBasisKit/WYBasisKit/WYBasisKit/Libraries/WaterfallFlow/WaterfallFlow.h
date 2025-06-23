//
//  WaterfallFlow.h
//  WYBasisKit
//
//  Created by jacke-xu on 2017/7/7.
//  Copyright © 2017年 jacke-xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WaterfallFlow : NSObject

/**
 *  按照本地图片返回缩放后的size
 *
 *  image  本地图片
 *
 *  placeholderSize  默认显示的图片控件size
 */
+ (CGSize)zoomImageSizeFromImage:(UIImage *)image placeholderSize:(CGSize)placeholderSize;

/**
 *  按照控件size返回一个等比缩放好的图片的size
 *
 *  imageUrl  图片url
 *
 *  placeholderSize  默认显示的图片控件size
 */
+ (CGSize)zoomImageSizeFromUrl:(NSString *)imageUrl placeholderSize:(CGSize)placeholderSize;

/**
 *  按照给定的url下载图片，并且在下载完成后自动刷新界面
 *
 *  reloadView  需要刷新的view  只能是UICollectionView或UITableView
 *
 *  imageView  显示图片的控件
 *
 *  placeholderImage  占位图
 *
 *  progress  下载进度
 *
 *  completed 下载完成后返回图像和缓存key
 */
+ (void)downloadImageFromUrl:(NSString *)imageUrl reloadView:(UIView *)reloadView imageView:(UIImageView *)imageView placeholderImage:(UIImage *)placeholderImage  progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize))progress completed:(void(^)(UIImage *image, NSString *imageURL))completed;

@end
