//
//  WYProtocolManager.h
//  WYBasisKit
//
//  Created by Miraitowa on 2021/7/9.
//  Copyright © 2021 jacke-xu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WYMultiDelegate <NSObject>

@optional
- (void)testMultiDelegate:(NSString *)str;

@end

@interface WYProtocolManager : NSObject

/// 获取单例对象
+ (instancetype)shared;

/// 添加多代理对象
- (void)addMultiDelegate:(id<WYMultiDelegate>)delegate;

/// 添加多block对象
- (void)addtarget:(id)target mutiHandler:(void (^)(NSString *str))handler;

/// 移除指定block
- (void)removeHandler:(id)target;

/// 移除所有block
- (void)removeAllHandler;

- (void)testMultiDelegate:(NSString *)str;


@end

NS_ASSUME_NONNULL_END
