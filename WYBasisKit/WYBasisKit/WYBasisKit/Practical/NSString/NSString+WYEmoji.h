//
//  NSString+WYEmoji.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/7/11.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WYEmoji)

/**
 *  是否是emoji
 */
- (BOOL)wy_isEmoji;


/**
 *  @brief  是否包含emoji
 *
 *  @return 是否包含emoji
 */
- (BOOL)wy_isIncludingEmoji;



/**
 *  @brief  删除掉包含的emoji
 *
 *  @return 清除后的string
 */
- (instancetype)wy_removedEmojiString;

/**
 Returns a NSString in which any occurrences that match the cheat codes
 from Emoji Cheat Sheet <http://www.emoji-cheat-sheet.com> are replaced by the
 corresponding unicode characters.
 
 Example:
 "This is a smiley face :smiley:"
 
 Will be replaced with:
 "This is a smiley face \U0001F604"
 */
- (NSString *)wy_stringByReplacingEmojiCheatCodesWithUnicode;

/**
 Returns a NSString in which any occurrences that match the unicode characters
 of the emoji emoticons are replaced by the corresponding cheat codes from
 Emoji Cheat Sheet <http://www.emoji-cheat-sheet.com>.
 
 Example:
 "This is a smiley face \U0001F604"
 
 Will be replaced with:
 "This is a smiley face :smiley:"
 */
- (NSString *)wy_stringByReplacingEmojiUnicodeWithCheatCodes;

@end
