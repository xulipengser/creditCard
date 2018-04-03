//
//  MBProgressHUD+CAAdd.m
//  Infanette
//
//  Created by Roc on 2016/12/23.
//  Copyright © 2016年 omesoft. All rights reserved.
//

#import "MBProgressHUD+CAAdd.h"

@implementation MBProgressHUD (CAAdd)

+(void)showAlertView :(NSString *)title withMsg:(NSString *)msg{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

//+(MBProgressHUD*)showProgressWithTitle :(UIView *)view title:(NSString *)title{
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
//    [view addSubview:progress];
//    hud.labelText = title;
//    [hud showAnimated:YES];
//    return hud;
//}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
    return hud;
}

+ (MBProgressHUD *)showMessageWithActivityIndicator:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

- (void)showSuccessWithMessage:(NSString*)message
                    afterDelay:(NSTimeInterval)afterDelay
               completionBlock:(void(^)()) completionBlock {
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.customView = imageView;
    self.mode = MBProgressHUDModeCustomView;
    self.labelText = message;
    self.completionBlock = completionBlock;
    [self hide:YES afterDelay:afterDelay];
}

- (void)showSuccessWithMessage:(NSString *)message
               completionBlock:(void (^)())completionBlock {
    [self showSuccessWithMessage:message afterDelay:1.5 completionBlock:completionBlock];
}





+(void)showMessage:(NSString *)msg
             delay:(NSTimeInterval)delay
            toView:(UIView *)view
   completionBlock:(void (^)())completionBlock {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelFont=[UIFont systemFontOfSize:13.0];
    hud.labelText = msg;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.completionBlock = completionBlock;
    [hud hide:YES afterDelay:delay];
    
}

+ (MBProgressHUD*)showSuccess:(NSString*) msg toView:(UIView*)view completionBlock:(void(^)()) completionBlock {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = msg;
    hud.completionBlock = completionBlock;
    [hud hide:YES afterDelay:1.5];
    return hud;
}


//+ (void)showError:(NSString*) msg toView:(UIView*)view {
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.label.font=[UIFont systemFontOfSize:13.0];
//    hud.detailsLabel.text = msg;
//    UIImage *image = [[UIImage imageNamed:@"alert_error"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    hud.customView = [[UIImageView alloc] initWithImage:image];
//    hud.mode = MBProgressHUDModeCustomView;
//
//    hud.bezelView.color = [UIColor lightGrayColor];
//    hud.removeFromSuperViewOnHide = YES;
//
//    [hud hideAnimated:YES afterDelay:2];
//}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}


+(void)showError:(NSString *)msg {
    [self showError:msg toView:nil];
}

//+(void)showError:(NSString *)msg completionBlock:(void (^)())completionBlock {
//    UIView *view = [[UIApplication sharedApplication].windows lastObject];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.label.font=[UIFont systemFontOfSize:13.0];
//    hud.detailsLabel.text = msg;
//    UIImage *image = [[UIImage imageNamed:@"alert_error"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    hud.customView = [[UIImageView alloc] initWithImage:image];
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.bezelView.color = [UIColor lightGrayColor];
//    hud.removeFromSuperViewOnHide = YES;
//    hud.completionBlock = completionBlock;
//    [hud hideAnimated:YES afterDelay:2];
//}

//+(void)showError:(NSString *)msg toView:(UIView*)view completionBlock:(void (^)())completionBlock {
//    if (!view) {
//        view = [[UIApplication sharedApplication].windows lastObject];
//    }
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.label.font=[UIFont systemFontOfSize:13.0];
//    hud.detailsLabel.text = msg;
//    UIImage *image = [[UIImage imageNamed:@"alert_error"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    hud.customView = [[UIImageView alloc] initWithImage:image];
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.bezelView.color = [UIColor lightGrayColor];
//    hud.removeFromSuperViewOnHide = YES;
//    hud.completionBlock = completionBlock;
//    [hud hideAnimated:YES afterDelay:2];
//}

+ (void)hideHUD {
    [self hideHUDForView:nil];
}

//+(void)showDelayWithMsg:(NSString *)msg toView:(UIView *)view withTime : (NSTimeInterval)time{
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
//    // 快速显示一个提示信息
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.label.font=[UIFont systemFontOfSize:13.0];
//    hud.label.text = msg;
//    // 再设置模式
//    hud.mode = MBProgressHUDModeText;
//    
//    // 隐藏时候从父控件中移除
//    hud.removeFromSuperViewOnHide = YES;
//    
//    [hud hideAnimated:YES afterDelay:time];
//}

#pragma mark - Error

+(void)showError:(NSString *)msg
          toView:(UIView *)view
 completionBlock:(void (^)())completionBlock {
    [MBProgressHUD showErrorWithTitle:@"" message:msg
                               toView:view
                      completionBlock:completionBlock];
}

+ (void)showErrorWithTitle:(NSString *)title
                   message:(NSString *)message
                    toView:(UIView *)view
           completionBlock:(void (^)())completionBlock {
    
    [MBProgressHUD showErrorWithTitle:title
                              message:message
                               toView:view
                           afterDelay:2
                      completionBlock:completionBlock];
    
}

+ (void)showErrorWithTitle:(NSString *)title
                   message:(NSString *)message
                    toView:(UIView *)view
                afterDelay:(NSTimeInterval)afterDelay
           completionBlock:(void (^)())completionBlock {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = title;
    hud.detailsLabelText = message;
    hud.mode = MBProgressHUDModeCustomView;
    hud.completionBlock = completionBlock;
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud show:YES];
    [hud hide:YES afterDelay:afterDelay];
}

- (void)showErrorWithMessage:(NSString*)message
                  afterDelay:(NSTimeInterval)afterDelay
             completionBlock:(void(^)()) completionBlock {
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.customView = imageView;
    self.mode = MBProgressHUDModeCustomView;
    self.labelText = message;
    self.completionBlock = completionBlock;
    [self hide:YES afterDelay:afterDelay];
}

- (void)showErrorWithMessage:(NSString *)message
             completionBlock:(void (^)())completionBlock {
    [self showErrorWithMessage:message afterDelay:1.5 completionBlock:completionBlock];
}

- (void)showErrorWithTitle:(NSString *)title
                   message:(NSString *)message
           completionBlock:(void (^)())completionBlock {
    self.labelText = title;
    self.detailsLabelText = message;
    self.mode = MBProgressHUDModeCustomView;
    self.completionBlock = completionBlock;
    [self show:YES];
    [self setRemoveFromSuperViewOnHide:YES];
    [self hide:YES afterDelay:2.0];
}

@end
