//
//  AccountUpdateViewController.m
//  CreditCard
//
//  Created by cass on 2018/3/25.
//  Copyright © 2018年 廖智尧. All rights reserved.
//
#import "AccountUpdateCell.h"
#import "AccountUpdateViewController.h"
#import "AccountUpdateModel.h"
#import "PayForBankCardVC.h"
@interface AccountUpdateViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation AccountUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"立即升级";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    _dataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.tableView];
    for (RankInfo* rankinfo in _rankInfoList) {
        if (rankinfo.SortCode.intValue > _rankInfo.SortCode.intValue) {
            AccountUpdateModel* model = [[AccountUpdateModel alloc]init];
            model.price = rankinfo.UpGradeBrokerage.floatValue;
            model.currentMember = _rankInfo.RankName;
            model.updateMember = rankinfo.RankName;
            model.UpGradeRankID = rankinfo.Id;
            [_dataSource addObject:model];
            
        }
    }
    
    if(_dataSource.count == 0){
        NSString* str = [NSString stringWithFormat:@"您已是%@",_rankInfo.RankName];
        [MBProgressHUD showProgressWithTitle:str message:nil duration:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
}

#pragma mark - GET

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5 * HPFrameRatioWidth, 0, MainScreenCGRect.size.width - 2 * 5 * HPFrameRatioWidth, MainScreenCGRect.size.height - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
//        _tableView.contentInset = UIEdgeInsetsMake(8.5, 22.5 * HPFrameRatioWidth, 0, -22.5 * HPFrameRatioWidth);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[AccountUpdateCell class] forCellReuseIdentifier:@"AccountUpdateCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 121.5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountUpdateCell"];
    cell.model = _dataSource[indexPath.section];
    cell.didClickPayBlock = ^(AccountUpdateModel *model, UITableViewCell *cell) {
        PayForBankCardVC* vc = [[PayForBankCardVC alloc]init];
        vc.model = _dataSource[indexPath.section];
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 8.5;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
@end
