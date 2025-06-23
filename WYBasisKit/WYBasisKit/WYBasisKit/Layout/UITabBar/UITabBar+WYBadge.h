//
//  UITabBar+WYBadge.h
//  WYBasisKit
//
//  Created by  guanren on 2018/12/5.
//  Copyright © 2018 guanren. All rights reserved.
//  感谢https://github.com/MRsummer/CustomBadge

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WYBadgeStyle) {
    
    /** 不显示徽章值 */
    WYBadgeStyleNone = 0,
    /** 显示红点徽章值 */
    WYBadgeStyleRedDot = 1,
    /** 显示数字徽章值 */
    WYBadgeStyleNumber = 2,
};

@interface UITabBar (WYBadge)

/** 设置徽章背景颜色(仅限初始化时设置)  默认红色 */
@property (nonatomic, strong) UIColor *wy_badgeBackgroundColor;

/** 设置徽章文本颜色(仅限初始化时设置)  默认白色 */
@property (nonatomic, strong) UIColor *wy_badgeTextColor;

/**
 * 设置badge显示风格
 */
- (void)wy_tabBarBadgeStyle:(WYBadgeStyle)badgeStyle badgeValue:(NSInteger)badgeValue tabBarIndex:(NSInteger)tabBarIndex;

@end

NS_ASSUME_NONNULL_END
