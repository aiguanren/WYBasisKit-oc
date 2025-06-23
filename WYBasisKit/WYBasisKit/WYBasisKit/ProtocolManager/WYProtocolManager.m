//
//  WYProtocolManager.m
//  WYBasisKit
//
//  Created by Miraitowa on 2021/7/9.
//  Copyright © 2021 jacke-xu. All rights reserved.
//

#import "WYProtocolManager.h"
#import <objc/runtime.h>

typedef void (^mutiBlock)(NSString * str);

@interface WYProtocolManager()

@property (nonatomic, strong) NSPointerArray *weakRefTargets;
@property (nonatomic, strong) NSMutableDictionary *blocks;
@property (nonatomic, copy) void (^block)(NSString *str);

@end

@implementation WYProtocolManager

/// 获取单例对象
static WYProtocolManager *__manager;
+ (instancetype)shared {
    
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        __manager = [[WYProtocolManager alloc]init];
    });
    return __manager;
}

- (instancetype)init {
    
    _blocks = [NSMutableDictionary dictionary];
    _weakRefTargets = [NSPointerArray weakObjectsPointerArray];
    
    return self;
}

- (void)testMultiDelegate:(NSString *)str {
    
    for (mutiBlock block in _blocks.allValues) {
        if (block) {
            block(str);
        }
    }
    
    for (id target in _weakRefTargets) {
        if ([target respondsToSelector:@selector(testMultiDelegate:)]) {
            [target testMultiDelegate:str];
        }
    }
}

/// 添加多代理对象
- (void)addMultiDelegate:(id<WYMultiDelegate>)delegate {
    if ([delegate respondsToSelector:@selector(testMultiDelegate:)]) {
        [_weakRefTargets addPointer:(__bridge void *)delegate];
    }
}

/// 添加多block对象
- (void)addtarget:(id)target mutiHandler:(void (^)(NSString *str))handler {
    
    NSObject *obj = (NSObject *)target;
    if (handler && target) {
        [_blocks setObject:handler forKey:[NSString stringWithFormat:@"%lu", (unsigned long)obj.hash]];
    }
}

/// 移除指定block
- (void)removeHandler:(id)target {
    
    if (target) {
        NSObject *obj = (NSObject *)target;
        [_blocks removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)obj.hash]];
    }
}

/// 移除所有block
- (void)removeAllHandler {
    for (id obj in _blocks) {
        [_blocks removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)((NSObject *)obj).hash]];
    }
}

@end
