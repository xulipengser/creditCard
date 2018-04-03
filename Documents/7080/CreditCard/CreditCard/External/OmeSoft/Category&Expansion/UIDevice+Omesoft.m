//
//  UIDevice+Omesoft.m
//  Hypnotist
//
//  Created by omesoft on 15/7/10.
//  Copyright (c) 2015年 Omesoft. All rights reserved.
//

#import "UIDevice+Omesoft.h"
#import <AudioToolbox/AudioToolbox.h>
#import "sys/sysctl.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIDevice (Omesoft)


+ (AudioRoute)audioRouteSate;
{
    BOOL isNeedChange = NO;
    NSString *category = [[AVAudioSession sharedInstance] category];
    if (![category isEqualToString:AVAudioSessionCategoryPlayAndRecord]) {
        CFStringRef beforeAudioRoute;
        UInt32 beforePropertySize = sizeof(beforeAudioRoute);
        OSStatus beforeStatus = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &beforePropertySize, &beforeAudioRoute);
        if (beforeStatus == noErr) {
            NSString *audioRoute = (__bridge NSString *)beforeAudioRoute;
            if ([audioRoute isEqualToString:@"Headphone"]) {
                isNeedChange = YES;
            } else {
                return AudioRouteSpeaker;
            }
        }
    }
    
    if (isNeedChange) {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    CFStringRef audioRoute;
    UInt32 propertySize = sizeof(audioRoute);
    OSStatus status = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &audioRoute);
    
    if (status == noErr) {
        NSString *currentaudioRoute = (__bridge NSString *)audioRoute;
        NSLog(@"currentaudioRoute : %@",currentaudioRoute);
        NSArray *routes = [[NSArray alloc] initWithObjects:@"Headset",@"Headphone",@"Speaker",@"SpeakerAndMicrophone",@"HeadphonesAndMicrophone",@"HeadsetInOut",@"ReceiverAndMicrophone",@"Lineout", nil];
        if ([routes containsObject:currentaudioRoute]) {
            return [routes indexOfObject:currentaudioRoute];
        }
        /* Known values of route:
         * "Headset"
         * "Headphone"
         * "Speaker"
         * "SpeakerAndMicrophone"
         * "HeadphonesAndMicrophone"
         * "HeadsetInOut"
         * "ReceiverAndMicrophone"
         * "Lineout"
         */
    }
    return AudioRouteUnknow;
}


+ (NSString *)deviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";// (A1203)
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";// (A1241/A1324)
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";// (A1303/A1325)
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";// (A1332)
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";// (A1332)
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";// (A1349)
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";// (A1387/A1431)
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";// (A1428)
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";// (A1429/A1442)
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";// (A1456/A1532)
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";// (A1507/A1516/A1526/A1529)
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";// (A1453/A1533)
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";// (A1457/A1518/A1528/A1530)
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";// (A1522/A1524)
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";// (A1549/A1586)
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";// (A1213)
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";// (A1288)
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";// (A1318)
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";// (A1367)
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";// (A1421/A1509)
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";// (A1219/A1337)
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";// (A1395)
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";// (A1396)
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";// (A1397)
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";// (A1395+New Chip)
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";// (A1432)
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";// (A1454)
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";// (A1455)
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";// (A1416)
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";// (A1403)
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";// (A1430)
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";// (A1458)
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";// (A1459)
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";// (A1476)
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";// (A1474)
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";// (A1475)
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";// (A1476)
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";// (A1489)
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";// (A1490)
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";// (A1491)
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";//
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";//
    return platform;
}
//NSString * OSStatusToString(OSStatus status)
//{
//    size_t len = sizeof(UInt32);
//    long addr = (unsigned long)&status;
//    char cstring[5];
//    
//    len = (status >> 24) == 0 ? len - 1 : len;
//    len = (status >> 16) == 0 ? len - 1 : len;
//    len = (status >>  8) == 0 ? len - 1 : len;
//    len = (status >>  0) == 0 ? len - 1 : len;
//    
//    addr += (4 - len);
//    
//    status = EndianU32_NtoB(status);        // strings are big endian
//    
//    strncpy(cstring, (char *)addr, len);
//    cstring[len] = 0;
//    
//    return [NSString stringWithCString:(char *)cstring encoding:NSMacOSRomanStringEncoding];
//}
@end
