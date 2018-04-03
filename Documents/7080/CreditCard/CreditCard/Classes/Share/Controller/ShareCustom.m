//
//  ShareCustom.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/8.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "ShareCustom.h"
#import <ShareSDK/ShareSDK.h>

@implementation ShareCustom

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]
//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

static id _publishContent;//类方法中的全局变量这样用（类型前面加static）

/*
 自定义的分享类，使用的是类方法，其他地方只要 构造分享内容publishContent就行了
 */

+(void)shareWithContent:(id)publishContent/*只需要在分享按钮事件中 构建好分享内容publishContent传过来就好了*/
{
    _publishContent = publishContent;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    blackView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.85];
    blackView.tag = 440;
    [window addSubview:blackView];
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-300*KWidth_Scale)/2.0f, (kScreenHeight-270*KWidth_Scale)/2.0f, 300*KWidth_Scale, 160*KWidth_Scale)];
    shareView.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    shareView.tag = 441;
    [window addSubview:shareView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, shareView.frame.size.width, 45*KWidth_Scale)];
    titleLabel.text = @"分享到";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15*KWidth_Scale];
    titleLabel.textColor = [UIColor colorWithHexString:@"#2a2a2a"];
    titleLabel.backgroundColor = [UIColor clearColor];
    [shareView addSubview:titleLabel];
    
    // 添加按钮1
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, (300 - 20)/2.0, 100)];
    [button setImage:[UIImage imageNamed:@"shareWechat"] forState:UIControlStateNormal];
    [button setTitle:@"微信好友" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11*KWidth_Scale];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:[UIColor colorWithHexString:@"2a2a2a"] forState:UIControlStateNormal];
    button.tag = 1;
    [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleEdgeInsets = UIEdgeInsetsMake(button.imageView.frame.size.height, -button.imageView.frame.size.width, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.bounds.size.height-15, 0, 0, -button.titleLabel.bounds.size.width);
     [shareView addSubview:button];
    
    // 添加按钮2
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(10 + (300 - 20)/2.0, 10, (MainScreenCGRect.size.width - 20)/2.0, 100)];
    [button2 setImage:[UIImage imageNamed:@"ShareFriendsCircle"] forState:UIControlStateNormal];
    [button2 setTitle:@"微信朋友圈" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:11*KWidth_Scale];
    button2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button2 setTitleColor:[UIColor colorWithHexString:@"2a2a2a"] forState:UIControlStateNormal];
    button2.tag = 2;
    [button2 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button2.titleEdgeInsets = UIEdgeInsetsMake(button2.imageView.frame.size.height, -button2.imageView.frame.size.width, 0, 0);
    button2.imageEdgeInsets = UIEdgeInsetsMake(-button2.titleLabel.bounds.size.height-15, 0, 0, -button2.titleLabel.bounds.size.width);
    [shareView addSubview:button2];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake((shareView.frame.size.width-40*KWidth_Scale)/2.0f, CGRectGetMaxY(button2.frame), 40*KWidth_Scale, 40*KWidth_Scale)];
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    cancleBtn.tag = 3;
    [cancleBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancleBtn];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    shareView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    blackView.alpha = 0;
    [UIView animateWithDuration:0.35f animations:^{
        shareView.transform = CGAffineTransformMakeScale(1, 1);
        blackView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)shareBtnClick:(UIButton *)btn
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:440];
    UIView *shareView = [window viewWithTag:441];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    shareView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.35f animations:^{
        shareView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        blackView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
    
    int shareType = 0;
    id publishContent = _publishContent;
    switch (btn.tag) {
        case 1:
        {
            shareType = SSDKPlatformTypeWechat;
            break;
        }
        case 2:
        {
            shareType = SSDKPlatformSubTypeWechatTimeline;
            break;
        }
        default:
            break;
    }
    
    /*
     调用shareSDK的无UI分享类型，
     链接地址：https://bbs.mob.com/forum.php?mod=viewthread&tid=110&extra=page%3D1%26filter%3Dtypeid%26typeid%3D34
     */
    
    [ShareSDK share:shareType parameters:publishContent onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                
                NSLog(@"分享成功！");
                break;
            }
            case SSDKResponseStateFail:
            {
                
                NSLog(@"分享失败！");
                break;
            }
            default:
                break;
        }
        
        
        
    }];
    
}

@end
