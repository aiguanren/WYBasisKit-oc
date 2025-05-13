//
//  NSArray+WYExtension.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/28.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import "NSArray+WYExtension.h"

@implementation NSArray (WYExtension)

+ (NSArray *)wy_sortFromArray:(NSArray *)array {
    
    NSArray *ary = [array sortedArrayUsingComparator:^(NSString * obj1, NSString * obj2){
        
        return (NSComparisonResult)[obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    return ary;
}

+ (NSArray *)wy_sortAscendingNumFromArray:(NSArray *)array {
    
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        
        if ([obj1 intValue] > [obj2 intValue]) {
            return NSOrderedDescending;//下行
        } else {
            return NSOrderedAscending;//上行
        }
    }];
    
    return sortedArray;
}

+ (NSArray *)wy_sortDescendingNumFromArray:(NSArray *)array {
    
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        
        if ([obj1 intValue] < [obj2 intValue]) {
            return NSOrderedDescending;//下行
        } else {
            return NSOrderedAscending;//上行
        }
    }];
    
    return sortedArray;
}

+ (NSArray *)wy_allKVCStrings:(id)object {
    
    NSMutableArray *array = [NSMutableArray array];
    unsigned int count;
    Ivar *ivars = class_copyIvarList([object class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *keyChar = ivar_getName(ivar);
        NSString *keyStr = [NSString stringWithCString:keyChar encoding:NSUTF8StringEncoding];
        @try {
            id valueStr = [object valueForKey:keyStr];
            NSDictionary *dic = nil;
            if (valueStr) {
                dic = @{keyStr : valueStr};
            } else {
                dic = @{keyStr : @"值为nil"};
            }
            [array addObject:dic];
        }
        @catch (NSException *exception) {}
    }
    return [array copy];
}

@end
