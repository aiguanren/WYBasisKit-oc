//
//  CALayer+WYExtension.m
//  WYBasisKit
//
//  Created by  guanren on 2018/11/27.
//  Copyright © 2018 guanren. All rights reserved.
//

#import "CALayer+WYExtension.h"

@implementation CALayer (WYExtension)

+ (CALayer *)wy_lawyerWithFrame:(CGRect)frame color:(UIColor *)color {
    
    CALayer *calawyer = [[CALayer alloc]init];
    calawyer.frame = frame;
    calawyer.backgroundColor = color.CGColor;
    
    return calawyer;
}

@end
