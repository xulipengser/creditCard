//
//  UIColor+Omesoft.m
//  
//
//  Created by sincna on 12-10-30.
//  Copyright (c) 2012年 Omesoft. All rights reserved.
//

#import "UIColor+Omesoft.h"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]
@implementation UIColor (Omesoft)
+ (UIColor *)colorWithHexString:(NSString *)string alpha:(CGFloat)alpha
{
    if (alpha == 0) return [UIColor clearColor];
    NSString *cString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    CGFloat colorAlpha = MAX(0, MIN(1.0, alpha));
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:colorAlpha];
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    return [UIColor colorWithHexString:stringToConvert alpha:1.0];
}

- (NSString *)hexRGB{
    const CGFloat *cs=CGColorGetComponents(self.CGColor);
    
    
    NSString *r = [NSString stringWithFormat:@"%@",[self  ToHex:cs[0]*255]];
    NSString *g = [NSString stringWithFormat:@"%@",[self  ToHex:cs[1]*255]];
    NSString *b = [NSString stringWithFormat:@"%@",[self  ToHex:cs[2]*255]];
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
    
    
}


//十进制转十六进制
-(NSString *)ToHex:(int)tmpid
{
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue= [NSString stringWithFormat:@"%i",ttmpig];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat= [NSString stringWithFormat:@"%i",tmp];
            
    }
    return [NSString stringWithFormat:@"%@%@",nStrat,nLetterValue];
}
@end
