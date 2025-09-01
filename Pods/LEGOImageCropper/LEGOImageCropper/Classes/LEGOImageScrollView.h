//
//  LEGOImageScrollView.h
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/22.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEGOImageScrollView : UIScrollView
@property (nonatomic, strong, nullable) UIImageView *zoomView;
@property (nonatomic, assign) BOOL fillScreen;
@property (nonatomic, copy) void (^beginZooming)(void);
@property (nonatomic, copy) void (^didEndZooming)(CGFloat scale);
@property (nonatomic, copy) void (^beginDragging)(void);
@property (nonatomic, copy) void (^didEndDragging)(BOOL decelerate);

- (void)showImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
