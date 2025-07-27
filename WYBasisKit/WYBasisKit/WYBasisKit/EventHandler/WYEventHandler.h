//
//  WYEventHandler.h
//  WYBasisKit
//
//  Created by 官人 on 2025/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 跨页面/多对象的事件监听工具，无需手动解绑(对象释放后自动解绑)，支持代理和闭包，可用于回调、通知、事件分发等场景
@interface WYEventHandler : NSObject

/// 单例对象
+ (instancetype)shared;

/// 当前所有事件及其监听器数组（只读属性，外部可用于调试或状态查询）
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSArray *> *eventHandlers;

/**
 *  注册事件监听器
 *
 *  @param event     事件标识符（建议使用常量或枚举）
 *  @param target    可选的绑定对象，监听对象释放后将自动移除对应监听器
 *  @param handler   事件回调（参数为触发事件时传入的数据）
 */
- (void)registerEvent:(NSString *)event
               target:(nullable id)target
              handler:(void (^)(id _Nullable data))handler;

/**
 *  触发(通知)事件回调（按监听器注册顺序依次调用）
 *
 *  @param event     事件标识符（建议使用常量或枚举）
 *  @param data      可选数据，将传入监听器的回调中
 */
- (void)responseEvent:(NSString *)event data:(nullable id)data;

/**
 *  移除事件监听（支持按事件、按目标对象过滤）
 *
 *  根据 event 和 target 的组合不同，执行不同的移除策略：
 *
 *  1. event == nil 且 target == nil：
 *     ➤ 移除所有事件的所有监听对象，等价于 removeAll 方法
 *
 *  2. event == nil 且 target != nil：
 *     ➤ 移除target对象绑定的所有监听事件
 *
 *  3. event != nil 且 target == nil：
 *     ➤ 移除event事件的所有监听对象
 *
 *  4. event != nil 且 target != nil：
 *     ➤ 移除target对象对event事件的监听
 *
 *  @param event   事件标识符，可为 nil（表示所有事件）
 *  @param target  目标对象，可为 nil（表示所有对象）
 */
- (void)removeEvent:(nullable NSString *)event target:(nullable id)target;

/**
 *  移除target对象相关的所有监听事件
 *
 *  @param target 要移除的监听事件的target对象
 */
- (void)removeTarget:(id)target;

/**
 *  移除所有监听对象及所有事件监听
 */
- (void)removeAll;

@end

NS_ASSUME_NONNULL_END
