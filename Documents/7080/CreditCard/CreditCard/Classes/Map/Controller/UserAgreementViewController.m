//
//  UserAgreementViewController.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/28.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()

@end

@implementation UserAgreementViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"用户协议";
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.title = @"用户协议";
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    self.url = [NSURL URLWithString:@"http://www.7080pay.cn/UserAgreement/UserAgreement.html"];
    [super viewDidLoad];
}

@end
