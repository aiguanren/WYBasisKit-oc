//
//  UITabBar+WYBadge.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/12/5.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import "UITabBar+WYBadge.h"
#import <objc/runtime.h>

static NSString *const wy_badgeViewInitedKey = @"wy_badgeViewInitedKey";
static NSString *const wy_badgeRedDotViewesKey = @"wy_badgeRedDotViewesKey";
static NSString *const wy_badgeNumberViewsKey = @"wy_badgeNumberViewsKey";

@implementation UITabBar (WYBadge)

- (void)setWy_badgeBackgroundColor:(UIColor *)wy_badgeBackgroundColor {
    
    objc_setAssociatedObject(self, @selector(wy_badgeBackgroundColor), wy_badgeBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)wy_badgeBackgroundColor {
    
    UIColor *obj = objc_getAssociatedObject(self, _cmd);
    if(obj == nil) {obj = [UIColor redColor];}
    return obj;
}

- (void)setWy_badgeTextColor:(UIColor *)wy_badgeTextColor {
    
    objc_setAssociatedObject(self, @selector(wy_badgeTextColor), wy_badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)wy_badgeTextColor {
    
    UIColor *obj = objc_getAssociatedObject(self, _cmd);
    if(obj == nil) {obj = [UIColor whiteColor];}
    return obj;
}

- (void)wy_tabBarBadgeStyle:(WYBadgeStyle)badgeStyle badgeValue:(NSInteger)badgeValue tabBarIndex:(NSInteger)tabBarIndex {
    
    if(![[self valueForKey:wy_badgeViewInitedKey] boolValue]) {
        
        [self setValue:@(YES) forKey:wy_badgeViewInitedKey];
        [self wy_addBadgeViews];
    }
    NSMutableArray *redDotViewes = [self valueForKey:wy_badgeRedDotViewesKey];
    NSMutableArray *badgeNumberViews = [self valueForKey:wy_badgeNumberViewsKey];
    
    [redDotViewes[tabBarIndex] setHidden:YES];
    [badgeNumberViews[tabBarIndex] setHidden:YES];
    
    if(badgeValue == 0) {badgeStyle = WYBadgeStyleNone;}
    
    if(badgeStyle == WYBadgeStyleRedDot) {
        
        [redDotViewes[tabBarIndex] setHidden:NO];
        
    }else if(badgeStyle == WYBadgeStyleNumber) {
        
        UILabel *label = badgeNumberViews[tabBarIndex];
        [label setHidden:NO];
        [self wy_adjustBadgeNumberViewWithLabel:label number:badgeValue];
        
    }else if(badgeStyle == WYBadgeStyleNone){}
}

- (void)wy_addBadgeViews {
    
    NSInteger itemsCount = self.items.count;
    CGFloat itemWidth = self.bounds.size.width / self.items.count;
    CGFloat tabBarIconWidth = 0.0f;
    CGFloat tabBarIconTop = 10.0f;
    
    NSMutableArray *redDotViewes = [NSMutableArray arrayWithCapacity:itemsCount];
    for(int i = 0; i<itemsCount; i++) {
        
        tabBarIconWidth = self.items[i].image.size.width;
        
        UIView *redDot = [[UIView alloc]init];
        redDot.bounds = CGRectMake(0, 0, 8, 8);
        redDot.center = CGPointMake(itemWidth*(i+0.5)+tabBarIconWidth/2, tabBarIconTop);
        redDot.layer.cornerRadius = redDot.bounds.size.width/2;
        redDot.clipsToBounds = YES;
        redDot.backgroundColor = self.wy_badgeBackgroundColor;
        redDot.hidden = YES;
        [self addSubview:redDot];
        [redDotViewes addObject:redDot];
    }
    [self setValue:redDotViewes forKey:wy_badgeRedDotViewesKey];
    
    NSMutableArray *badgeNumberViews = [NSMutableArray arrayWithCapacity:itemsCount];
    for(int i = 0; i< itemsCount; i++) {
        
        tabBarIconWidth = self.items[i].image.size.width;
        
        UILabel *redNum = [[UILabel alloc]init];
        redNum.layer.anchorPoint = CGPointMake(0, 0.5);
        redNum.bounds = CGRectMake(0, 0, 16, 12);
        redNum.center = CGPointMake(itemWidth*(i+0.5)+tabBarIconWidth/2-8, tabBarIconTop);
        redNum.layer.cornerRadius = redNum.bounds.size.height/2;
        redNum.clipsToBounds = YES;
        redNum.backgroundColor = self.wy_badgeBackgroundColor;
        redNum.hidden = YES;
        
        redNum.textAlignment = NSTextAlignmentCenter;
        redNum.font = [UIFont systemFontOfSize:10];
        redNum.textColor = self.wy_badgeTextColor;
        
        [self addSubview:redNum];
        [badgeNumberViews addObject:redNum];
    }
    [self setValue:badgeNumberViews forKey:wy_badgeNumberViewsKey];
}

- (void)wy_adjustBadgeNumberViewWithLabel:(UILabel *)label number:(NSInteger)number {
    
    [label setText:(number > 99 ? @"99+" : @(number).stringValue)];
    
    if(number < 10) {
        
        label.bounds = CGRectMake(0, 0, 12, 12);
        
    }else if(number < 99) {
        
        label.bounds = CGRectMake(0, 0, 18, 12);
        
    }else {
        
        label.bounds = CGRectMake(0, 0, 25, 12);
    }
}

- (id)valueForUndefinedKey:(NSString *)key {
    
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    objc_setAssociatedObject(self, (__bridge const void *)(key), value, OBJC_ASSOCIATION_COPY);
}

@end
