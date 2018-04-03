//
//  LoginViewController.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/22.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "RegisteVC.h"
#import "DealPasswordViewController.h"
#import "BackPassWordVC.h"
@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.loginBtn.layer.cornerRadius = 24;
    self.loginBtn.layer.masksToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.accountTextField.text = @"15812724811";
//    self.pwdTextField.text = @"123456";
}

#pragma mark - Private

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.accountTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
}

#pragma mark - Action

- (IBAction)registered {
    RegisteVC *mapVc = [[RegisteVC alloc] init];
    mapVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapVc animated:YES];
    
}

- (IBAction)reSetPassword {
    BackPassWordVC *mapVc = [[BackPassWordVC alloc] init];
    mapVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapVc animated:YES];
}



- (void)showAnimationInfoView:(UIView *)view
{
    if (view) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.window addSubview:view];
        view.transform = CGAffineTransformMakeScale(0.1,0.1);
        [UIView animateWithDuration:0.8 animations:^{
            view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.5 animations:^{
                view.alpha = 0.99;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.8 animations:^{
                    view.alpha = 0;
                } completion:^(BOOL finished) {
                    [view removeFromSuperview];
                }];
            }];
        }];
    }
}

- (IBAction)showAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.isSelected;
    self.pwdTextField.secureTextEntry = !btn.selected;
}

- (void)getUserInfoByUserId:(NSString *)userId
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [parametersDict setObject:userId forKey:@"UserID"];
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr POST:GetUserInfoURL parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
//            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dataDict];
//            [data setObject:@"" forKey:@"Address"];
//            [data setObject:@"" forKey:@"Email"];
            [[NSUserDefaults standardUserDefaults] setObject:dataDict forKey:@"userInfoData"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [NSNotificationCenter.defaultCenter postNotificationName:UserInfoUpdateNotification object:NULL];
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate loginSuccess];
        } else {
            NSString *msg = [dict objectForKey:@"RespMsg"];
            [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:1.0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

- (IBAction)loginAction:(id)sender {
    
    if (self.accountTextField.text.length != 11) {
        [MBProgressHUD showProgressWithTitle:@"提示" message:@"手机号码格式不正确" duration:1.0];
        return;
    } else if (self.pwdTextField.text.length <= 0) {
        [MBProgressHUD showProgressWithTitle:@"提示" message:@"密码不能为空" duration:1.0];
        return;
    }
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [parametersDict setObject:self.accountTextField.text forKey:@"Mobile"];
    [parametersDict setObject:self.pwdTextField.text.MD5 forKey:@"Password"];
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr POST:CheckinURL parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            NSString *userId = [dataDict objectForKey:@"UserID"];
            [self getUserInfoByUserId:userId];
        } else {
            NSString *msg = [dict objectForKey:@"RespMsg"];
            [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:1.0];
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0) {
        [self.pwdTextField becomeFirstResponder];
    } else {
        [self.pwdTextField resignFirstResponder];
    }
    return YES;
}

@end
