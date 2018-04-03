//
//  UIColor+Omesoft.h
//  
//
//  Created by sincan on 12-10-30.
//  Copyright (c) 2012年 Omesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Omesoft)
+ (UIColor *)colorWithHexString:(NSString *)string alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;
- (NSString *)hexRGB;
@end
