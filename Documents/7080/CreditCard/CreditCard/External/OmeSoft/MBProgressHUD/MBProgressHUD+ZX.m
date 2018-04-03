//
//  MBProgressHUD+ZX.m
//  Hypnotist
//
//  Created by omesoft on 15/10/27.
//  Copyright © 2015年 Omesoft. All rights reserved.
//

#import "MBProgressHUD+ZX.h"

@implementation MBProgressHUD (ZX)

+ (MBProgressHUD *)showProgressWithTitle:(NSString *)title message:(NSString *)msg duration:(CGFloat)duration
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:progressHUD];
    progressHUD.labelText = title;
    progressHUD.detailsLabelText = msg;
    progressHUD.mode = MBProgressHUDModeCustomView;
    [progressHUD show:YES];
    [progressHUD setRemoveFromSuperViewOnHide:YES];
    if (duration > 0) {
        [progressHUD hide:YES afterDelay:duration];
    }
    return progressHUD;
}

+ (MBProgressHUD *)showIndeterminateProgressWithMessage:(NSString *)msg duration:(CGFloat)duration
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:progressHUD];
    progressHUD.labelText = msg;
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    [progressHUD show:YES];
    [progressHUD setRemoveFromSuperViewOnHide:YES];
    if (duration > 0) {
        [progressHUD hide:YES afterDelay:duration];
    }
    return progressHUD;
}
@end
