//
//  LEGOImageTouchView.h
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/22.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LEGOImageTouchDataSource <NSObject>
@optional
- (CGRect)touchInCropRect;

@end

@interface LEGOImageTouchView : UIView
@property (nonatomic, weak) UIView *receiver;
@property (nonatomic, weak) id <LEGOImageTouchDataSource> dataSource;
@end

