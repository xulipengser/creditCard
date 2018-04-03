//
//  HomeViewController.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/5.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "HomeViewController.h"
#import "OMESoft.h"
#import "RealNameAuthViewController.h"
#import "HomeCustomCell.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property(nonatomic, strong) UIView *topBarView;
@property(nonatomic, strong) NSMutableArray *imgList;
@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.creditCardTestBtn.layer.cornerRadius = 10;
    self.creditCardTestBtn.layer.masksToBounds = YES;
    self.tableView.bounces = NO;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        CGRect rect = self.tableView.frame;
        self.tableView.frame = CGRectMake(rect.origin.x, -20, rect.size.width, rect.size.height);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topBarView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _btn1.titleEdgeInsets = UIEdgeInsetsMake(_btn1.imageView.frame.size.height, -_btn1.imageView.frame.size.width, 0, 0);
    _btn1.imageEdgeInsets = UIEdgeInsetsMake(-_btn1.titleLabel.bounds.size.height-5, 0, 0, -_btn1.titleLabel.bounds.size.width);
    
    _btn2.titleEdgeInsets = UIEdgeInsetsMake(_btn2.imageView.frame.size.height, -_btn2.imageView.frame.size.width, 0, 0);
    _btn2.imageEdgeInsets = UIEdgeInsetsMake(-_btn2.titleLabel.bounds.size.height-5, 0, 0, -_btn2.titleLabel.bounds.size.width);
    
    _btn3.titleEdgeInsets = UIEdgeInsetsMake(_btn3.imageView.frame.size.height, -_btn3.imageView.frame.size.width, 0, 0);
    _btn3.imageEdgeInsets = UIEdgeInsetsMake(-_btn3.titleLabel.bounds.size.height-5, 0, 0, -_btn3.titleLabel.bounds.size.width);
    
    _btn4.titleEdgeInsets = UIEdgeInsetsMake(_btn4.imageView.frame.size.height, -_btn4.imageView.frame.size.width, 0, 0);
    _btn4.imageEdgeInsets = UIEdgeInsetsMake(-_btn4.titleLabel.bounds.size.height-5, 0, 0, -_btn4.titleLabel.bounds.size.width);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"y:%f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y) {
        
    }
    self.topBarView.alpha =  scrollView.contentOffset.y*0.02;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCustomCell"];
    cell.homeImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad%ld", indexPath.section+1]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 148;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Get

- (NSMutableArray *)imgList
{
    if (_imgList == nil) {
        _imgList = [NSMutableArray array];
        [_imgList addObject:[UIImage imageNamed:@"top1"]];
        [_imgList addObject:[UIImage imageNamed:@"top2"]];
        [_imgList addObject:[UIImage imageNamed:@"top3"]];
        [_imgList addObject:[UIImage imageNamed:@"top4"]];
        [_imgList addObject:[UIImage imageNamed:@"top5"]];
    }
    return _imgList;
}

- (UIView *)topBarView
{
    if (_topBarView == nil) {
        _topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, 80)];
        _topBarView.backgroundColor = [UIColor colorWithHexString:@"#4868CA"];
        
        CGFloat X = 10;
        CGFloat WH = 45;
        CGFloat Y = 25;
        for (int i=0; i<5; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(X+i*(WH+X), Y, WH, WH)];
            btn.tag = i;
            [btn setImage:self.imgList[i] forState:UIControlStateNormal];
            [_topBarView addSubview:btn];
        }
        _topBarView.alpha = 0.0;
    }
    return _topBarView;
}

@end
