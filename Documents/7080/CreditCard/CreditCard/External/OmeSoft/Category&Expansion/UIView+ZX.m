//
//  UIView+ZX.m
//  Hypnotist
//
//  Created by omesoft on 15/9/2.
//  Copyright (c) 2015年 Omesoft. All rights reserved.
//

#import "UIView+ZX.h"
#import "OMESoft.h"

@implementation UIView (ZX)

+ (void)zxAnimateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    if (IOS7) {
        [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:dampingRatio initialSpringVelocity:velocity options:options animations:animations completion:completion];
    } else {
        [UIView animateWithDuration:duration delay:delay options:options animations:animations completion:completion];
    }
}
@end
