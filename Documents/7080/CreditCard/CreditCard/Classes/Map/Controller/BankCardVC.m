//
//  BankCardVC.m
//  StarCityUnion
//
//  Created by 廖智尧 on 2017/11/25.
//  Copyright © 2017年 廖智尧. All rights reserved.
//

#import "BankCardVC.h"
#import "NBLWebViewController.h"

@interface BankCardVC ()
@end

@implementation BankCardVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"信用卡办理";
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationItem.title = @"信用卡办理";
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
//    self.url = [NSURL URLWithString:@"http://www.7080pay.cn/page/CardApplication.aspx"];
    [super viewDidLoad];
}

@end
