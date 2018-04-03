//
//  BaseViewController.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/12.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.barView];
}

#pragma mark - Get

- (UIView *)barView
{
    if (_barView == nil) {
        CGFloat height = MainScreenCGRect.size.height == 884 ? 88 : 64;
        _barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, height)];
        _barView.backgroundColor = [UIColor colorWithHexString:MainColor];
        
        [_barView addSubview:self.backBtn];
        [_barView addSubview:self.titleLbl];
    }
    return _barView;
}

- (UIButton *)backBtn
{
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenCGRect.size.height == 884 ? 44:20, 40, 40)];
        _backBtn.backgroundColor = [UIColor redColor];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_backBtn setTitle:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLbl
{
    if (_titleLbl == nil) {
        CGFloat X = CGRectGetMaxX(self.backBtn.frame);
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(X, MainScreenCGRect.size.height == 884 ? 44:20, MainScreenCGRect.size.width - 2*X, 40)];
        _titleLbl.text = @"test";
    }
    return _titleLbl;
}

@end
