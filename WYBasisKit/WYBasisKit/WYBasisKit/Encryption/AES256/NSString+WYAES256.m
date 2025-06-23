//
//  NSString+WYAES256.m
//  WYBasisKit
//
//  Created by  guanren on 2018/11/27.
//  Copyright © 2018 guanren. All rights reserved.
//

#import "NSString+WYAES256.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"
#import "NSData+CommonCrypto.h"

@implementation NSString (WYAES256)

+ (NSString *)wy_AES256Encry:(NSString *)string key:(NSString *)key {
    
    NSData *encryptedData = [[string dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptedDataUsingKey:[[key dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    NSString *base64EncodedString = [NSString base64StringFromData:encryptedData length:[encryptedData length]];
    return base64EncodedString;
}

+ (NSString *)wy_AES256Decry:(NSString *)string key:(NSString *)key {
    
    NSData *encryptedData = [NSData base64DataFromString:string];
    NSData *decryptedData = [encryptedData decryptedAES256DataUsingKey:[[key dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

@end
