//
//  Foundation+JSONLog.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/10/18.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

/*
 将字典（NSDictionary）和数组（NSArray）转化成JSON格式字符串输出到控制台。
 直接将这个文件拖到工程中即可生效。
 */

//DEBUG模式生效
#ifdef DEBUG

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#pragma mark - 方法交换

static inline void wy_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


#pragma mark - NSObject分类

@implementation NSObject (JSONLog)
//将obj转换成json字符串。如果失败则返回nil.
- (NSString *)wy_convertToJsonString {
    
    //先判断是否能转化为JSON格式
    if (![NSJSONSerialization isValidJSONObject:self])  return nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted  error:&error];
    if (error || !jsonData) return nil;
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
@end


#pragma mark - NSDictionary分类

@implementation NSDictionary (JSONLog)

//用此方法交换系统的 descriptionWithLocale: 方法。该方法在代码打印的时候调用。
- (NSString *)wy_jsonlog_descriptionWithLocale:(id)locale{
    
    NSString *result = [self wy_convertToJsonString];//转换成JSON格式字符串
    if (!result) return [self wy_jsonlog_descriptionWithLocale:locale];//如果无法转换，就使用原先的格式
    return result;
}
//用此方法交换系统的 descriptionWithLocale:indent:方法。功能同上。
- (NSString *)wy_jsonlog_descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    
    NSString *result = [self wy_convertToJsonString];
    if (!result) return [self wy_jsonlog_descriptionWithLocale:locale indent:level];
    return result;
}
//用此方法交换系统的 debugDescription 方法。该方法在控制台使用po打印的时候调用。
- (NSString *)wy_jsonlog_debugDescription{
    
    NSString *result = [self wy_convertToJsonString];
    if (!result) return [self wy_jsonlog_debugDescription];
    return result;
}

//在load方法中完成方法交换
+ (void)load {
    
    //方法交换
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        wy_swizzleSelector(class, @selector(descriptionWithLocale:), @selector(wy_jsonlog_descriptionWithLocale:));
        wy_swizzleSelector(class, @selector(descriptionWithLocale:indent:), @selector(wy_jsonlog_descriptionWithLocale:indent:));
        wy_swizzleSelector(class, @selector(debugDescription), @selector(wy_jsonlog_debugDescription));
    });
}

@end


#pragma mark - NSArray分类

@implementation NSArray (JSONLog)

//用此方法交换系统的 descriptionWithLocale: 方法。该方法在代码打印的时候调用。
- (NSString *)wy_jsonlog_descriptionWithLocale:(id)locale{
    
    NSString *result = [self wy_convertToJsonString];
    if (!result) return [self wy_jsonlog_descriptionWithLocale:locale];
    return result;
}
//用此方法交换系统的 descriptionWithLocale:indent:方法。功能同上。
- (NSString *)wy_jsonlog_descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    
    NSString *result = [self wy_convertToJsonString];
    if (!result) return [self wy_jsonlog_descriptionWithLocale:locale indent:level];
    return result;
}
//用此方法交换系统的 debugDescription 方法。该方法在控制台使用po打印的时候调用。
- (NSString *)wy_jsonlog_debugDescription{
    
    NSString *result = [self wy_convertToJsonString];
    if (!result) return [self wy_jsonlog_debugDescription];
    return result;
}

+ (void)load {
    
    //方法交换
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        wy_swizzleSelector(class, @selector(descriptionWithLocale:), @selector(wy_jsonlog_descriptionWithLocale:));
        wy_swizzleSelector(class, @selector(descriptionWithLocale:indent:), @selector(wy_jsonlog_descriptionWithLocale:indent:));
        wy_swizzleSelector(class, @selector(debugDescription), @selector(wy_jsonlog_debugDescription));
    });
}

@end


#endif
