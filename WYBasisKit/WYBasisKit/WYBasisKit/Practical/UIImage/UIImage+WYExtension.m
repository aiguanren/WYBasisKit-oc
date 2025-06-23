//
//  UIImage+WYExtension.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/28.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import "UIImage+WYExtension.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>
#import <CoreImage/CoreImage.h>

@implementation UIImage (WYExtension)

/**
 *  获取图片宽
 */
- (CGFloat)wy_width {
    
    return self.size.width;
}

/**
 *  获取图片高
 */
- (CGFloat)wy_height {
    
    return self.size.height;
}

/**
 *  获取启动页图片
 *
 *  @return 启动页图片
 */
+ (UIImage *)wy_launchImage {
    
    UIImage               *lauchImage      = nil;
    NSString              *viewOrientation = nil;
    CGSize                 viewSize        = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation orientation     = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
        viewOrientation = @"Landscape";
        
    } else {
        
        viewOrientation = @"Portrait";
    }
    
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary) {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    
    return lauchImage;
}

/**
 *  加载非.Bound文件下图片，单张、或2x、3x均适用(若加载非png图片需要拼接后缀名)
 *
 *  @param image 图片名
 */
+ (UIImage *)wy_loadImage:(NSString *)image {
    
    return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:image]];
}

/**
 *  加载.Bound文件下图片(无子文件夹，若加载非png图片需要拼接后缀名)
 *
 *  @param image 图片名
 *
 *  images  bundle名：images.bundle
 */
+ (UIImage *)wy_bundleImage:(NSString *)image {
    
    return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] pathForResource:@"Images" ofType:@"bundle"] stringByAppendingPathComponent:image]];
}

/**
 *  加载.Bound文件下子文件夹图片(若加载非png图片需要拼接后缀名)
 *
 *  @param fileName 图片文件夹名
 *
 *  @param fileImage 图片名
 *
 *  images bundle名：images.bundle
 */
+ (UIImage *)wy_fileImage:(NSString *)fileImage fileName:(NSString *)fileName {
    
    return [UIImage imageWithContentsOfFile:[[[[NSBundle mainBundle] pathForResource:@"Images" ofType:@"bundle"] stringByAppendingPathComponent:fileName] stringByAppendingPathComponent:fileImage]];
}

//字符串转图片
+ (UIImage *)wy_base64StrToUIImage:(NSString *)encodedImageStr {
    
    NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:encodedImageStr options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    
    return decodedImage;
}

//图片转字符串
+ (NSString *)wy_imageToBase64Str:(UIImage *)image {
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

/** 图片上绘制文字 */
- (UIImage *)wy_imageAddTitle:(NSString *)title font:(UIFont *)font color:(nonnull UIColor *)color {
    
    //画布大小
    CGSize size = CGSizeMake(self.size.width,self.size.height);
    //创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);//opaque:NO  scale:0.0
    
    [self drawAtPoint:CGPointMake(0.0,0.0)];
    
    //文字居中显示在画布上
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中
    
    //计算文字所占的size,文字居中显示在画布上
    CGSize sizeText = [title boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:font}context:nil].size;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    CGRect rect = CGRectMake((width-sizeText.width)/2, (height-sizeText.height)/2, sizeText.width, sizeText.height);
    //绘制文字
    [title drawInRect:rect withAttributes:@{ NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraphStyle}];
    
    //返回绘制的新图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  返回一个缩放好的图片
 *
 *  @param image  要切割的图片
 *  @param newImageSize 需要切割成的大小 边框的宽度
 *
 *  @return 切割好的图片
 */
+ (UIImage *)wy_cutImage:(UIImage*)image andSize:(CGSize)newImageSize
{
    
    UIGraphicsBeginImageContextWithOptions(newImageSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)];
    //从上下文中取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


/**
 *  根据url返回一个圆形的头像
 *
 *  @param iconUrl 头像的URL
 *  @param border  边框的宽度
 *  @param color   边框的颜色
 *
 *  @return 切割好的头像
 */
+ (UIImage *)wy_captureCircleImageWithURL:(NSString *)iconUrl andBorderWith:(CGFloat)border andBorderColor:(UIColor *)color
{
    return [self wy_captureCircleImageWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]]] andBorderWith:border andBorderColor:color];
}

/**
 *  根据iamge返回一个圆形的头像
 *
 *  @param iconImage 要切割的头像
 *  @param border    边框的宽度
 *  @param color     边框的颜色
 *
 *  @return 切割好的头像
 */
+ (UIImage *)wy_captureCircleImageWithImage:(UIImage *)iconImage andBorderWith:(CGFloat)border andBorderColor:(UIColor *)color
{
    CGFloat imageW = iconImage.size.width + border * 2;
    CGFloat imageH = iconImage.size.height + border * 2;
    imageW = MIN(imageH, imageW);
    imageH = imageW;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    //新建一个图形上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [color set];
    //画大圆
    CGFloat bigRadius = imageW * 0.5;
    CGFloat centerX = imageW * 0.5;
    CGFloat centerY = imageH * 0.5;
    CGContextAddArc(ctx,centerX , centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    //画小圆
    CGFloat smallRadius = bigRadius - border;
    CGContextAddArc(ctx , centerX , centerY , smallRadius ,0, M_PI * 2, 0);
    //切割
    CGContextClip(ctx);
    //画图片
    [iconImage drawInRect:CGRectMake(border, border, iconImage.size.width, iconImage.size.height)];
    //从上下文中取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  生成毛玻璃效果的图片
 *
 *  @param image      要模糊化的图片
 *  @param blurAmount 模糊化指数
 *
 *  @return 返回模糊化之后的图片
 */
+ (UIImage *)wy_blurredImageWithImage:(UIImage *)image andBlurAmount:(CGFloat)blurAmount
{
    return [image wy_blurredImage:blurAmount];
}

/**
 *  截取相应的view生成一张图片
 *
 *  @param view 要截的view
 *
 *  @return 生成的图片
 */
+ (UIImage *)wy_viewShotWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  截屏
 *
 *  @return 返回截取的屏幕的图像
 */
+ (UIImage *)wy_screenShot
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  图片进行压缩
 *
 *  @param image   要压缩的图片
 *  @param percent 要压缩的比例
 *
 *  @return 压缩之后的图片
 */
+(UIImage *)wy_reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    
    return newImage;
}

/**
 *  对图片进行压缩
 *
 *  @param image   要压缩的图片
 *  @param newSize 压缩后的图片的像素尺寸
 *
 *  @return 压缩好的图片
 */
+ (UIImage*)wy_imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  对图片进行压缩
 *
 *  @param image   要压缩的图片
 *  @param kb 压缩后的图片的内存大小
 *
 *  @return 压缩好的图片
 */
+ (UIImage *)wy_imageWithImageSimple:(UIImage*)image scaledToKB:(NSInteger)kb {
    
    if (!image) {
        return image;
    }
    if (kb<1) {
        return image;
    }
    
    kb*=1024;
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    //WYLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

/**
 *  对图片进行压缩
 *
 *  @param image   要压缩的图片
 *  @param maxLength 压缩后的图片的内存大小
 *
 *  @return 压缩好的图片
 */
+ (UIImage *)wy_compressImage:(UIImage *)image toByte:(NSInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

/**
 *  返回毛玻璃效果的图片
 *
 *  @param blurAmount 模糊化指数
 */
- (UIImage*)wy_blurredImage:(CGFloat)blurAmount
{
    if (blurAmount < 0.0 || blurAmount > 2.0) {
        blurAmount = 0.5;
    }
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    int boxSize = blurAmount * 40;
    boxSize = boxSize - (boxSize % 2) + 1;
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (!error)
    {
        error = vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

/**
 *  图形模糊算法
 *
 *  @param blurLevel 模糊的级别
 *
 *  @return 模糊好的图片
 */
- (UIImage *)wy_blearImageWithBlurLevel:(CGFloat)blurLevel
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:inputImage forKey:@"inputImage"];
    //设值模糊的级别
    [blurFilter setValue:[NSNumber numberWithFloat:blurLevel] forKey:@"inputRadius"];
    CIImage *outputImage = [blurFilter valueForKey:@"outputImage"];
    CGRect rect = inputImage.extent;    // Create Rect
    //设值一下 减到图片的白边
    rect.origin.x += blurLevel;
    rect.origin.y += blurLevel;
    rect.size.height -= blurLevel * 2.0f;
    rect.size.width -= blurLevel * 2.0f;
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:rect];
    //获取新的图片
    UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:0.5 orientation:self.imageOrientation];
    //释放图片
    CGImageRelease(cgImage);
    
    return newImage;
}

//计算网络图片的大小
+ (CGSize)wy_downloadImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;
    
    //NSString *absoluteString = URL.absoluteString;
    
#ifdef dispatch_main_sync_safe
    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString])
    {
        UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
        if(!image)
        {
            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:URL.absoluteString];
            image = [UIImage imageWithData:data];
        }
        if(!image)
        {
            return image.size;
        }
    }
#endif
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self wy_downloadPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self wy_downloadGIFImageSizeWithRequest:request];
    }
    else{
        size = [self wy_downloadJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
#ifdef dispatch_main_sync_safe
            [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:data forKey:URL.absoluteString toDisk:YES];
#endif
            size = image.size;
        }
    }
    return size;
}

+ (CGSize)wy_downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 0)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+ (CGSize)wy_downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

+ (CGSize)wy_downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

+ (UIImage *)wy_videoPreViewImage:(NSURL *)path {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

+ (UIImage *)wy_createImage:(UIColor *)imageColor {
    return [self wy_createImage:imageColor imageSize:CGSizeMake(1, 1)];
}

+ (UIImage *)wy_createImage:(UIColor *)imageColor imageSize:(CGSize)imageSize {
    
    if (!imageColor || imageSize.width <= 0 || imageSize.height <= 0) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    [imageColor setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)wy_imageFromGradientColors:(NSArray *)colors gradientType:(WYGradientType)gradientType imageSize:(CGSize)imageSize {
    
    NSMutableArray *array = [NSMutableArray array];
    for(UIColor *color in colors) {
        [array addObject:(id)color.CGColor];
    }
    array = (NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)array, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case WYGradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imageSize.height);
            break;
        case WYGradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imageSize.width, 0.0);
            break;
        case WYGradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imageSize.width, imageSize.height);
            break;
        case WYGradientTypeUprightToLowleft:
            start = CGPointMake(imageSize.width, 0.0);
            end = CGPointMake(0.0, imageSize.height);
            break;
        default:
            break;
    }
    CGContextScaleCTM(context,1.0, -1.0);
    CGContextTranslateCTM(context,0, -imageSize.height);
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

/** 获取图片主体色*/
+ (UIColor *)wy_colorFromImage:(UIImage *)image {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    CGSize thumbSize = image.size;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char *data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    
    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            
            int offset = 4*(x*y);
            
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            
            NSArray *clr = @[@(red),@(green),@(blue),@(alpha)];
            [cls addObject:clr];
            
        }
    }
    CGContextRelease(context);
    
    
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    
    NSArray *MaxColor = nil;
    NSUInteger MaxCount = 0;
    
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        
        if ( tmpCount < MaxCount ) continue;
        
        MaxCount = tmpCount;
        MaxColor = curColor;
        
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

+ (BOOL)wy_imageEqualToImage:(UIImage *)image anotherImage:(UIImage *)anotherImage {
    
    NSData *orginalData = UIImagePNGRepresentation(image);
    NSData *anotherData = UIImagePNGRepresentation(anotherImage);
    if ([orginalData isEqual:anotherData]) {
        return YES;
    }
    return NO;
}

+ (UIImage *)wy_imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image {
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    
    
    CGContextSetAlpha(ctx, alpha);
    
    
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    UIGraphicsEndImageContext();
    
    
    
    return newImage;
    
}

+ (UIImage *)wy_spliceFirstImage:(UIImage *)firstImage secondImage:(UIImage *)secondImage {
    
    CGSize size1 = firstImage.size;
    
    UIGraphicsBeginImageContextWithOptions(firstImage.size, NO, [[UIScreen mainScreen] scale]);
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    
    //    [img2 drawInRect:CGRectMake((size1.width-size2.width)/2.0, (size1.height-size2.height)/2.0, size2.width, size2.height)];
    [secondImage drawInRect:CGRectMake(size1.width/4.0, size1.height/2.5, size1.width/2, size1.width/2)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

+ (UIImage *)wy_qrCodeImageForDataDic:(NSDictionary *)dataDic size:(CGSize)size waterImage:(UIImage *)waterImage {
    
    //创建名为"CIQRCodeGenerator"的CIFilter
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //将filter所有属性设置为默认值
    [filter setDefaults];
    
    //将所需尽心转为UTF8的数据，并设置给filter
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
    [filter setValue:data forKey:@"inputMessage"];
    
    //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    /*
     * L: 7%
     * M: 15%
     * Q: 25%
     * H: 30%
     */
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    //拿到二维码图片，此时的图片不是很清晰，需要二次加工
    CIImage *outPutImage = [filter outputImage];
    
    //如果有水印图片，那么添加水印后在调整清晰度，
    //如果没有直接，直接调节清晰度
    if (!waterImage) {
        return [[[self alloc] init] wy_getHDImageWithCIImage:outPutImage size:size];
    } else {
        
        return [[[self alloc] init] wy_getHDImageWithCIImage:outPutImage size:size waterImage:waterImage];;
    }
}

/**
 调整二维码清晰度
 
 @param image 模糊的二维码图片
 @param size 二维码的宽高
 @return 清晰的二维码图片
 */
- (UIImage *)wy_getHDImageWithCIImage:(CIImage *)image size:(CGSize)size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    return outputImage;
}

/**
 调整二维码清晰度，添加水印图片
 
 @param image 模糊的二维码图片
 @param size 二维码的宽高
 @param waterImage 水印图片
 @return 添加水印图片后，清晰的二维码图片
 */
- (UIImage *)wy_getHDImageWithCIImage:(CIImage *)image size:(CGSize)size waterImage:(UIImage *)waterImage {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //给二维码加 logo 图
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //logo图
    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
    [waterImage drawInRect:CGRectMake((size.width-waterImage.size.width)/2.0, (size.height-waterImage.size.height)/2.0, waterImage.size.width, waterImage.size.height)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

+ (UIImage *)wy_changeColorWithQRCodeImage:(UIImage *)image red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue {
    
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t * rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, (CGRect){(CGPointZero), (image.size)}, image.CGImage);
    //遍历像素
    int pixelNumber = imageHeight * imageWidth;
    [self wy_changeColorOnPixel:rgbImageBuf pixelNum:pixelNumber red:red green:green blue:blue];
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    UIImage * resultImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return resultImage;
}

/**
 遍历像素点，修改颜色
 
 @param rgbImageBuf rgbImageBuf
 @param pixelNum pixelNum
 @param red red
 @param green green
 @param blue blue
 */
+ (void)wy_changeColorOnPixel: (uint32_t *)rgbImageBuf pixelNum: (int)pixelNum red: (NSUInteger)red green: (NSUInteger)green blue: (NSUInteger)blue {
    
    uint32_t * pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        
        if ((*pCurPtr & 0xffffff00) < 0xd0d0d000) {
            
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[3] = red;
            ptr[2] = green;
            ptr[1] = blue;
        } else {
            //将白色变成透明色
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[0] = 0;
        }
    }
}

void ProviderReleaseData(void * info, const void * data, size_t size) {
    
    free((void *)data);
}

@end
