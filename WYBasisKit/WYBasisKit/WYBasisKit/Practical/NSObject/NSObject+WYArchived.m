//
//  NSObject+WYArchived.m
//  WYBasisKit
//
//  Created by 官人 on 2025/7/7.
//

#import "NSObject+WYArchived.h"
#import <objc/runtime.h>

@implementation NSObject (WYArchived)

static NSSet<Class> *wy_basicAllowedClasses(Class rootClass) {
    static NSSet<Class> *kFoundationSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kFoundationSet = [NSSet setWithObjects:
                          [NSString class],            [NSNumber class],
                          [NSArray class],             [NSMutableArray class],
                          [NSDictionary class],        [NSMutableDictionary class],
                          [NSSet class],               [NSMutableSet class],
                          [NSData class],              [NSDate class],
                          [NSValue class],
                          nil];
    });
    return [kFoundationSet setByAddingObject:rootClass];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    if ([self isMemberOfClass:[NSObject class]] || [self isMemberOfClass:[NSProxy class]]) {
        return;
    }
    
    Class currentClass = [self class];
    while (currentClass && currentClass != [NSObject class]) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(currentClass, &count);
        
        for (unsigned int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            
            // 检查是否为只读属性
            const char *attributes = property_getAttributes(property);
            if (strstr(attributes, ",R") != NULL) {
                continue; // 跳过只读属性
            }
            
            NSString *key = [NSString stringWithUTF8String:property_getName(property)];
            @try {
                id value = [self valueForKey:key];
                if (value) {
                    [coder encodeObject:value forKey:key];
                }
            } @catch (NSException *exception) {
                NSLog(@"WYArchived encode error for key %@: %@", key, exception.reason);
            }
        }
        free(properties);
        
        currentClass = class_getSuperclass(currentClass);
    }
}

- (instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if (self = [self init]) {
        Class currentClass = [self class];
        while (currentClass && currentClass != [NSObject class]) {
            unsigned int count = 0;
            objc_property_t *properties = class_copyPropertyList(currentClass, &count);
            
            for (unsigned int i = 0; i < count; i++) {
                objc_property_t property = properties[i];
                
                // 检查是否为只读属性
                const char *attributes = property_getAttributes(property);
                if (strstr(attributes, ",R") != NULL) {
                    continue; // 跳过只读属性
                }
                
                NSString *key = [NSString stringWithUTF8String:property_getName(property)];
                
                // 检查是否存在setter方法
                NSString *setterName = [NSString stringWithFormat:@"set%@%@:",
                                        [[key substringToIndex:1] uppercaseString],
                                        [key substringFromIndex:1]];
                SEL setterSelector = NSSelectorFromString(setterName);
                if (![self respondsToSelector:setterSelector]) {
                    continue; // 没有setter方法，跳过
                }
                
                @try {
                    // 直接解码对象，不限制类
                    id value = [coder decodeObjectForKey:key];
                    if (value && value != [NSNull null]) {
                        [self setValue:value forKey:key];
                    }
                } @catch (NSException *exception) {
                    NSLog(@"WYArchived decode error for key %@: %@", key, exception.reason);
                }
            }
            free(properties);
            
            currentClass = class_getSuperclass(currentClass);
        }
    }
    return self;
}

#pragma mark - 对象 <-> Data

- (NSData *)wy_archivedData {
    @try {
        NSError *error = nil;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self
                                             requiringSecureCoding:YES
                                                             error:&error];
        if (error) {
            NSLog(@"WYArchived archive error: %@", error.localizedDescription);
        }
        return data;
    } @catch (NSException *exception) {
        NSLog(@"WYArchived archive exception: %@", exception.reason);
        return nil;
    }
}

+ (instancetype)wy_unarchiveFromData:(NSData *)data {
    if (![data isKindOfClass:[NSData class]] || data.length == 0) {
        return nil;
    }
    
    NSSet *allowed = wy_basicAllowedClasses(self);
    NSError *error = nil;
    id object = [NSKeyedUnarchiver unarchivedObjectOfClasses:allowed
                                                    fromData:data
                                                       error:&error];
    if (!object || error) {
        @try {
            object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } @catch (NSException *fallbackException) {
            NSLog(@"WYArchived fallback unarchive error: %@", fallbackException.reason);
        }
    }
    return object;
}


@end
