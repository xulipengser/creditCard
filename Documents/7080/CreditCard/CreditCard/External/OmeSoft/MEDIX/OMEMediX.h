//
//  OMEMediX.h
//  LIBTest
//
//  Created by omesoft on 14-7-29.
//  Copyright (c) 2014年 Xin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMEMediX : NSObject

+ (NSString*) value;

+ (NSString *)DESEncrypt:(NSString *)text WithKey:(NSString *)key;
+ (NSString *)DESDecrypt:(NSString *)text WithKey:(NSString *)key;

+ (NSString *)md5:(NSString *)string;
@end
