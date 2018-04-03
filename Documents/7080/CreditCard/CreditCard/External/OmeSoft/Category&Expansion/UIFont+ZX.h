//
//  UIFont+ZX.h
//  Hypnotist
//
//  Created by omesoft on 15/8/28.
//  Copyright (c) 2015年 Omesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIFont (ZX)
@property (nonatomic , readonly) CGFloat height;

//催眠大师字体
+ (UIFont *)hpFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldHPFontOfSize:(CGFloat)fontSize;

//中文字体
+ (UIFont *)zhsFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldZhsFontOfSize:(CGFloat)fontSize;
@end
