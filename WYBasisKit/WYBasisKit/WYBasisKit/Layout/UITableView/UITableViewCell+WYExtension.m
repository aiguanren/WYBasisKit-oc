//
//  UITableViewCell+WYExtension.m
//  WYBasisKit
//
//  Created by bangtuike on 2019/7/25.
//  Copyright © 2019 guanren. All rights reserved.
//

#import "UITableViewCell+WYExtension.h"
#include <objc/runtime.h>

@implementation UITableViewCell (WYExtension)

- (void)setWy_rightArrowImage:(UIImage *)wy_rightArrowImage {
    
    if(wy_rightArrowImage == nil) return;
    
    objc_setAssociatedObject(self, @selector(wy_rightArrowImage), wy_rightArrowImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:wy_rightArrowImage];
    self.accessoryView = accessoryView;
}

- (UIImage *)wy_rightArrowImage {
    
    return objc_getAssociatedObject(self, @selector(wy_rightArrowImage));
}

- (void)wy_cellCutOffLineFromZeroPoint {
    
    if([self.superview isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)self.superview;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
