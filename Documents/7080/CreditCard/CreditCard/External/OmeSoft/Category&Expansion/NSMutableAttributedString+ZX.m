//
//  NSMutableAttributedString+ZX.m
//  Hypnotist
//
//  Created by Sincan on 15/10/20.
//  Copyright (c) 2015年 Omesoft. All rights reserved.
//

#import "NSMutableAttributedString+ZX.h"
#import "UIFont+ZX.h"

@implementation NSMutableAttributedString (ZX)

+ (id)attributedString:(NSString *)string font:(UIFont *)font color:(UIColor *)color
{
    if (string.length <= 0 || !font || !color) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
    return attString;
}

+ (id)attributedString:(NSString *)string font:(UIFont *)font zhsFont:(UIFont *)zhsFont color:(UIColor *)color
{
    if (string.length <= 0 || !font || !color) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    for (int i = 0; i < string.length; i++) {
        int a = [string characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fff) {
            //中文
            [attString addAttribute:NSFontAttributeName value:zhsFont range:NSMakeRange(i, 1)];
        } else {
            [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(i, 1)];
        }
    }
    [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
    return attString;
}


+ (id)attributedStringWithName:(NSString *)string fontSize:(CGFloat)fontSize color:(UIColor *)color
{
    return [NSMutableAttributedString attributedString:string font:[UIFont fontWithName:@"HelveticaNeue" size:fontSize] zhsFont:[UIFont zhsFontOfSize:fontSize] color:color];
}

+ (id)attributedStringWithName:(NSString *)string boldFontSize:(CGFloat)fontSize color:(UIColor *)color
{
    return [NSMutableAttributedString attributedString:string font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize] zhsFont:[UIFont boldZhsFontOfSize:fontSize] color:color];
}

@end
