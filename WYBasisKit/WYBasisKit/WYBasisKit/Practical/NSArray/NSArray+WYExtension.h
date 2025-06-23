//
//  NSArray+WYExtension.h
//  WYBasisKit
//
//  Created by  guanren on 2018/11/28.
//  Copyright © 2018 guanren. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (WYExtension)

/** 按照字母排序 */
+ (NSArray *)wy_sortFromArray:(NSArray *)array;

/** 数字按照升序排序 */
+ (NSArray *)wy_sortAscendingNumFromArray:(NSArray *)array;

/** 数字按照降序排序 */
+ (NSArray *)wy_sortDescendingNumFromArray:(NSArray *)array;

/** 获取所有KVC的值 */
+ (NSArray *)wy_allKVCStrings:(id)object;

@end

NS_ASSUME_NONNULL_END
