//
//  WYFileModel.h
//  WYBasisKit
//
//  Created by  guanren on 2018/8/28.
//  Copyright © 2018年 guanren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///上传文件的类型
typedef enum : NSUInteger {
    
    ///上传文件-->图片
    fileTypeImage = 0,
    ///上传文件-->音频
    fileTypeAudio,
    ///上传文件-->视频
    fileTypeVideo,
    ///上传文件-->URL路径上传
    fileTypeUrl,
} FileType;

@interface WYFileModel : NSObject

#pragma mark 选传项
/**
 *  上传的文件的上传后缀(选传项，例如，JPEG图像的MIME类型是image/jpeg，具体参考http://www.iana.org/assignments/media-types/.)
 *  可根据具体的上传文件类型自由设置，默认上传图片时设置为image/jpeg，上传音频时设置为audio/aac，上传视频时设置为video/mp4，上传url时设置为application/octet-stream
 */
@property (nonatomic, copy) NSString *mimeType;

/**
 *  上传的文件的名字(选传项)
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  上传的文件的文件夹名字(选传项)
 */
@property (nonatomic, copy) NSString *folderName;

/**
 *  上传图片压缩比例(选传项，0~1.0区间，1.0代表无损，默认无损)
 */
@property (nonatomic, assign) CGFloat compressionQuality;

/**
 *  上传文件的类型(选传项，默认fileTypeImage)
 */
@property (nonatomic, assign) FileType fileType;


#pragma mark 以下3项根据调用的API上传方法选择传入其中一项即可
/**
 *  上传的图片
 */
@property (nonatomic, strong, nullable) UIImage *fileImage;

/**
 *  上传的二进制文件
 */
@property (nonatomic, strong, nullable) NSData *fileData;

/**
 *  上传的资源URL
 */
@property (nonatomic, copy) NSString *fileUrl;

@end

NS_ASSUME_NONNULL_END
