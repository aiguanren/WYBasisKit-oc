//
//  CALayer+WYExtension.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (WYExtension)

/** 创建view边框 */
+ (CALayer *)wy_lawyerWithFrame:(CGRect)frame color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
