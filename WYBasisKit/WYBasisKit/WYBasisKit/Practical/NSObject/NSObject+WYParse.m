//
//  NSObject+WYParse.m
//  WYBasisKit
//
//  Created by  guanren on 2018/11/28.
//  Copyright © 2018 guanren. All rights reserved.
//

#import "NSObject+WYParse.h"
#import <objc/runtime.h>

@implementation NSObject (WYParse)

//防止向不存在的key赋值，导致崩溃，重写下面的方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

//防止向key中赋值nil导致崩溃
- (void)setNilValueForKey:(NSString *)key {}

//对数组进行解析，解析的操作就是把数组中的每个元素拿出来，使用特殊的类型进行解析，解析完毕后存入到可变数组种中
+ (id)wy_parseAry:(NSArray *)ary {
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (id obj in ary) {
        
        [array addObject:[self wy_parse:obj]];
    }
    return [array copy];
}

//对字典进行解析
+ (id)wy_parseDic:(NSDictionary *)dic {
    
    id anyObj = [[self alloc]init];
    //[anyObj setValuesForKeysWithDictionary:dic];
    //为了匹配每个key，防止key有变动，需要更加自定义的方式
    //遍历字典
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //如果子类重写replacePropertyForKey方法，则可以返回对应的key
        //即假设传入的参数key是description,子类重写以后，返回的是desc
        key = [self wy_replacePropertyForKey:key];
        //判断如果当前的value是数组类型的
        if([obj isKindOfClass:[NSArray class]]) {
            
            Class class = [self wy_objectClassInArray][key];
            if(class) {
                
                NSMutableArray *array = [[NSMutableArray alloc]init];
                for (id object in obj) {
                    [array addObject:[class wy_parse:object]];
                }
                obj = [array copy];
            }
        }
        [anyObj setValue:obj forKey:key];
    }];
    return anyObj;
}

//判断如果传入的是数组就用数组解析，否则就用字典字典解析
+ (id)wy_parse:(id)responseObj {
    
    if([responseObj isKindOfClass:[NSArray class]]) {
        
        return [self wy_parseAry:responseObj];
    }
    if([responseObj isKindOfClass:[NSDictionary class]]) {
        
        return [self wy_parseDic:responseObj];
    }
    return responseObj;
}

//此方法主要是为了让子类重写才能生效
+ (NSString *)wy_replacePropertyForKey:(NSString *)key {return key;}

//此方法只有子类重写才生效
+ (NSDictionary *)wy_objectClassInArray {return nil;}

+ (BOOL)wy_compareObject:(NSObject *)firstObj withObject:(NSObject *)secondObj {
    
    if([firstObj wy_objectAllProperty].count != [secondObj  wy_objectAllProperty].count) {
        
        return NO;
    }
    NSString *firstKey = @"";
    NSString *secondKey = @"";
    for (int i=0; i<[firstObj wy_objectAllProperty].count; i++) {
        
        firstKey = [firstObj wy_objectAllProperty][i];
        secondKey = [secondObj wy_objectAllProperty][i];
        if(![[firstObj valueForKey:firstKey] isEqual:[secondObj valueForKey:secondKey]]) {
            
            return NO;
        }
    }
    
    return YES;
}

- (NSArray *)wy_objectAllProperty {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertys[i];
        const char *nameChar = property_getName(property);
        NSString *nameStr = [NSString stringWithCString:nameChar encoding:NSUTF8StringEncoding];
        [array addObject:nameStr];
    }
    return [array copy];

}

@end
