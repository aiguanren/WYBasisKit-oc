//
//  NSString+WYMD5.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import "NSString+WYMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (WYMD5)

+ (NSString *)wy_MD5_16BitEncry:(NSString *)MD5String isUppercase:(BOOL)isUppercase {
    
    //提取32位MD5散列的中间16位
    NSString *md5_32Bit_String = [self wy_MD5_32BitEncry:MD5String isUppercase:NO];
    NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    
    if (isUppercase) {
        return [result uppercaseString];
    }else{
        return result;
    }
}

+ (NSString *)wy_MD5_NB16BitEncry:(NSString *)MD5String isUppercase:(BOOL)isUppercase {
    
    //提取32位MD5散列的中间16位
    NSString *md5_32Bit_String=[self wy_MD5_NB32BitEncry:MD5String isUppercase:NO];
    NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    
    if (isUppercase) {
        return [result uppercaseString];
    }else{
        return result;
    }
}

+ (NSString *)wy_MD5_32BitEncry:(NSString *)MD5String isUppercase:(BOOL)isUppercase {
    
    const char *str = [MD5String UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( str, (CC_LONG)MD5String.length, digest );
    //CC_MD5(str, (CC_LONG)strlen(str), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    if (isUppercase) {
        return [result uppercaseString];
    }else{
        return result;
    }
}

+ (NSString *)wy_MD5_NB32BitEncry:(NSString *)MD5String isUppercase:(BOOL)isUppercase {
    
    const char *cStr = [MD5String UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    [result appendFormat:@"%02x",digest[0]];
    
    for (int i = 1; i< CC_MD5_DIGEST_LENGTH; i++) {
        
        [result appendFormat:@"%02x",digest[i]^digest[0]];
        
    }
    
    if (isUppercase) {
        return [result uppercaseString];
    }else{
        return result;
    }
}

@end
