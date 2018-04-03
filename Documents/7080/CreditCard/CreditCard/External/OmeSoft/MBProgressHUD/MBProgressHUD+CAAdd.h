//
//  MBProgressHUD+CAAdd.h
//  Infanette
//
//  Created by Roc on 2016/12/23.
//  Copyright © 2016年 omesoft. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (CAAdd)


+(void)showDelay : (NSString *)msg toView :(UIView *)view;

+(void)showMessage:(NSString *)msg delay:(NSTimeInterval)delay toView :(UIView *)view completionBlock:(void(^)()) completionBlock;

+(void)showAlertView :(NSString *)title withMsg:(NSString *)msg;

+(MBProgressHUD*)showProgressWithTitle :(UIView *)view title:(NSString *)title;

+(void)showProgress:(UIView *)view;

+ (MBProgressHUD *)showMessageWithActivityIndicator:(NSString *)message toView:(UIView *)view;

+(void)closeProgress;
+ (void)hideHUD;
+(void)showDelayWithMsg:(NSString *)msg toView:(UIView *)view withTime : (NSTimeInterval)time;
+ (void)hideHUDForView:(UIView *)view;
+(MBProgressHUD*)showSuccess:(NSString*) msg toView:(UIView*)view;
+(MBProgressHUD*)showSuccess:(NSString*) msg toView:(UIView*)view completionBlock:(void(^)()) completionBlock;
+(void)showSuccess:(NSString*) msg;

+(void)showError:(NSString*) msg toView:(UIView*)view;
+(void)showError:(NSString*) msg;
+(void)showError:(NSString*) msg completionBlock:(void(^)()) completionBlock;
+(void)showError:(NSString*) msg toView:(UIView*)view completionBlock:(void(^)()) completionBlock;

+ (MBProgressHUD *)showMessage:(NSString *)message;

- (void)showSuccessWithMessage:(NSString*)message
                    afterDelay:(NSTimeInterval)afterDelay
               completionBlock:(void(^)()) completionBlock;

- (void)showSuccessWithMessage:(NSString*)message
               completionBlock:(void(^)()) completionBlock;

- (void)showErrorWithMessage:(NSString*)message
                    afterDelay:(NSTimeInterval)afterDelay
               completionBlock:(void(^)()) completionBlock;

- (void)showErrorWithMessage:(NSString*)message
             completionBlock:(void(^)()) completionBlock;

- (void)showErrorWithTitle:(NSString*)title
                   message:(NSString*)message
           completionBlock:(void(^)()) completionBlock;

#pragma mark - Error

+ (void)showErrorWithTitle:(NSString*)title
                   message:(NSString*)message
                    toView:(UIView*)view
           completionBlock:(void(^)()) completionBlock;

+ (void)showErrorWithTitle:(NSString*)title
                   message:(NSString*)message
                    toView:(UIView*)view
                afterDelay:(NSTimeInterval)afterDelay
           completionBlock:(void(^)()) completionBlock;
@end
