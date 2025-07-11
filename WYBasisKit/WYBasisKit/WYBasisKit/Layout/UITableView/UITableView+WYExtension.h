//
//  UITableView+WYExtension.h
//  WYBasisKit
//
//  Created by  guanren on 2018/11/27.
//  Copyright © 2018 guanren. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (WYExtension)

/** 设置tableView头部或尾部背景色 */
- (void)wy_rendererHeaderFooterViewBackgroundColor:(UIView *)view color:(UIColor *)color;

/** 设置tableView滚动时无粘性 */
- (void)wy_scrollWithoutPasting:(UIScrollView *)scrollView height:(CGFloat)height;

/** 禁用 Self-Sizing */
- (void)wy_forbiddenSelfSizing;

/** 滚动到最底部 */
- (void)wy_scrollToBottomAtAnimated:(BOOL)animated;

/** 滚动到指定 indexPath */
- (void)wy_scrollToIndexPath:(NSIndexPath *)indexPath
              atScrollPosition:(UITableViewScrollPosition)position
                      animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
