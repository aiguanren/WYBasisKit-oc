//
//  WYEventHandler.m
//  WYBasisKit
//
//  Created by 官人 on 2025/6/26.
//

#import "WYEventHandler.h"
#import <objc/runtime.h>

#pragma mark - KitEventHandler

/// 包装事件监听器及其关联目标
@interface KitEventHandler : NSObject

@property (nonatomic, weak) id target;  ///< 若为 nil，则视为永久事件监听器
@property (nonatomic, copy) void (^handler)(id _Nullable data);
@property (nonatomic, assign) BOOL isPermanent;

/// 当前监听器是否有效（目标未释放）
@property (nonatomic, readonly) BOOL isValid;

- (instancetype)initWithTarget:(nullable id)target
                       handler:(void (^)(id _Nullable data))handler;

@end

@implementation KitEventHandler

- (instancetype)initWithTarget:(nullable id)target
                       handler:(void (^)(id _Nullable data))handler {
    if (self = [super init]) {
        _target = target;
        _handler = [handler copy];
        _isPermanent = (target == nil);
    }
    return self;
}

- (BOOL)isValid {
    return self.isPermanent || self.target != nil;
}

@end

#pragma mark - KitDeallocWatcher

/// 用于目标对象释放时自动解绑监听器
@interface KitDeallocWatcher : NSObject

@property (nonatomic, copy) void (^callback)(void);

- (instancetype)initWithCallback:(void (^)(void))callback;

@end

@implementation KitDeallocWatcher

- (instancetype)initWithCallback:(void (^)(void))callback {
    if (self = [super init]) {
        _callback = [callback copy];
    }
    return self;
}

- (void)dealloc {
    if (_callback) {
        _callback();
    }
}

@end

#pragma mark - WYEventHandler

@interface WYEventHandler ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<KitEventHandler *> *> *eventHandlersMap;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation WYEventHandler

/// 关联对象 key
static void *WYEventHandlerDeallocWatcherKey = &WYEventHandlerDeallocWatcherKey;

/// 单例对象
+ (instancetype)shared {
    static WYEventHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WYEventHandler alloc] init];
    });
    return instance;
}

/// 私有构造
- (instancetype)init {
    if (self = [super init]) {
        _eventHandlersMap = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

/// 当前所有事件监听器（用于调试或状态查看）
- (NSDictionary<NSString *, NSArray *> *)eventHandlers {
    [_lock lock];
    NSMutableDictionary *snapshot = [NSMutableDictionary dictionary];
    [self.eventHandlersMap enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray *obj, BOOL *stop) {
        snapshot[key] = [obj copy]; // 返回不可变数组
    }];
    [_lock unlock];
    return [snapshot copy];
}

/// 注册监听器
- (void)registerEvent:(NSString *)event
               target:(nullable id)target
              handler:(void (^)(id _Nullable data))handler {
    [_lock lock];

    KitEventHandler *wrapper = [[KitEventHandler alloc] initWithTarget:target handler:handler];
    NSMutableArray *handlers = self.eventHandlersMap[event] ?: [NSMutableArray array];
    [handlers addObject:wrapper];
    self.eventHandlersMap[event] = handlers;

    // 设置释放监听器
    if (target && ![self hasDeallocWatcherForTarget:target]) {
        [self setupDeallocWatcherForTarget:target];
    }

    [_lock unlock];
}

/// 触发事件
- (void)responseEvent:(NSString *)event data:(nullable id)data {
    [_lock lock];

    NSMutableArray<KitEventHandler *> *handlers = [self.eventHandlersMap[event] mutableCopy];
    if (!handlers) {
        [_lock unlock];
        return;
    }

    NSMutableArray *validHandlers = [NSMutableArray array];
    for (KitEventHandler *handler in handlers) {
        if (handler.isValid) {
            [validHandlers addObject:handler];
        }
    }

    if (validHandlers.count > 0) {
        self.eventHandlersMap[event] = validHandlers;
    } else {
        [self.eventHandlersMap removeObjectForKey:event];
    }

    [_lock unlock];

    for (KitEventHandler *handler in validHandlers) {
        if (handler.handler) {
            handler.handler(data);
        }
    }
}

/// 移除指定事件/目标绑定
- (void)removeEvent:(nullable NSString *)event target:(nullable id)target {
    [_lock lock];

    if (event) {
        [self updateHandlersForEvent:event target:target];
    } else {
        for (NSString *key in self.eventHandlersMap.allKeys) {
            [self updateHandlersForEvent:key target:target];
        }
    }

    [_lock unlock];
}

/// 移除指定目标的所有监听器
- (void)removeTarget:(id)target {
    [self removeEvent:nil target:target];
}

/// 移除所有事件监听器
- (void)removeAll {
    [_lock lock];
    [self.eventHandlersMap removeAllObjects];
    [_lock unlock];
}

#pragma mark - Private

/// 根据目标过滤某个事件的 handler 数组
- (void)updateHandlersForEvent:(NSString *)event target:(nullable id)target {
    NSMutableArray<KitEventHandler *> *handlers = self.eventHandlersMap[event];
    if (!handlers) return;

    if (target) {
        NSMutableArray *filtered = [NSMutableArray array];
        for (KitEventHandler *handler in handlers) {
            if (handler.isPermanent || handler.target != target) {
                [filtered addObject:handler];
            }
        }
        if (filtered.count > 0) {
            self.eventHandlersMap[event] = filtered;
        } else {
            [self.eventHandlersMap removeObjectForKey:event];
        }
    } else {
        [self.eventHandlersMap removeObjectForKey:event];
    }
}

/// 判断是否已添加 Dealloc 监听器
- (BOOL)hasDeallocWatcherForTarget:(id)target {
    return objc_getAssociatedObject(target, WYEventHandlerDeallocWatcherKey) != nil;
}

/// 给 target 绑定释放监听器
- (void)setupDeallocWatcherForTarget:(id)target {
    __weak typeof(self) weakSelf = self;
    KitDeallocWatcher *watcher = [[KitDeallocWatcher alloc] initWithCallback:^{
        [weakSelf removeTarget:target];
    }];
    objc_setAssociatedObject(target, WYEventHandlerDeallocWatcherKey, watcher, OBJC_ASSOCIATION_RETAIN);
}

@end
