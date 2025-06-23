//
//  UITableViewCell+WYExtension.h
//  WYBasisKit
//
//  Created by bangtuike on 2019/7/25.
//  Copyright © 2019 guanren. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (WYExtension)

/** 设置tableViewCell自定义右箭头图片 */
@property (nonatomic, strong) UIImage *wy_rightArrowImage;

/** 设置tableViewCell分割线顶头 */
- (void)wy_cellCutOffLineFromZeroPoint;

@end

NS_ASSUME_NONNULL_END
