//
//  NSString+WYEmoji.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/7/11.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import "NSString+WYEmoji.h"

@implementation NSString (WYEmoji)

static NSDictionary * wy_unicodeToCheatCodes = nil;
static NSDictionary * wy_cheatCodesToUnicode = nil;

/**
 *  @brief  是否包含emoji
 *
 *  @return 是否包含emoji
 */
- (BOOL)wy_isEmoji {
    
    if(self.length <= 0) return NO;
    
    if ([self wy_isFuckEmoji]) {
        return YES;
    }
    const unichar high = [self characterAtIndex:0];
    
    
    // Surrogate pair (U+1D000-1F77F)
    if (0xd800 <= high && high <= 0xdbff) {
        const unichar low = [self characterAtIndex: 1];
        const int codepoint = ((high - 0xd800) * 0x400) + (low - 0xdc00) + 0x10000;
        
        return (0x1d000 <= codepoint && codepoint <= 0x1f77f);
        
        // Not surrogate pair (U+2100-27BF)
    } else {
        return (0x2100 <= high && high <= 0x27bf);
    }
    //
}

- (BOOL)wy_isFuckEmoji {
    
    NSArray *fuckArray =@[@"⭐",@"㊙️",@"㊗️",@"⬅️",@"⬆️",@"⬇️",@"⤴️",@"⤵️",@"#️⃣",@"0️⃣",@"1️⃣",@"2️⃣",@"3️⃣",@"4️⃣",@"5️⃣",@"6️⃣",@"7️⃣",@"8️⃣",@"9️⃣",@"〰",@"©®",@"〽️",@"‼️",@"⁉️",@"⭕️",@"⬛️",@"⬜️",@"⭕",@"",@"⬆",@"⬇",@"⬅",@"㊙",@"㊗",@"⭕",@"©®",@"⤴",@"⤵",@"〰",@"†",@"⟹",@"ツ",@"ღ",@"©",@"®"];
    BOOL result = NO;
    for(NSString *string in fuckArray){
        if ([self isEqualToString:string]) {
            return YES;
        }
    }
    if ([@"\u2b50\ufe0f" isEqualToString:self]) {
        result = YES;
        
    }
    return result;
}

- (BOOL)wy_isIncludingEmoji {
    
    BOOL __block result = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              if ([substring wy_isEmoji]) {
                                  *stop = YES;
                                  result = YES;
                              }
                          }];
    
    return result;
}

/**
 *  @brief  删除掉包含的emoji
 *
 *  @return 清除后的string
 */
- (instancetype)wy_removedEmojiString {
    
    NSMutableString* __block buffer = [NSMutableString stringWithCapacity:[self length]];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              [buffer appendString:([substring wy_isEmoji])? @"": substring];
                          }];
    
    return buffer;
}

+ (void)wy_initializeEmojiCheatCodes
{
    NSData *emojiData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmojiFile" ofType:nil]];
    if((emojiData == nil) || (!emojiData)) {
        
        NSLog(@"bundle中未发现EmojiFile");
        return;
    }
    NSDictionary *forwardMap = [NSJSONSerialization JSONObjectWithData:emojiData options:0 error:nil];
    
    NSMutableDictionary *reversedMap = [NSMutableDictionary dictionaryWithCapacity:[forwardMap count]];
    [forwardMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            for (NSString *object in obj) {
                [reversedMap setObject:key forKey:object];
            }
        } else {
            [reversedMap setObject:key forKey:obj];
        }
    }];
    
    @synchronized(self) {
        wy_unicodeToCheatCodes = forwardMap;
        wy_cheatCodesToUnicode = [reversedMap copy];
    }
}

- (NSString *)wy_stringByReplacingEmojiCheatCodesWithUnicode
{
    if (!wy_cheatCodesToUnicode) {
        [NSString wy_initializeEmojiCheatCodes];
    }
    
    if ([self rangeOfString:@":"].location != NSNotFound) {
        __block NSMutableString *newText = [NSMutableString stringWithString:self];
        [wy_cheatCodesToUnicode enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            [newText replaceOccurrencesOfString:key withString:obj options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
        }];
        return newText;
    }
    
    return self;
}

- (NSString *)wy_stringByReplacingEmojiUnicodeWithCheatCodes
{
    if (!wy_cheatCodesToUnicode) {
        [NSString wy_initializeEmojiCheatCodes];
    }
    
    if (self.length) {
        __block NSMutableString *newText = [NSMutableString stringWithString:self];
        [wy_unicodeToCheatCodes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *string = ([obj isKindOfClass:[NSArray class]] ? [obj firstObject] : obj);
            [newText replaceOccurrencesOfString:key withString:string options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
        }];
        return newText;
    }
    return self;
}

@end
