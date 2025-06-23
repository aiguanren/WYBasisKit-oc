//
//  LocalStorage.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/6/14.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import "LocalStorage.h"

@interface LocalStorage (){
    
    NSUserDefaults *_userDefaults;
}

@end

@implementation LocalStorage

static LocalStorage *_localStorage = nil;

+ (LocalStorage *)shared {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        _localStorage = [[LocalStorage alloc]init];
    });
    
    return _localStorage;
}

- (instancetype)init {
    
    if(self = [super init]) {
        
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)storageArray:(NSArray *)array forKey:(NSString *)arrayKey {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [_userDefaults setObject:data forKey:arrayKey];
}

- (NSArray *)fetchStorageArrayForKey:(NSString *)arrayKey {
    
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:[_userDefaults objectForKey:arrayKey]];
    return (array == nil) ? [NSArray array] : array;
}


@end
