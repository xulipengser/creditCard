//
//  RegisteVC.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/28.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "RegisteVC.h"

@interface RegisteVC ()

@end

@implementation RegisteVC


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"用户注册";
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.title = @"用户注册";
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    self.url = [NSURL URLWithString:@"http://www.7080pay.cn/page/register.aspx"];
    [super viewDidLoad];
    
    
    
}

-(void)successAction:(NSString*)title{
    NSLog(@"a");
    if ([title isEqualToString:@"CloseView"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
