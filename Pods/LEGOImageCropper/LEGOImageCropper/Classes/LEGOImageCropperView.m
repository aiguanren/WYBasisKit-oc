//
//  LEGOImageCropperView.m
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/19.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LEGOImageCropperView.h"
#import "LEGOImageTouchView.h"
#import "UIImage+LEGOFixOrientation.h"

#define AnimateDuration (NSTimeInterval)0.15f
#define M_PI90Degree (M_PI / 2.0000000001)

@interface LEGOImageCropperView ()<UIGestureRecognizerDelegate,LEGOImageTouchDataSource>
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) LEGOImageTouchView *overlayView;

@property (nonatomic, assign) CGRect maskRect;
@property (nonatomic, assign, readonly) CGRect imageRect;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) NSMutableArray <NSArray <CAShapeLayer *> *> *lines;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationGestureRecognizer;

@property (assign, nonatomic) CGFloat diffAngle;
@end

@implementation LEGOImageCropperView

- (LEGOImageScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[LEGOImageScrollView alloc] init];
        _imageScrollView.alwaysBounceHorizontal = YES;
        _imageScrollView.alwaysBounceVertical = YES;
        _imageScrollView.clipsToBounds = NO;
        _imageScrollView.fillScreen = YES;
    }
    return _imageScrollView;
}

- (LEGOImageTouchView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[LEGOImageTouchView alloc] init];
        _overlayView.receiver = self.imageScrollView;
        _overlayView.dataSource = self;
    }
    return _overlayView;
}

- (CGRect)touchInCropRect {
    return self.maskRect;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
    }
    return _rightView;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.userInteractionEnabled = NO;
        _shadowView.layer.shadowOffset = CGSizeMake(0,0);
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowRadius = 2;
        _shadowView.layer.borderWidth = 3;
    }
    return _shadowView;
}

- (CAShapeLayer *)createShapeLayer:(CGFloat)lineWidth {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    [self.layer addSublayer:shapeLayer];
    return shapeLayer;
}

- (UIBezierPath *)pathStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    return path;
}

- (UITapGestureRecognizer *)doubleTapGestureRecognizer {
    if (!_doubleTapGestureRecognizer) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTapGestureRecognizer.delaysTouchesEnded = NO;
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        _doubleTapGestureRecognizer.delegate = self;
        _doubleTapGestureRecognizer.enabled = self.isDoubleResetEnabled;
    }
    return _doubleTapGestureRecognizer;
}

- (UIRotationGestureRecognizer *)rotationGestureRecognizer {
    if (!_rotationGestureRecognizer) {
        _rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
        _rotationGestureRecognizer.delaysTouchesEnded = NO;
        _rotationGestureRecognizer.delegate = self;
        _rotationGestureRecognizer.enabled = self.isRotationEnabled;
    }
    return _rotationGestureRecognizer;
}

- (instancetype)initWithImage:(UIImage *)originalImage frame:(CGRect)frame {
    self = [self initWithFrame:frame];
    if (self) {
        _originalImage = originalImage;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _rotationEnabled = YES;
        _doubleResetEnabled = YES;
        _clockwiseRotation = NO;
        _minZoomScale = 1.0f;
        _maxZoomScale = MAXFLOAT;
        _minificationFilter = kCAFilterLinear;
        _magnificationFilter = kCAFilterLinear;
        [self setImageCropperView];
    }
    return self;
}

- (void)setImageCropperView {
    self.clipsToBounds = YES;
    [self addSubview:self.imageScrollView];
    
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    
    [self addSubview:self.overlayView];
    
    [self addSubview:self.shadowView];
    self.lines = [[NSMutableArray alloc] init];
    NSMutableArray *horLines = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        CAShapeLayer *line = [self createShapeLayer:1];
        [horLines addObject:line];
    }
    NSMutableArray *verLines = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        CAShapeLayer *line = [self createShapeLayer:1];
        [verLines addObject:line];
    }
    [self.lines addObjectsFromArray:@[horLines,verLines]];
    
    [self addGestureRecognizer:self.doubleTapGestureRecognizer];
    [self addGestureRecognizer:self.rotationGestureRecognizer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.imageScrollView.zoomView && self.originalImage) {
        [self.imageScrollView showImage:self.originalImage];
        [self reset:NO];
         self.imageScrollView.zoomView.layer.minificationFilter = self.minificationFilter;
         self.imageScrollView.zoomView.layer.magnificationFilter = self.magnificationFilter;
    }
}

- (void)layoutImageScrollView:(BOOL)animaited {
    CGRect frame = [self imageCropViewRangeRect];
    CGAffineTransform transform = self.imageScrollView.transform;
    CGPoint center = self.imageScrollView.center;
    self.imageScrollView.transform = CGAffineTransformIdentity;
    if (animaited) {
        [UIView animateWithDuration:[self trimmingDuration] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.imageScrollView.frame = CGRectMake(self.imageScrollView.frame.origin.x, self.imageScrollView.frame.origin.y, frame.size.width + 1, frame.size.height + 1);
            self.imageScrollView.center = center;
        } completion:nil];
    }
    else {
        self.imageScrollView.frame = frame;
    }
    self.imageScrollView.transform = transform;
}

- (void)layoutOverlayView {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 2, CGRectGetHeight(self.bounds) * 2);
    self.overlayView.frame = frame;
}

- (void)layoutMaskView {
    self.topView.frame = CGRectMake(0, 0, self.bounds.size.width, CGRectGetMinY(_maskRect));
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(_maskRect), self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(_maskRect));
    self.leftView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), CGRectGetMinX(_maskRect), self.bounds.size.height - CGRectGetHeight(self.topView.frame) - CGRectGetHeight(self.bottomView.frame));
    self.rightView.frame = CGRectMake(CGRectGetMaxX(_maskRect), CGRectGetMaxY(self.topView.frame), self.bounds.size.width - CGRectGetMaxX(_maskRect), self.bounds.size.height - CGRectGetHeight(self.topView.frame) - CGRectGetHeight(self.bottomView.frame));
}

- (void)layoutShapeLayerLattice {
    CGPoint point = self.maskRect.origin;
    CGSize size = self.maskRect.size;
    self.lines.firstObject[0].path = [self pathStartPoint:CGPointMake(point.x, point.y + size.height / 3.0 * 1) endPoint:CGPointMake(size.width, point.y + size.height / 3.0 * 1)].CGPath;
    self.lines.firstObject[1].path = [self pathStartPoint:CGPointMake(point.x, point.y + size.height / 3.0 * 2) endPoint:CGPointMake(size.width, point.y + size.height / 3.0 * 2)].CGPath;
    
    self.lines.lastObject[0].path = [self pathStartPoint:CGPointMake(point.x + size.width / 3.0 * 1, point.y) endPoint:CGPointMake(point.x + size.width / 3.0 * 1, point.y + size.height)].CGPath;
    self.lines.lastObject[1].path = [self pathStartPoint:CGPointMake(point.x + size.width / 3.0 * 2, point.y) endPoint:CGPointMake(point.x + size.width / 3.0 * 2, point.y + size.height)].CGPath;
    
    self.shadowView.frame = self.maskRect;
}

- (void)setLineHidden:(BOOL)hidden {
    for (NSArray *array in self.lines) {
        for (CAShapeLayer *line in array) {
            line.hidden = hidden;
        }
    }
}

- (void)setBeginDragging:(void (^)(void))beginDragging {
    _beginDragging = beginDragging;
    self.imageScrollView.beginDragging = beginDragging;
}

- (void)setDidEndDragging:(void (^)(BOOL decelerate))didEndDragging {
    _didEndDragging = didEndDragging;
    self.imageScrollView.didEndDragging = didEndDragging;
}

- (void)setBeginZooming:(void (^)(void))beginZooming {
    _beginZooming = beginZooming;
    self.imageScrollView.beginZooming = beginZooming;
}

- (void)setDidEndZooming:(void (^)(CGFloat scale))didEndZooming {
    _didEndZooming = didEndZooming;
    self.imageScrollView.didEndZooming = didEndZooming;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer {
    [self reset:YES];
}

- (void)setDoubleResetEnabled:(BOOL)doubleResetEnabled {
    _doubleResetEnabled = doubleResetEnabled;
    self.doubleTapGestureRecognizer.enabled = doubleResetEnabled;
}

- (void)reset:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:AnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self resetRotationAngle:0.0];
            [self layoutImageScrollView:NO];
            [self resetZoomScale];
            [self resetContentOffset];
            [self layoutShapeLayerLattice];
        } completion:nil];
    }
    else {
        [self resetRotationAngle:0.0];
        [self layoutImageScrollView:NO];
        [self resetZoomScale];
        [self resetContentOffset];
        [self layoutShapeLayerLattice];
    }
}

- (void)resetRotationAngle:(CGFloat)rotationAngle {
    self.imageScrollView.transform = CGAffineTransformIdentity;
}

- (void)resetContentOffset {
    CGSize boundsSize = self.imageScrollView.bounds.size;
    CGRect frameToCenter = self.imageScrollView.zoomView.frame;
    
    CGPoint contentOffset;
    if (CGRectGetWidth(frameToCenter) > boundsSize.width) {
        contentOffset.x = (CGRectGetWidth(frameToCenter) - boundsSize.width) * 0.5f;
    } else {
        contentOffset.x = 0;
    }
    if (CGRectGetHeight(frameToCenter) > boundsSize.height) {
        contentOffset.y = (CGRectGetHeight(frameToCenter) - boundsSize.height) * 0.5f;
    } else {
        contentOffset.y = 0;
    }
    self.imageScrollView.contentOffset = contentOffset;
}

- (void)resetZoomScale {
    CGFloat zoomScale = 1.0f;
    if (CGRectGetWidth(self.bounds) > CGRectGetHeight(self.bounds)) {
        zoomScale = CGRectGetHeight(self.bounds) / self.originalImage.size.height;
    } else {
        zoomScale = CGRectGetWidth(self.bounds) / self.originalImage.size.width;
    }
    self.imageScrollView.zoomScale = zoomScale;
}

- (void)setResizeWHRatio:(CGSize)resizeWHRatio {
    [self setResizeWHRatio:resizeWHRatio animated:NO];
}

- (void)setResizeWHRatio:(CGSize)resizeWHRatio animated:(BOOL)animated {
    _resizeWHRatio = resizeWHRatio;
    self.maskRect = [self imageCropViewMaskRect];
    if (animated) {
        [self setLineHidden:YES];
        [UIView animateWithDuration:AnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self layoutImageScrollView:NO];
            [self layoutOverlayView];
            [self layoutMaskView];
            [self layoutShapeLayerLattice];
        } completion:^(BOOL finished) {
            [self setLineHidden:NO];
        }];
    }
    else {
        [self layoutImageScrollView:NO];
        [self layoutOverlayView];
        [self layoutMaskView];
        [self layoutShapeLayerLattice];
    }
}

- (CGFloat)rotationAngle {
    CGAffineTransform transform = self.imageScrollView.transform;
    CGFloat rotationAngle = atan2(transform.b, transform.a);
    return rotationAngle;
}

- (void)setRotationEnabled:(BOOL)rotationEnabled {
    _rotationEnabled = rotationEnabled;
    self.rotationGestureRecognizer.enabled = rotationEnabled;
}

- (void)handleRotation:(UIRotationGestureRecognizer *)gestureRecognizer {
    [self setRotationAngle:gestureRecognizer.rotation animated:NO];
    gestureRecognizer.rotation = 0;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self setLineHidden:YES];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setLineHidden:NO];
        self.maskRect = [self imageCropViewMaskRect];
        [self layoutImageScrollView:YES];
        [self layoutOverlayView];
        [self layoutMaskView];
        [self layoutShapeLayerLattice];
    }
}

- (void)rotation:(BOOL)animated {
    [self setLineHidden:YES];
    if (self.clockwiseRotation) {
        [self setRotationAngle:M_PI90Degree animated:animated];
    }
    else {
        [self setRotationAngle:-M_PI90Degree animated:animated];
    }
    self.maskRect = [self imageCropViewMaskRect];
    [self layoutImageScrollView:YES];
    [self layoutOverlayView];
    [self layoutMaskView];
    [self layoutShapeLayerLattice];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AnimateDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setLineHidden:NO];
    });
}

- (void)setRotationAngle:(CGFloat)rotationAngle {
    [self setRotationAngle:rotationAngle animated:NO];
    self.maskRect = [self imageCropViewMaskRect];
    [self layoutImageScrollView:YES];
    [self layoutOverlayView];
    [self layoutMaskView];
    [self layoutShapeLayerLattice];
}

- (void)setRotationAngle:(CGFloat)rotationAngle animated:(BOOL)animated {
    self.diffAngle = rotationAngle;
    if (animated) {
        [UIView animateWithDuration:AnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGAffineTransform transform = CGAffineTransformRotate(self.imageScrollView.transform, rotationAngle);
            self.imageScrollView.transform = transform;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        [UIView animateWithDuration:[self trimmingDuration] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGAffineTransform transform = CGAffineTransformRotate(self.imageScrollView.transform, rotationAngle);
            self.imageScrollView.transform = transform;
        } completion:nil];
    }
}

- (CGFloat)trimmingDuration {
    NSTimeInterval duration = 0.1;
    if (0 < fabs(self.diffAngle) && fabs(self.diffAngle) < 0.002) {
        duration = 0.15;
    }
    return duration;
}

#pragma mark - UIColor
- (void)setMaskColor:(UIColor *)maskColor {
    _maskColor = maskColor;
    self.topView.backgroundColor = maskColor;
    self.bottomView.backgroundColor = maskColor;
    self.leftView.backgroundColor = maskColor;
    self.rightView.backgroundColor = maskColor;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    self.shadowView.layer.shadowColor = shadowColor.CGColor;
    self.shadowView.layer.borderColor = shadowColor.CGColor;
}

- (void)setShapeLayerColor:(UIColor *)shapeLayerColor {
    _shapeLayerColor = shapeLayerColor;
    for (NSArray *array in self.lines) {
        for (CAShapeLayer *line in array) {
            line.strokeColor = shapeLayerColor.CGColor;
        }
    }
}

- (CGRect)imageCropViewMaskRect {
    CGSize resizeWHRatio = self.resizeWHRatio;
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    CGFloat maskWidth = viewWidth;
    CGFloat maskHeight;
    maskHeight = maskWidth * resizeWHRatio.height / resizeWHRatio.width;
    CGSize maskSize = CGSizeMake(maskWidth, maskHeight);
    CGRect maskRect = CGRectMake((viewWidth - maskSize.width) / 2.0,
                                 (viewHeight - maskSize.height) / 2.0,
                                 maskSize.width,
                                 maskSize.height);
    return maskRect;
}

- (CGRect)imageCropViewRangeRect {
    CGRect maskRect = self.maskRect;
    CGFloat rotationAngle = self.rotationAngle;
    
    CGRect movementRect = CGRectZero;
    movementRect.size.width = CGRectGetWidth(maskRect) * fabs(cos(rotationAngle)) + CGRectGetHeight(maskRect) * fabs(sin(rotationAngle));
    movementRect.size.height = CGRectGetHeight(maskRect) * fabs(cos(rotationAngle)) + CGRectGetWidth(maskRect) * fabs(sin(rotationAngle));
    
    movementRect.origin.x = CGRectGetMinX(maskRect) + (CGRectGetWidth(maskRect) - CGRectGetWidth(movementRect)) / 2.0;
    movementRect.origin.y = CGRectGetMinY(maskRect) + (CGRectGetHeight(maskRect) - CGRectGetHeight(movementRect)) / 2.0;
    movementRect.origin.x = CGRectGetMinX(movementRect);
    movementRect.origin.y = CGRectGetMinY(movementRect);
    movementRect = CGRectIntegral(movementRect);
    
    return movementRect;
}

#pragma mark -crop
- (void)cropImageWithComplete:(void(^)(UIImage *resizeImage))complete {
    UIImage *originalImage = self.originalImage;
    CGRect cropRect = self.cropRect;
    CGRect imageRect = self.imageRect;
    CGFloat rotationAngle = self.rotationAngle;
    CGFloat zoomScale = self.imageScrollView.zoomScale;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *croppedImage = [self croppedImage:originalImage cropRect:cropRect imageRect:imageRect rotationAngle:rotationAngle zoomScale:zoomScale];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self imageCropViewController:self didCropImage:croppedImage usingCropRect:cropRect rotationAngle:rotationAngle complete:complete];
        });
    });
}

- (UIImage *)imageWithImage:(UIImage *)image inRect:(CGRect)rect scale:(CGFloat)scale imageOrientation:(UIImageOrientation)imageOrientation {
    if (!image.images) {
        CGImageRef cgImage = CGImageCreateWithImageInRect(image.CGImage, rect);
        UIImage *image = [UIImage imageWithCGImage:cgImage scale:scale orientation:imageOrientation];
        CGImageRelease(cgImage);
        return image;
    } else {
        UIImage *animatedImage = image;
        NSMutableArray *images = [NSMutableArray array];
        for (UIImage *animatedImageImage in animatedImage.images) {
            UIImage *image = [self imageWithImage:animatedImageImage inRect:rect scale:scale imageOrientation:imageOrientation];
            [images addObject:image];
        }
        return [UIImage animatedImageWithImages:images duration:image.duration];
    }
}

- (UIImage *)croppedImage:(UIImage *)originalImage cropRect:(CGRect)cropRect imageRect:(CGRect)imageRect rotationAngle:(CGFloat)rotationAngle zoomScale:(CGFloat)zoomScale
{
    UIImage *image = [self imageWithImage:originalImage inRect:imageRect scale:originalImage.scale imageOrientation:originalImage.imageOrientation];
    image = [image lego_fixOrientation];
    CGSize contextSize = cropRect.size;
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, originalImage.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    if (rotationAngle != 0) {
        image = [image lego_rotateByAngle:rotationAngle];
    }
    CGPoint point = CGPointMake(floor((contextSize.width - image.size.width) * 0.5f),
                                floor((contextSize.height - image.size.height) * 0.5f));
    [image drawAtPoint:point];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    croppedImage = [UIImage imageWithCGImage:croppedImage.CGImage scale:originalImage.scale orientation:image.imageOrientation];
    return croppedImage;
}


- (CGRect)imageRect {
    float zoomScale = 1.0 / self.imageScrollView.zoomScale;
    CGRect imageRect = CGRectZero;
    imageRect.origin.x = self.imageScrollView.contentOffset.x * zoomScale;
    imageRect.origin.y = self.imageScrollView.contentOffset.y * zoomScale;
    imageRect.size.width = CGRectGetWidth(self.imageScrollView.bounds) * zoomScale;
    imageRect.size.height = CGRectGetHeight(self.imageScrollView.bounds) * zoomScale;
    
    CGSize imageSize = self.originalImage.size;
    CGFloat x = CGRectGetMinX(imageRect);
    CGFloat y = CGRectGetMinY(imageRect);
    CGFloat width = CGRectGetWidth(imageRect);
    CGFloat height = CGRectGetHeight(imageRect);
    
    UIImageOrientation imageOrientation = self.originalImage.imageOrientation;
    if (imageOrientation == UIImageOrientationRight || imageOrientation == UIImageOrientationRightMirrored) {
        imageRect.origin.x = y;
        imageRect.origin.y = floor(imageSize.width - CGRectGetWidth(imageRect) - x);
        imageRect.size.width = height;
        imageRect.size.height = width;
    } else if (imageOrientation == UIImageOrientationLeft || imageOrientation == UIImageOrientationLeftMirrored) {
        imageRect.origin.x = floor(imageSize.height - CGRectGetHeight(imageRect) - y);
        imageRect.origin.y = x;
        imageRect.size.width = height;
        imageRect.size.height = width;
    } else if (imageOrientation == UIImageOrientationDown || imageOrientation == UIImageOrientationDownMirrored) {
        imageRect.origin.x = floor(imageSize.width - CGRectGetWidth(imageRect) - x);
        imageRect.origin.y = floor(imageSize.height - CGRectGetHeight(imageRect) - y);
    }
    
    CGFloat imageScale = self.originalImage.scale;
    imageRect = CGRectApplyAffineTransform(imageRect, CGAffineTransformMakeScale(imageScale, imageScale));
    return imageRect;
}

- (CGRect)cropRect
{
    CGRect maskRect = self.maskRect;
    CGFloat rotationAngle = self.rotationAngle;
    CGRect rotatedImageScrollViewFrame = self.imageScrollView.frame;
    float zoomScale = 1.0 / self.imageScrollView.zoomScale;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.imageScrollView.frame;
    scrollView.contentSize = self.imageScrollView.contentSize;
    scrollView.contentOffset = self.imageScrollView.contentOffset;
    scrollView.transform = CGAffineTransformIdentity;
    
    CGRect imageScrollViewFrame = scrollView.frame;
    scrollView.frame = self.maskRect;
    
    CGRect imageFrame = CGRectZero;
    imageFrame.origin.x = CGRectGetMinX(maskRect) - scrollView.contentOffset.x;
    imageFrame.origin.y = CGRectGetMinY(maskRect) - scrollView.contentOffset.y;
    imageFrame.size = scrollView.contentSize;
    
    CGFloat tx = CGRectGetMinX(imageFrame) + scrollView.contentOffset.x + CGRectGetWidth(maskRect) * 0.5f;
    CGFloat ty = CGRectGetMinY(imageFrame) + scrollView.contentOffset.y + CGRectGetHeight(maskRect) * 0.5f;
    
    CGFloat sx = CGRectGetWidth(rotatedImageScrollViewFrame) / CGRectGetWidth(imageScrollViewFrame);
    CGFloat sy = CGRectGetHeight(rotatedImageScrollViewFrame) / CGRectGetHeight(imageScrollViewFrame);
    
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(-tx, -ty);
    CGAffineTransform t2 = CGAffineTransformMakeRotation(rotationAngle);
    CGAffineTransform t3 = CGAffineTransformMakeScale(sx, sy);
    CGAffineTransform t4 = CGAffineTransformMakeTranslation(tx, ty);
    CGAffineTransform t1t2 = CGAffineTransformConcat(t1, t2);
    CGAffineTransform t1t2t3 = CGAffineTransformConcat(t1t2, t3);
    CGAffineTransform t1t2t3t4 = CGAffineTransformConcat(t1t2t3, t4);
    
    imageFrame = CGRectApplyAffineTransform(imageFrame, t1t2t3t4);
    
    CGRect cropRect = CGRectMake(0.0, 0.0, CGRectGetWidth(maskRect), CGRectGetHeight(maskRect));
    
    cropRect.origin.x = -CGRectGetMinX(imageFrame) + CGRectGetMinX(maskRect);
    cropRect.origin.y = -CGRectGetMinY(imageFrame) + CGRectGetMinY(maskRect);
    
    cropRect = CGRectApplyAffineTransform(cropRect, CGAffineTransformMakeScale(zoomScale, zoomScale));
        
    CGFloat imageScale = self.originalImage.scale;
    cropRect = CGRectApplyAffineTransform(cropRect, CGAffineTransformMakeScale(imageScale, imageScale));
    
    //    self.imageScrollView.transform = imageScrollViewTransform;
    //    self.imageScrollView.frame = imageScrollViewFrame;
    
    return cropRect;
}

- (void)imageCropViewController:(LEGOImageCropperView *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle complete:(void(^)(UIImage *resizeImage))complete {
    UIImage *image = croppedImage;
    CGSize size = CGSizeZero;
    if (MAX(image.size.width, image.size.height) > self.maxZoomScale) {
        if (image.size.width > self.maxZoomScale) {
            size = CGSizeMake(self.maxZoomScale, self.maxZoomScale / image.size.width * image.size.height);
        }
        if (image.size.height > self.maxZoomScale) {
            size = CGSizeMake(self.maxZoomScale / image.size.height * image.size.width, self.maxZoomScale);
        }
        image = [image lego_cropBySize:size];
    }
    else if (MIN(image.size.width, image.size.height) < self.minZoomScale) {
        if (image.size.width < self.minZoomScale) {
            size = CGSizeMake(self.minZoomScale, self.minZoomScale / image.size.width * image.size.height);
        }
        if (image.size.height < self.minZoomScale) {
            size = CGSizeMake(self.minZoomScale / image.size.height * image.size.width ,self.minZoomScale);
        }
        image = [image lego_cropBySize:size];
    }
    !complete ? :complete(image);
}

#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
