//
//  UIDevice+Omesoft.h
//  Hypnotist
//
//  Created by omesoft on 15/7/10.
//  Copyright (c) 2015年 Omesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AudioRoute) {
    AudioRouteHeadset = 0,
    AudioRouteHeadphone,
    AudioRouteSpeaker,
    AudioRouteSpeakerAndMicrophone,
    AudioRouteHeadphonesAndMicrophone,//外设耳机 + 手机麦克风
    AudioRouteHeadsetInOut,//外设耳机 + 外设麦克风
    AudioRouteReceiverAndMicrophone,//手机
    AudioRouteLineout,
    AudioRouteUnknow
};

@interface UIDevice (Omesoft)


+ (AudioRoute)audioRouteSate;
+ (NSString *)deviceModel;
@end
