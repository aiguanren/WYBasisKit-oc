//
//  UICollectionView+WYExtension.h
//  WYBasisKit
//
//  Created by guanren on 2025/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (WYExtension)

/** 滚动到最底部 */
- (void)wy_scrollToBottomAtAnimated:(BOOL)animated;

/** 滚动到指定 indexPath */
- (void)wy_scrollToIndexPath:(NSIndexPath *)indexPath
              atScrollPosition:(UICollectionViewScrollPosition)position
                      animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
