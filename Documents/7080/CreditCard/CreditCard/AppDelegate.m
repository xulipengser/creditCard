//
//  AppDelegate.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/5.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarViewController.h"
#import "OMESoft.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import "LoginViewController.h"
#import "UserModel.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"
#import "ViewControllerEx.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = MainScreenCGRect;
    self.window.backgroundColor = [UIColor whiteColor];
    [self setNav];
    
    NSDictionary *userInfoData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoData"];
    if ([userInfoData objectForKey:@"UserID"] > 0) {
        [self loginSuccess];
    } else {
        [self loginVc];
    }
    
    [self configAip];
    [self setupShareSDK];
    // 4.显示window
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Private

- (void)setNav
{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.translucent = NO;
    //设置显示的颜色
    bar.barTintColor = [UIColor colorWithHexString:MainColor];
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:MainColor] size:CGSizeMake(1, 1)]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new]];
    //设置字体颜色
    bar.tintColor = [UIColor whiteColor];
    bar.backIndicatorImage = [UIImage imageNamed:@"back"];
    bar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back"];
    
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [UIViewController load];
    
}

// 登录成功
- (void)loginSuccess
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MyTabBarViewController *tabarVC = [story instantiateViewControllerWithIdentifier:@"MyTabBarViewController"];
    self.window.rootViewController = tabarVC;
}

// 跳转到登录页面
- (void)loginVc
{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfoData"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:loginVC];
}


- (void)configAip
{
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    if(!licenseFileData) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"授权失败" message:@"授权文件不存在" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Cancel Action");
        }];
        [alertController addAction:cancelAction];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];

}

/**
 初始化ShareSDK
 */
- (void)setupShareSDK
{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeWechat)] onImport:^(SSDKPlatformType platformType) {
                                            switch (platformType)
                                            {
                                                case SSDKPlatformTypeWechat:
                                                    [ShareSDKConnector connectWeChat:[WXApi class]];
                                                    break;
                                                default:
                                                    break;
                                            }
                                            
                                        } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                            switch (platformType)
                                            {
                                                case SSDKPlatformTypeWechat:
                                                    [appInfo SSDKSetupWeChatByAppId:@"wx336d93019eb5828e"
                                                                          appSecret:@"edc9e64622cb4f79c026c5ac7f28ff54"];
                                                    break;
                                                default:
                                                    break;
                                            }
                                        }];
}

@end
