//
//  MyTabBarViewController.m
//  MyNewWeibo
//
//  Created by LiaoZhiyao on 15/9/11.
//  Copyright (c) 2015年 LiaoZhiyao. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "OMESoft.h"

@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabbar];
//    [self setNav];
}

- (void)setTabbar
{
    self.tabBar.backgroundImage = [self imageWithColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    self.tabBar.translucent = NO;
    [self setTabBarViewImg];
}

- (void)setNav
{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.translucent = NO;
    //设置显示的颜色
    bar.barTintColor = [UIColor colorWithHexString:MainColor];
    //设置字体颜色
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)setTabBarViewImg
{
    NSArray *itemImageArray = @[@"tab_0",@"tab_1",@"tab_2",@"tab_3"];
    NSArray *itemSelectImageArray = @[@"tab_0_sel",@"tab_1_sel",@"tab_2_sel",@"tab_3_sel"];
    NSArray *itemTitleArray = @[@"首页", @"授信", @"分享", @"我的"];

    NSArray *itemArray = self.tabBar.items;
    for (NSInteger i = 0; i < itemArray.count; i++) {
        UITabBarItem *item = itemArray[i];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:MainColor]} forState:UIControlStateSelected];
        item.image = [UIImage imageNamed:itemImageArray[i]];
        item.selectedImage = [[UIImage imageNamed:itemSelectImageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.title = itemTitleArray[i];
    }
}

#pragma mark - Action


#pragma mark - Private

- (UIImage *)drawTabBarItemBackgroundImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    CGContextSetFillColorWithColor(ctx, backgroundColor.CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
