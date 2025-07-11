//
//  UITableView+WYExtension.m
//  WYBasisKit
//
//  Created by  guanren on 2018/11/27.
//  Copyright © 2018 guanren. All rights reserved.
//

#import "UITableView+WYExtension.h"

@implementation UITableView (WYExtension)

- (void)wy_rendererHeaderFooterViewBackgroundColor:(UIView *)view color:(UIColor *)color {
    
    UITableViewHeaderFooterView *headerFooterView = (UITableViewHeaderFooterView *)view;
    headerFooterView.tintColor = color;
}

- (void)wy_scrollWithoutPasting:(UIScrollView *)scrollView height:(CGFloat)height {
    
    if (scrollView == self)
    {
        if (scrollView.contentOffset.y <= height&&scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= height) {
            scrollView.contentInset = UIEdgeInsetsMake(-height, 0, 0, 0);
        }
    }
}

- (void)wy_forbiddenSelfSizing {
    
    //关闭高度估算
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    
    if ([self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

/** 滚动到最底部 */
- (void)wy_scrollToBottomAtAnimated:(BOOL)animated {
    
    NSInteger section = MAX(0, [self numberOfSections] - 1);
    NSInteger row = MAX(0, [self numberOfRowsInSection:section] - 1);
    if (section >= 0 && row >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

/** 滚动到指定 indexPath */
- (void)wy_scrollToIndexPath:(NSIndexPath *)indexPath
            atScrollPosition:(UITableViewScrollPosition)position
                    animated:(BOOL)animated {
    if (indexPath.section < [self numberOfSections] &&
        indexPath.row < [self numberOfRowsInSection:indexPath.section]) {
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:animated];
    }
}

@end
