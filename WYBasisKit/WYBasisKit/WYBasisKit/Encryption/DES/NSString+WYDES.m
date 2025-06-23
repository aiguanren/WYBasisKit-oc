//
//  NSString+WYDES.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import "NSString+WYDES.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@implementation NSString (WYDES)

+ (NSString *)wy_DESEncry:(NSString *)string key:(NSString *)key {
    
    return [self wy_encryptUseDES:string key:key];
}


+ (NSString *)wy_DESDecry:(NSString *)string key:(NSString *)key {
    
    return [self wy_decryptUseDES:string key:key];
}

/*字符串加密
 *参数
 *plainText : 加密明文
 *key       : 密钥 64位
 */
+ (NSString *)wy_encryptUseDES:(NSString *)plainText key:(NSString *)key {
    
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    Byte iv[] = { 0x12, 0x34, 0x56, 0x78,  0x90,  0xAB,  0xCD,  0xEF };
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}

//解密
+ (NSString *)wy_decryptUseDES:(NSString*)cipherText key:(NSString*)key {
    
    NSData* cipherData = [GTMBase64 decodeString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    Byte iv[] = { 0x12, 0x34, 0x56, 0x78,  0x90,  0xAB,  0xCD,  0xEF };
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

@end
