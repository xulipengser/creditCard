//
//  MBProgressHUD+ZX.h
//  Hypnotist
//
//  Created by omesoft on 15/10/27.
//  Copyright © 2015年 Omesoft. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (ZX)

+ (MBProgressHUD *)showProgressWithTitle:(NSString *)title message:(NSString *)msg duration:(CGFloat)duration;

+ (MBProgressHUD *)showIndeterminateProgressWithMessage:(NSString *)msg duration:(CGFloat)duration;
@end
