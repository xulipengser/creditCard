//
//  UIView+ZX.h
//  Hypnotist
//
//  Created by omesoft on 15/9/2.
//  Copyright (c) 2015年 Omesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZX)

+ (void)zxAnimateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
@end
