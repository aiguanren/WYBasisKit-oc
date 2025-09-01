//
//  LEGOImageTouchView.m
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/22.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LEGOImageTouchView.h"

@implementation LEGOImageTouchView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL isTouchInRect = YES;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(touchInCropRect)]) {
        CGRect cropRect = [self.dataSource touchInCropRect];
        isTouchInRect = CGRectContainsPoint(cropRect, point);
    }
    if ([self pointInside:point withEvent:event] && isTouchInRect) {
        return self.receiver;
    }
    return nil;
}


@end
