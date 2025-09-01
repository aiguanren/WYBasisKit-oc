

//
//  LEGOImageScrollView.m
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/22.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LEGOImageScrollView.h"

@interface LEGOImageScrollView () <UIScrollViewDelegate> {
    CGSize _imageSize;
    CGPoint _pointToCenterAfterResize;
    CGFloat _scaleToRestoreAfterResize;
}

@end

@implementation LEGOImageScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _fillScreen = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.scrollsToTop = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}

- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];
    [self centerZoomView];
}

- (void)setFillScreen:(BOOL)fillScreen {
    if (_fillScreen != fillScreen) {
        _fillScreen = fillScreen;
        if (_zoomView) {
            [self setMaxMinZoomScalesForCurrentBounds];
            if (self.zoomScale < self.minimumZoomScale) {
                self.zoomScale = self.minimumZoomScale;
            }
        }
    }
}

- (void)setFrame:(CGRect)frame {
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    if (sizeChanging) {
        [self prepareToResize];
    }
    [super setFrame:frame];
    if (sizeChanging) {
        [self recoverFromResizing];
    }
    [self centerZoomView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    !self.beginDragging ? :self.beginDragging();
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    !self.didEndDragging ? :self.didEndDragging(decelerate);
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2) {
    !self.beginZooming ? :self.beginZooming();
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    !self.didEndZooming ? :self.didEndZooming(scale);
}

- (void)scrollViewDidZoom:(__unused UIScrollView *)scrollView {
    [self centerZoomView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _zoomView;
}


- (void)centerZoomView {
    if (self.fillScreen) {
        CGFloat top = 0;
        CGFloat left = 0;
        if (self.contentSize.height < CGRectGetHeight(self.bounds)) {
            top = (CGRectGetHeight(self.bounds) - self.contentSize.height) * 0.5f;
        }
        if (self.contentSize.width < CGRectGetWidth(self.bounds)) {
            left = (CGRectGetWidth(self.bounds) - self.contentSize.width) * 0.5f;
        }
        self.contentInset = UIEdgeInsetsMake(top, left, top, left);
    } else {
        CGRect frameToCenter = self.zoomView.frame;
        if (CGRectGetWidth(frameToCenter) < CGRectGetWidth(self.bounds)) {
            frameToCenter.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(frameToCenter)) * 0.5f;
        } else {
            frameToCenter.origin.x = 0;
        }
        if (CGRectGetHeight(frameToCenter) < CGRectGetHeight(self.bounds)) {
            frameToCenter.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(frameToCenter)) * 0.5f;
        } else {
            frameToCenter.origin.y = 0;
        }
        self.zoomView.frame = frameToCenter;
    }
}

- (void)showImage:(UIImage *)image {
    [_zoomView removeFromSuperview];
    _zoomView = nil;
    self.zoomScale = 1.0;
    _zoomView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:_zoomView];
    [self configureForImageSize:image.size];
}

- (void)configureForImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    self.contentSize = imageSize;
    [self setMaxMinZoomScalesForCurrentBounds];
    [self setInitialZoomScale];
    [self setInitialContentOffset];
    self.contentInset = UIEdgeInsetsZero;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    CGSize boundsSize = self.bounds.size;
    CGFloat xScale = boundsSize.width  / _imageSize.width;
    CGFloat yScale = boundsSize.height / _imageSize.height;
    CGFloat minScale;
    if (!self.fillScreen) {
        minScale = MIN(xScale, yScale);
    } else {
        minScale = MAX(xScale, yScale);
    }
    CGFloat maxScale = MAX(xScale, yScale);
    
    CGFloat xImageScale = maxScale*_imageSize.width / boundsSize.width;
    CGFloat yImageScale = maxScale*_imageSize.height / boundsSize.height;
    
    CGFloat maxImageScale = MAX(xImageScale, yImageScale);
    maxImageScale = MAX(minScale, maxImageScale);
    maxScale = MAX(maxScale, maxImageScale);
    
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    self.minimumZoomScale = minScale;
    maxScale = MIN(boundsSize.width / 100,boundsSize.height / 100);
    if (maxScale > minScale) {
        self.maximumZoomScale = maxScale;
    }
    else {
        self.maximumZoomScale = MAXFLOAT;
    }
}

- (void)setInitialZoomScale {
    CGSize boundsSize = self.bounds.size;
    CGFloat xScale = boundsSize.width  / _imageSize.width;
    CGFloat yScale = boundsSize.height / _imageSize.height;
    CGFloat scale = MAX(xScale, yScale);
    self.zoomScale = scale;
}

- (void)setInitialContentOffset {
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.zoomView.frame;
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
    [self setContentOffset:contentOffset];
}

- (void)prepareToResize {
    if (_zoomView == nil) {
        return;
    }
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:self.zoomView];
    _scaleToRestoreAfterResize = self.zoomScale;
    if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing {
    if (_zoomView == nil) {
        return;
    }
    [self setMaxMinZoomScalesForCurrentBounds];
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:self.zoomView];
    
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    
    self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset {
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset {
    return CGPointZero;
}

@end
