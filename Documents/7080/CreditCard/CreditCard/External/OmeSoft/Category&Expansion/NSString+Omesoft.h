//
//  NSString+Omesoft.h
//  MediXPub
//
//  Created by Omesoft on 12-11-22.
//  Copyright (c) 2012年 Omesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Omesoft)
+ (NSString*)bankCardToAsterisk:(NSString *)bankCardNum;
+ (NSString*)idCardToAsterisk:(NSString *)idCardNum;
+ (NSString *)investPersonNameToAsterisk:(NSString *)personName;

- (NSDate *)stringWihtDateFormat:(NSString*)dateFormat;
- (NSDate *)stringWihtDateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timezone locale:(NSLocale *)locale;

+ (NSString *)jsonStringWithString:(NSString *)str;
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dic;
+ (NSString *)jsonStringWithArray:(NSArray *)array;
+ (NSString *)jsonStringWithObject:(id)object;
+ (NSString *)md5:(NSString *)string;
- (NSString *)MD5;
- (NSString *)MD5Upper;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
- (BOOL)isPureInt;
- (BOOL)isPureFloat;
- (BOOL)isPureEnAndNumber;
- (BOOL)isIpAdress;
- (BOOL)isEmail;
- (BOOL)isPhoneNumber;

- (NSString *)stringByTrimmingNullCharacters;

+ (NSString *)toBinary:(NSInteger)input;//10进制（数字）转2进制（字符串）
+ (NSString *)byteToString:(NSData *)data;//2进制（data）转16进制（字符串）
+ (NSString *)toHex:(NSInteger)input;//10进制（数字）转16进制（字符串）
- (NSData *)hexStringToByte;//16进制（字符串）转2进制（data）
- (NSArray *)componentsSeparatedByLength:(int)length;//根据长度拆分字符
- (NSString *)transformToBinaryByHex;//16进制（字符串）转2进制（字符串）

- (BOOL)isIncludeChCharacter;//判读是否包含中文字符
- (BOOL)isPureEn;//判断是否为全英文
- (NSString *)hexToAsc2;//16进制转asc2
+ (NSString *)hexByte:(NSInteger)input;


- (CGSize)zxsizeWithFont:(UIFont *)font size:(CGSize)size;
- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size;
- (CGSize)singleLineSizeWithFont:(UIFont *)font;
- (CGSize)zxsizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)zxsizeWithFont:(UIFont *)font;
- (CGSize)zxdrawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode color:(UIColor *)color;
- (CGSize)zxdrawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment;
- (CGSize)zxdrawInRect:(CGRect)rect withFont:(UIFont *)font;
- (CGSize)zxdrawInRect:(CGRect)rect withFont:(UIFont *)font withTextColor:(UIColor *)color;
- (CGSize)zxdrawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;
- (CGSize)zxdrawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment withTextColor:(UIColor *)color;
@end
