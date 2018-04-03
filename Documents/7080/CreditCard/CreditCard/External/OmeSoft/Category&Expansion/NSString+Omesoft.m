//
//  NSString+Omesoft.m
//  MediXPub
//
//  Created by Omesoft on 12-11-22.
//  Copyright (c) 2012年 Omesoft. All rights reserved.
//

#import "NSString+Omesoft.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>
#import "OMESoft.h"

@implementation NSString (Omesoft)

+ (NSString*)idCardToAsterisk:(NSString *)idCardNum

{
    
    NSInteger length = idCardNum.length;
    
    return [idCardNum stringByReplacingCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
    
}

+ (NSString*)bankCardToAsterisk:(NSString *)bankCardNum

{
    
    NSInteger length = bankCardNum.length;
    
    return [bankCardNum stringByReplacingCharactersInRange:NSMakeRange(6, length-4-6) withString:@"********"];
    
}

+ (NSString *)userNameToAsterisk:(NSString *)realName

{
    
    NSInteger length = realName.length;
    
    return [realName stringByReplacingCharactersInRange:NSMakeRange(length-1,1) withString:@"*"];
    
}

+ (NSString *)investPersonNameToAsterisk:(NSString *)personName

{
    
    NSInteger length = personName.length;
    
    if (length == 11) {
        
        return [personName stringByReplacingCharactersInRange:NSMakeRange(3,length-7) withString:@"****"];
        
    }
    
    else if (length >= 5 && length < 11)
        
    {
        
        return [personName stringByReplacingCharactersInRange:NSMakeRange(3,length-3) withString:@"****"];
        
    }
    
    else
        
    {
        
        return [personName stringByReplacingCharactersInRange:NSMakeRange(1,length-1) withString:@"****"];
        
    }
    
}

#pragma mark - NSDate
- (NSDate *)stringWihtDateFormat:(NSString*)dateFormat
{
    return [self stringWihtDateFormat:dateFormat timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"] locale:[NSLocale systemLocale]];
}

- (NSDate *)stringWihtDateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timezone locale:(NSLocale *)locale
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timezone];
    [formatter setLocale:locale];
    [formatter setDateFormat:dateFormat];
    NSDate *date = [formatter dateFromString:self];
    return date;
}

#pragma mark - JSON
+ (NSString *)jsonStringWithString:(NSString *)str
{
    return [NSString stringWithFormat:@"\"%@\"",[[str stringByReplacingOccurrencesOfString:@"\n"withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]];
    
}

+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dic
{
    NSArray *keys = [dic allKeys];
    NSString *result = @"{";
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 0; i < [keys count];  i++) {
        NSString *key = [keys objectAtIndex:i];
        id ob = [dic  objectForKey:key];
        NSString *value = [self jsonStringWithObject:ob];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"\"%@\":%@",key,value]];
        }
        
    }
    result = [result stringByAppendingFormat:@"%@",[values componentsJoinedByString:@","]];
    result = [result stringByAppendingFormat:@"}"];
    return result;
}

+ (NSString *)jsonStringWithArray:(NSArray *)array
{
    NSMutableArray *values = [NSMutableArray array];
    NSString *result = @"[";
    for (id ob in array) {
        NSString *value = [self jsonStringWithObject:ob];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    result = [result stringByAppendingFormat:@"%@",[values componentsJoinedByString:@","]];
    result = [result stringByAppendingFormat:@"]"];
    return result;
}

+ (NSString *)jsonStringWithObject:(id)object
{
    if (!object) {
        return nil;
    }
    if ([object isKindOfClass:[NSString class]]) {
        return [self jsonStringWithString:object];
    }else if([object isKindOfClass:[NSArray class]]){
        return [self jsonStringWithArray:object];
    }else if ([object isKindOfClass:[NSDictionary class]]){
        return [self jsonStringWithDictionary:object];
    }else{
        return object;
    }
}

#pragma mark - URL
- (NSString *)URLEncodedString
{
    
    CFStringRef strRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8);
    
    NSString *encodedString = [NSString stringWithFormat:@"%@", (__bridge NSString *)strRef];
    CFRelease(strRef);
    return encodedString;
    
}

- (NSString *)URLDecodedString
{
    CFStringRef strRef = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 (CFStringRef)@"",
                                                                                 kCFStringEncodingUTF8);
    NSString *encodedString = (__bridge NSString *)strRef;
    CFRelease(strRef);
    return encodedString;
}

#pragma mark - Function
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点型
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}


- (NSString *)stringByTrimmingNullCharacters
{
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"null"]) {
        return nil;
    }else{
        return self;
    }
}

+ (NSString *)md5:(NSString *)string
{
//    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    //使用GBK编码
//    const char *cStr = [string cStringUsingEncoding:gbkEncoding];
////    const char *cStr = [string UTF8String];
//    unsigned char result[16];
//    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
//    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
    
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return result;
}

- (NSString *)MD5
{
    return [[NSString md5:self] lowercaseString];
}

- (NSString *)MD5Upper
{
    return [[NSString md5:self] uppercaseString];
}


#pragma mark - Hex Binary Ten
+ (NSString *)toBinary:(NSInteger)input
{
    if (input == 1 || input == 0) {
        return [NSString stringWithFormat:@"%ld", (long)input];
    }
    else {
        return [NSString stringWithFormat:@"%@%ld", [self toBinary:input / 2], (long)input % 2];
    }
}

- (NSString *)transformToBinaryByHex
{
    int value =  [[NSString stringWithFormat:@"%lu",strtoul([self UTF8String], 0, 16)] intValue];
    NSString *result = [NSString toBinary:value];
    while ([result length] != [self length] * 4) {
        result = [NSString stringWithFormat:@"0%@",result];
    }
    return result;
    
}

+ (NSString *)byteToString:(NSData *)data
{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr = @"";
    
    for (int i=0;i<[data length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i]&0xff];///16进制数
        if ([newHexStr length] == 1) {
            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];
        } else {
            hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
        }
    }
    return hexStr;
}

+ (NSString *)toHex:(NSInteger)input
{
    if (input < 16) {
        return [NSString toTheHex:input];
    }
    else {
        return [NSString stringWithFormat:@"%@%@", [NSString toHex:input / 16], [NSString toTheHex:(input % 16)]];
    }
}

+ (NSString *)toTheHex:(NSInteger)input
{
    if (input >= 16) {
        return nil;
    }
    NSString *result = nil;
    switch (input) {
        case 10:
            result = @"A";
            break;
        case 11:
            result = @"B";
            break;
        case 12:
            result = @"C";
            break;
        case 13:
            result = @"D";
            break;
        case 14:
            result = @"E";
            break;
        case 15:
            result = @"F";
            break;
        default:
            result = [NSString stringWithFormat:@"%ld",(long)input];
            break;
    }
    return result;
}

- (NSData *)hexStringToByte
{
    NSString *hexString=[[self uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

- (NSArray *)componentsSeparatedByLength:(int)length
{
    int startX = 0;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    while ([self length] >= startX + length) {
        NSString *aStr = [self substringWithRange:NSMakeRange(startX, length)];
        [result addObject:aStr];
        startX += length;
    }
    return result;
}

- (BOOL)isIncludeChCharacter
{
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fff)
            return YES;
    }
    return NO;
}

- (BOOL)isPureEn
{
    NSString *regex =@"[a-z][A-Z]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isPureEnAndNumber
{
    NSString *regex =@"[a-z][A-Z][0-9]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isIpAdress
{
    NSString *regex = @"^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *regex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

-(BOOL)isPhoneNumber
{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}

- (NSString *)hexToAsc2
{
    if (self.length % 2 == 0) {
        NSString *result = @"";
        for (int i = 0; i < self.length / 2; i++) {
            NSString *hexStr = [self substringWithRange:NSMakeRange(i * 2, 2)];
            int value =  [[NSString stringWithFormat:@"%lu",strtoul([hexStr UTF8String], 0, 16)] intValue];
            result = [result stringByAppendingString:[NSString stringWithFormat:@"%c",value]];
        }
        return result;
    }
    return nil;
//    [self characterAtIndex:0]; asc2
}

+ (NSString *)hexByte:(NSInteger)input
{
    NSString *result = [NSString toHex:input];
    if (result.length % 2 != 0) {
        result = [NSString stringWithFormat:@"0%@",result];
    }
    return result;
}


#pragma mark - Size

- (CGSize)zxsizeWithFont:(UIFont *)font size:(CGSize)size
{
    if (!font) return CGSizeZero;
    if (IOS7) {
        return  [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font } context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        return [self sizeWithFont:font constrainedToSize:size];
#pragma clang diagnostic pop
    }
}

- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size
{
    if (self.length <= 0) {
        return CGSizeZero;
    }
    NSAttributedString *attstring = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName: font}];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attstring);
    CGSize targetSize = CGSizeMake(320, CGFLOAT_MAX);
    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [self length]), NULL, targetSize, NULL);
    CFRelease(framesetter);
    return fitSize;
}

- (CGSize)singleLineSizeWithFont:(UIFont *)font
{
    if (self.length <= 0) {
        return CGSizeZero;
    }
    CGSize size;
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0) {
        size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
        if (version >= 9) {//IOS9 下计算高度偏高
            size.height = font.pointSize + 2;
        }
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        size = [self sizeWithFont:font];
#pragma clang diagnostic pop
    }
    return size;
}

- (CGSize)zxsizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self boundingRectWithSize:size options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil].size;
}

- (CGSize)zxsizeWithFont:(UIFont *)font
{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (CGSize)zxdrawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode color:(UIColor *)color
{
    NSMutableParagraphStyle *paragrap = [[NSMutableParagraphStyle alloc] init];
    [paragrap setLineBreakMode:lineBreakMode];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (font) [dic setObject:font forKey:NSFontAttributeName];
    if (paragrap)  [dic setObject:paragrap forKey:NSParagraphStyleAttributeName];
    if (color) [dic setObject:color forKey:NSForegroundColorAttributeName];
    [self drawInRect:CGRectMake(point.x, point.y, width, INT_MAX) withAttributes:dic];
    return CGSizeZero;
}

- (CGSize)zxdrawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
{
    NSMutableParagraphStyle *paragrap = [[NSMutableParagraphStyle alloc] init];
    [paragrap setLineBreakMode:lineBreakMode];
    // Create text attributes
    NSDictionary *textAttributes = @{NSFontAttributeName: font,NSParagraphStyleAttributeName:paragrap};
    
    // Create string drawing context
    NSStringDrawingContext *drawingContext = [[NSStringDrawingContext alloc] init];
    drawingContext.minimumScaleFactor = minFontSize / font.pointSize; // Half the font size
    
    CGRect drawRect = CGRectMake(point.x, point.y, width, INT_MAX);
    [self drawWithRect:drawRect
               options:NSStringDrawingUsesLineFragmentOrigin
            attributes:textAttributes
               context:drawingContext];
    return CGSizeZero;
}

- (CGSize)zxdrawInRect:(CGRect)rect withFont:(UIFont *)font
{
    [self drawInRect:rect withAttributes:@{NSFontAttributeName:font}];
    return CGSizeZero;
}

- (CGSize)zxdrawInRect:(CGRect)rect withFont:(UIFont *)font withTextColor:(UIColor *)color
{
    [self drawInRect:rect withAttributes:@{NSFontAttributeName:font,  NSForegroundColorAttributeName:color}];
    return CGSizeZero;
}

- (CGSize)zxdrawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *paragrap = [[NSMutableParagraphStyle alloc] init];
    [paragrap setLineBreakMode:lineBreakMode];
    [paragrap setAlignment:alignment];
    [self drawInRect:rect withAttributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragrap}];
    return CGSizeZero;
    
}

- (CGSize)zxdrawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment withTextColor:(UIColor *)color
{
    NSMutableParagraphStyle *paragrap = [[NSMutableParagraphStyle alloc] init];
    [paragrap setLineBreakMode:lineBreakMode];
    [paragrap setAlignment:alignment];
    [self drawInRect:rect withAttributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragrap,NSForegroundColorAttributeName:color}];
    return CGSizeZero;
    
}


@end
