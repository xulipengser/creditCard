//
//  NSURL+ZX.m
//  OMESOFT
//
//  Created by omesoft on 15-1-13.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import "NSURL+ZX.h"

@implementation NSURL (ZX)

- (NSDictionary *)parametersInfo
{
    NSDictionary *result = nil;
    if (self.absoluteString.length <= 0) {
        return nil;
    }
    NSRange range = [self.absoluteString rangeOfString:@"?" options:NSBackwardsSearch];
    if (range.length > 0) {
        NSString *pramStr = [self.absoluteString substringWithRange:NSMakeRange(range.location + 1, self.absoluteString.length - range.location - 1)];
        NSString *currentPramStr = [[pramStr stringByReplacingOccurrencesOfString:@"&" withString:@"\",\""] stringByReplacingOccurrencesOfString:@"=" withString:@"\":\""];
        NSString *jsonStr = [[NSString stringWithFormat:@"{\"%@\"}",currentPramStr] URLDecoded];
        if (jsonStr.length) {
            NSError *jsonError = nil;
            NSDictionary *pramDic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
            if (!jsonError) {
                result = [NSDictionary dictionaryWithDictionary:pramDic];
            }
        }
    }
    return result;
}

- (NSDictionary *)jsonParameters
{
    NSDictionary *result = nil;
    if (self.absoluteString.length <= 0) {
        return nil;
    }
    NSRange range = [self.absoluteString rangeOfString:@"?" options:NSBackwardsSearch];
    if (range.length > 0) {
        NSString *pramStr = [self.absoluteString substringWithRange:NSMakeRange(range.location + 1, self.absoluteString.length - range.location - 1)];
        NSString *jsonStr = [pramStr URLDecoded];
        if (jsonStr && jsonStr.length > 0) {
            NSError *jsonError = nil;
            NSDictionary *pramDic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
            if (!jsonError) {
                result = [NSDictionary dictionaryWithDictionary:pramDic];
            }
        }
    }
    return result;
}

- (BOOL)addSkipBackupAttribute
{
//    assert([[NSFileManager defaultManager] fileExistsAtPath: [self path]]);
    
    NSError *error = nil;
    BOOL success = [self setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [self lastPathComponent], error);
    }
    return success;
}

@end

@implementation NSString (ZX)

- (NSString *)URLDecoded
{
    CFStringRef strRef = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 (CFStringRef)@"",
                                                                                 kCFStringEncodingUTF8);
    NSString *encodedString = [NSString stringWithFormat:@"%@", (__bridge NSString *)strRef];
    CFRelease(strRef);
    return encodedString;
}

@end
