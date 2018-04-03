//
//  OMESoft.h
//  
//
//  Created by sincan on 12-9-26.
//
//

#import "NSDate_Omesoft.h"
#import "UIImage+Omesoft.h"
#import "UIColor+Omesoft.h"
#import "NSString+Omesoft.h"
#import "UIDevice+Omesoft.h"
#import "NSArray+Extension.h"
#import "UIFont+ZX.h"
#import "UIView+ZX.h"
#import "NSMutableAttributedString+ZX.h"
#import "MBProgressHUD+ZX.h"
#import <UIKit/UIKit.h>

#define AppId 1601

#define LoginAccountKey @"LoginAccountKey"
#define TouchIDKey @"TouchIDKey"

#define viewOrignY (IOS7 ? 80 : 60)

#define audioDBName @"Audio"
#define AudioMixDBName @"MixAudio.db"
#define UserLocalMusicTableName @"UserLocalMusic"
#define LocalBBTShareURLTableName @"LocalBBTShareURL"

#define updataMixAudioArrayNSNotification @"updataMixAudioArrayNSNotification"
#define showLoginViewNSNotification @"showLoginViewNSNotification"
#define audioPlayStateNSNotification @"audioPlayStateNSNotification"
#define audioPlayNSNotification @"audioPlayNSNotification"
#define audioPauseNSNotification @"audioPauseNSNotification"
#define audioStopNSNotification @"audioStopNSNotification"
#define shareAPPNotification @"shareAPPNotification"
#define ChangetimeNSNotification @"ChangetimeNSNotification"
#define CustomBBTStopPlayAllAudioNSNotification @"CustomBBTStopPlayAllAudioNSNotification"
#define CustomBBTReLoadLocalMusicNSNotification @"CustomBBTReLoadLocalMusicNSNotification"

//App Define
#define kAppThemeColor [UIColor colorWithRed:93/255.0 green:162/255.0 blue:88/255.0 alpha:1]
#define kNavigationBarHeight 64
#define LZWeakSelf(ws) __weak typeof(self) ws = self;

#define SafeAreaTopHeight (MainScreenCGRect.size.height == 812.0 ? 88 : 64)

#define BarColor @"#000000"
#define MainColor @"#4363C6"
#define BgColor @"#F3F3F3"
#define MainScreenCGRect [[UIScreen mainScreen] bounds]
//3.5寸屏幕
#define iPhone3_5ScreenSize ([[UIScreen mainScreen] bounds].size.height == 480.0 ? YES : NO)
//4寸屏幕
#define iPhone4_0AfterScreenSize ([[UIScreen mainScreen] bounds].size.height == 568.0 ? YES : NO)
//4寸以下的屏幕
#define SCREEN_LESS_IPHONE5 ([[UIScreen mainScreen]bounds].size.height < 568.0 ? YES : NO)
//4寸以上的屏幕
#define SCREEN_LARGER_IPHONE5 ([[UIScreen mainScreen]bounds].size.height > 568.0 ? YES : NO)
//4.7寸屏幕  iPhone6
#define SCREEN_LARGER_IPHONE6 ([[UIScreen mainScreen]bounds].size.height == 667.0 ? YES : NO)
//5.5寸屏幕  iPhone6 Plus
#define SCREEN_LARGER_IPHONE6Plus ([[UIScreen mainScreen]bounds].size.height == 736.0 ? YES : NO)
//系统版本
#define IOS6 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) ? YES : NO)
#define IOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)
#define IOS8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)

// 检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define TIMER_INVA(timer){if ([timer isKindOfClass:[NSTimer class]] && timer) {[timer invalidate];timer = nil;}}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
#define HP_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text boundingRectWithSize:maxSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define HP_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
#define HP_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define HP_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
#define HP_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text boundingRectWithSize:maxSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define HP_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif


#define HPFrameRatioWidth ([[UIScreen mainScreen] bounds].size.width > 375.0f ? [[UIScreen mainScreen] bounds].size.width / 375.0f : 1.0)
#define HPFrameRatioHeight ([[UIScreen mainScreen] bounds].size.height != 667.0f ? [[UIScreen mainScreen] bounds].size.height / 667.0f : 1.0)

#define kSeperatorLineColor [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1]
#define HPTextPadding 20

static inline NSString* random3BitNum()
{
    return [NSString stringWithFormat:@"%d%d%d",arc4random() % 10,arc4random() % 10,arc4random() % 10,nil];
}

static inline NSString* thumbnailImgDirectory()
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docuPath = [searchPaths objectAtIndex: 0];
    NSString *result = [[docuPath stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"thumbnailImg"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithString:result];
    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    return result;
}


static inline NSString* imageDirectory()
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docuPath = [searchPaths objectAtIndex: 0];
    NSString *result = [[docuPath stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"image"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithString:result];
    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    return result;
}

static inline NSString* videoDirectory()
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docuPath = [searchPaths objectAtIndex: 0];
    NSString *result = [[docuPath stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"videos"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithString:result];
    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    return result;
}

static inline NSString* audioDirectory()
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docuPath = [searchPaths objectAtIndex: 0];
    NSString *result = [[docuPath stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"audios"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithString:result];
    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    return result;
}

static inline NSString* tmpDirectory()
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docuPath = [searchPaths objectAtIndex: 0];
    NSString *result = [[docuPath stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"tmp"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithString:result];
    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    return result;
}

static float frame_ratioX = 0;
static float frame_ratioY = 0;
CG_INLINE CGRect
CGRectRatioMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    if (frame_ratioX == 0 || frame_ratioY == 0) {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        if (size.width > 320) {
            frame_ratioX = size.width / 320.0f;
            frame_ratioY = size.height / 568.0f;
        } else {
            frame_ratioX = 1.0;
            frame_ratioY = 1.0;
        }
    }
    CGRect rect;
    rect.origin.x = x * frame_ratioX; rect.origin.y = y * frame_ratioY;
    rect.size.width = width * frame_ratioX; rect.size.height = height * frame_ratioY;
    return rect;
}

CG_INLINE CGRect
CGRectRatioMakeFromRect(CGRect Rect)
{
    if (frame_ratioX == 0 || frame_ratioY == 0) {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        if (size.width > 320) {
            frame_ratioX = size.width / 320.0f;
            frame_ratioY = size.height / 568.0f;
        } else {
            frame_ratioX = 1.0;
            frame_ratioY = 1.0;
        }
    }
    CGRect rect;
    rect.origin.x = Rect.origin.x * frame_ratioX; rect.origin.y = Rect.origin.y * frame_ratioY;
    rect.size.width = Rect.size.width * frame_ratioX; rect.size.height = Rect.size.height * frame_ratioY;
    return rect;
}

CG_INLINE CGSize
CGSizeRatioMake(CGFloat width, CGFloat height)
{
    if (frame_ratioX == 0 || frame_ratioY == 0) {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        if (size.width > 320) {
            frame_ratioX = size.width / 320.0f;
            frame_ratioY = size.height / 568.0f;
        } else {
            frame_ratioX = 1.0;
            frame_ratioY = 1.0;
        }
    }
    CGSize size; size.width = width * frame_ratioX;; size.height = height * frame_ratioY; return size;
}
