//
//  UICollectionView+WYExtension.m
//  WYBasisKit
//
//  Created by guanren on 2025/7/11.
//

#import "UICollectionView+WYExtension.h"

@implementation UICollectionView (WYExtension)

/** 滚动到最底部 */
- (void)wy_scrollToBottomAtAnimated:(BOOL)animated {
    
    NSInteger section = MAX(0, [self numberOfSections] - 1);
    NSInteger item = MAX(0, [self numberOfItemsInSection:section] - 1);
    if (section >= 0 && item >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:animated];
    }
}

/** 滚动到指定 indexPath */
- (void)wy_scrollToIndexPath:(NSIndexPath *)indexPath
            atScrollPosition:(UICollectionViewScrollPosition)position
                    animated:(BOOL)animated {
    if (indexPath.section < [self numberOfSections] &&
        indexPath.item < [self numberOfItemsInSection:indexPath.section]) {
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:animated];
    }
}

@end
