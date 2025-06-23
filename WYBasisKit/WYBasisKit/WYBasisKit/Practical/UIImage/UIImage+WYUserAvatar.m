//
//  UIImage+WYUserAvatar.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/12/29.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import "UIImage+WYUserAvatar.h"

@implementation WYUserAvatarOptional

- (instancetype)init {
    
    if(self == [super init]) {
        
        _avatarSize = CGSizeMake(60, 60);
        _avatarRadius = _avatarSize.width/2;
        _avatarBackgroundColor = [self wy_colorWithHexString:@"17c295" alpha:1.0f];
        _hashBackgroundColorAry = @[
                                        [self wy_colorWithHexString:@"17c295" alpha:1.0f],
                                        [self wy_colorWithHexString:@"b38979" alpha:1.0f],
                                        [self wy_colorWithHexString:@"f2725e" alpha:1.0f],
                                        [self wy_colorWithHexString:@"f7b55e" alpha:1.0f],
                                        [self wy_colorWithHexString:@"4da9eb" alpha:1.0f],
                                        [self wy_colorWithHexString:@"5f70a7" alpha:1.0f],
                                        [self wy_colorWithHexString:@"568aad" alpha:1.0f]];
        _adoptHash = YES;
        _avatarTitleColor = [UIColor whiteColor];
        _avatarTitleFont = [UIFont systemFontOfSize:15];
        _filterSpecial = YES;
        _avatarImageType = WYAvatarImageTypeShowAll;
    }
    return self;
}

- (UIColor *)wy_colorWithHexString:(NSString *)hexColor alpha:(CGFloat)alpha {
    
    unsigned int red,green,blue;
    NSRange range;
    
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    UIColor *retColor = [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:alpha];
    return retColor;
}

@end

@implementation UIImage (WYUserAvatar)

+ (UIImage *)wy_generateAvatarImageWithCharacter:(NSString *)character optional:(WYUserAvatarOptional * _Nullable)optional {
    
    if(optional == nil || !optional) {optional = [[WYUserAvatarOptional alloc]init];}
    
    character = [self wy_characterInterception:character optional:optional];
    
    UIImage *image = nil;
    if(optional.adoptHash == YES) {
        
        image = [UIImage wy_imageWithColor:optional.hashBackgroundColorAry[ABS(character.hash % optional.hashBackgroundColorAry.count)] size:optional.avatarSize cornerRadius:optional.avatarRadius];
        
    }else {
        
        image = [UIImage wy_imageWithColor:optional.avatarBackgroundColor size:optional.avatarSize cornerRadius:optional.avatarRadius];
    }
    
    UIGraphicsBeginImageContextWithOptions (optional.avatarSize, NO , 0.0 );
    
    [image drawAtPoint: CGPointMake(0 , 0)];
    
    // 获得一个位图图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawPath (context, kCGPathStroke);
    
    // 画名字
    CGSize nameSize = [character sizeWithAttributes:@{NSFontAttributeName : optional.avatarTitleFont}];
    [character drawAtPoint :CGPointMake ((optional.avatarSize.width  - nameSize.width) / 2 , (optional.avatarSize.height  - nameSize.height) / 2) withAttributes : @{NSFontAttributeName :optional.avatarTitleFont, NSForegroundColorAttributeName :optional.avatarTitleColor}];
    
    // 返回绘制的新图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext ();
    
    UIGraphicsEndImageContext ();
    
    return newImage;
}

///按规则截取要生成的字符
+ (NSString *)wy_characterInterception:(NSString *)character optional:(WYUserAvatarOptional *)optional {
    
    NSString *showName = @"";
    NSString *tempName = character;
    
    if(optional.filterSpecial == YES) {
        
        ///筛除部分特殊符号
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[ _`~!@#$%^&*()+-=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]|\n|\r|\t"];
        tempName = [tempName stringByTrimmingCharactersInSet:set];
    }
    
    if(tempName.length > 0) {
        
        switch (optional.avatarImageType) {
                
            case WYAvatarImageTypeFirstCharacter:
                showName = [tempName substringToIndex:1];
                break;
                
            case WYAvatarImageTypeLastCharacter:
                showName = [tempName substringFromIndex:tempName.length-1];
                break;
                
            default:
                showName = tempName;
                break;
        }
    }
    
    return showName;
}

+ (UIImage *)wy_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius {
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(1, 1);
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(rect);
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    [colorImage drawInRect:rect];
    
    colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}

@end
