//
//  NSMutableAttributedString+ZX.h
//  Hypnotist
//
//  Created by Sincan on 15/10/20.
//  Copyright (c) 2015年 Omesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (ZX)

+ (id)attributedString:(NSString *)string font:(UIFont *)font color:(UIColor *)color;

+ (id)attributedString:(NSString *)string font:(UIFont *)font zhsFont:(UIFont *)zhsFont color:(UIColor *)color;

+ (id)attributedStringWithName:(NSString *)string fontSize:(CGFloat)fontSize color:(UIColor *)color;

+ (id)attributedStringWithName:(NSString *)string boldFontSize:(CGFloat)fontSize color:(UIColor *)color;
@end
