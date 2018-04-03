//
//  UIImage+Omesoft.h
//  
//
//  Created by sincan on 12-9-5.
//  Copyright (c) 2012年 Omesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define Retina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 0), CGSizeMake([[UIScreen mainScreen] currentMode].size.width, 0)) : NO)

@interface UIImage (Omesoft)
+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size;

+ (UIImage *)createRoundImageWithColor:(UIColor *)color;
+ (UIImage *)roundImageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)badgeImageWithRadius:(CGFloat)raduis size:(CGSize)size color:(UIColor *)color;
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)gradientImageWithStartColor:(UIColor *)sColor endColor:(UIColor *)eColor height:(float)height;
+ (UIImage *)addHalfOfBlackMaskWithImageName:(NSString *)imageName;
+ (UIImage*)addHalfOfBlackMaskWithImage:(UIImage*)startImage;
+ (UIImage *)scaleImage:(UIImage *)img ToSize:(CGSize)size;
- (UIImage*)addMaskImage:(UIImage*)startImage;
- (UIImage *)addImgeToUpper:(UIImage *)uperImage;
- (UIImage *)addImagToFrameImage:(UIImage *)img rect:(CGRect)rect;

- (UIImage *)fillColor:(UIColor *)fillColor;
- (UIImage*)fillColor:(UIColor *)fillColor backgroundColor:(UIColor*)bgColor;
- (UIColor *)colorAtPixel:(CGPoint)point;
+ (UIImage *)roundImageWithDiameter:(float)px;
- (UIImage*)addRound;
@end
