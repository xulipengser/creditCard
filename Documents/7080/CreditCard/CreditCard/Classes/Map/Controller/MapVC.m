//
//  MapVC.m
//  StarCityUnion
//
//  Created by 廖智尧 on 2017/11/25.
//  Copyright © 2017年 廖智尧. All rights reserved.
//

#import "MapVC.h"
#import "NBLWebViewController.h"

@interface MapVC ()
@end

@implementation MapVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_type == 1) {
        self.navigationItem.title = @"极速还款";
    }else{
        self.navigationItem.title = @"完美还款";
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    NSString*urlStr = [NSString stringWithFormat:@"http://www.7080pay.cn/page/UserLogin.aspx?uid=%@&Signature=&type=%ld",_userID,(long)_type];
    self.url = [NSURL URLWithString:urlStr];
    [super viewDidLoad];
}

@end
