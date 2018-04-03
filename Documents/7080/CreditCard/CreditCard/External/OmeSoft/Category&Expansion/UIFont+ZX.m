//
//  UIFont+ZX.m
//  Hypnotist
//
//  Created by omesoft on 15/8/28.
//  Copyright (c) 2015年 Omesoft. All rights reserved.
//

#import "UIFont+ZX.h"
#import "NSString+Omesoft.h"

typedef NS_OPTIONS(NSUInteger, ZHSFontState)
{
    ZHSFontStateUndetermined = 0,
    ZHSFontStateCanBeUsed,
    ZHSFontStateNoExist
};

static ZHSFontState fontState;
@implementation UIFont (ZX)

+ (UIFont *)hpFontOfSize:(CGFloat)fontSize
{
    if ([NSLocalizedString(@"language", @"en") isEqualToString:@"en"]) {
        return [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
    }
    
    return [UIFont zhsFontOfSize:fontSize];
}

+ (UIFont *)boldHPFontOfSize:(CGFloat)fontSize
{
    if ([NSLocalizedString(@"language", @"en") isEqualToString:@"en"]) {
        return [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
    }
    return [UIFont boldZhsFontOfSize:fontSize];
}


+ (UIFont *)zhsFontOfSize:(CGFloat)fontSize
{
    if (fontState == ZHSFontStateUndetermined) {
        UIFont *result;
        UIFont *scFont = [UIFont fontWithName:@"STHeitiSC-Light" size:fontSize];
        if (scFont) {
            result = scFont;
            fontState = ZHSFontStateCanBeUsed;
        } else {
            result = [UIFont systemFontOfSize:fontSize];
            fontState = ZHSFontStateNoExist;
        }
        return result;
    } else if (fontState == ZHSFontStateCanBeUsed) {
        return [UIFont fontWithName:@"STHeitiSC-Light" size:fontSize];
    } else {
        return [UIFont systemFontOfSize:fontSize];
    }
}

+ (UIFont *)boldZhsFontOfSize:(CGFloat)fontSize
{
    if (fontState == ZHSFontStateUndetermined) {
        UIFont *result;
        UIFont *scFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:fontSize];
        if (scFont) {
            result = scFont;
            fontState = ZHSFontStateCanBeUsed;
        } else {
            result = [UIFont systemFontOfSize:fontSize];
            fontState = ZHSFontStateNoExist;
        }
        return result;
    } else if (fontState == ZHSFontStateCanBeUsed) {
        return [UIFont fontWithName:@"STHeitiSC-Medium" size:fontSize];
    } else {
        return [UIFont systemFontOfSize:fontSize];
    }
}

- (CGFloat)height
{
    return [@"Font" singleLineSizeWithFont:self].height;
}

@end
