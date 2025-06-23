//
//  UIFont+WYExtension.h
//  WYBasisKit
//
//  Created by jacke－xu on 16/9/4.
//  Copyright © 2016年 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (WYExtension)

/** 适配不同屏幕字体大小(默认3x屏字号+2),可自己修改适配逻辑 */
+ (UIFont *)wy_adjustFont:(UIFont *)font;

@end
