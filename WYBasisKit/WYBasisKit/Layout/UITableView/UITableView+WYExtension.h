//
//  UITableView+WYExtension.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UITableView (WYExtension)

/** 设置tableView头部或尾部背景色 */
- (void)wy_rendererHeaderFooterViewBackgroundColor:(UIView *)view color:(UIColor *)color;

/** 设置tableView滚动时无粘性 */
- (void)wy_scrollWithoutPasting:(UIScrollView *)scrollView height:(CGFloat)height;

/** 禁用 Self-Sizing */
- (void)wy_forbiddenSelfSizing;

@end

NS_ASSUME_NONNULL_END
