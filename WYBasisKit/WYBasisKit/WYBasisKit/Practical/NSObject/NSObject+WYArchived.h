//
//  NSObject+WYArchived.h
//  WYBasisKit
//
//  Created by 官人 on 2025/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WYArchived)<NSSecureCoding>

/// 将对象安全归档为 NSData（内部使用 NSSecureCoding）
- (nullable NSData *)wy_archivedData;

/// 从 NSData 安全解档为对象（失败返回 nil）
+ (nullable instancetype)wy_unarchiveFromData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
