//
//  BillsVC.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/29.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "BillsVC.h"

#import "PayRecordCell.h"
#import "YYKit.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+CAAdd.h"
#import "OrderModel.h"
#import "MJRefresh.h"
#import "BillsInfoVC.h"
@interface BillsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *emptyDataView;
@property (nonatomic) NSInteger currentIndex;
@end

@implementation BillsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"账单";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.emptyDataView];
    
    NSDictionary *userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoData"];
    self.userModel = [UserModel objectWithKeyValues:userInfoDict];
    
    
    [self getOrderList];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private



- (void)getOrderList
{
    NSInteger index = _currentIndex;
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [parametersDict setObject:self.userModel.UserID forKey:@"UserID"];
//    [parametersDict setObject:@"0de73335-a07e-48c9-b32d-693606545002" forKey:@"UserID"];
    
    [parametersDict setObject:[NSNumber numberWithInteger:index] forKey:@"Page"];
    [parametersDict setObject:[NSNumber numberWithInt:10] forKey:@"Rows"];
    
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    NSLog(@"%@",parametersDict);
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 20.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [mgr POST:OrderList parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            if (index == 1)
                [self.dataSource removeAllObjects];
            NSArray *arr = [OrderModel objectArrayWithKeyValuesArray:[dataDict objectForKey:@"OrderList"]];
            [self.dataSource appendObjects:arr];
            [_tableView.mj_header endRefreshing];
            if (arr.count < 10 )
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            else
                [_tableView.mj_footer endRefreshing];
            
            [self.tableView reloadData];
            
        } else {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

#pragma mark - GET

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, MainScreenCGRect.size.width - 20, MainScreenCGRect.size.height - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[PayRecordCell class] forCellReuseIdentifier:@"PayRecordCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // table1
        MJRefreshNormalHeader *header1 = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentIndex = 1;
            [self getOrderList];
        }];
        [header1 setTitle:@"下拉刷新今天交易数据" forState:MJRefreshStateIdle];
        [header1 setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [header1 setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
        header1.lastUpdatedTimeLabel.hidden = YES;
        header1.stateLabel.font = [UIFont systemFontOfSize:13.0f];
        [header1 isAutomaticallyChangeAlpha];
        _tableView.mj_header = header1;
        [_tableView.mj_header beginRefreshing];
        
        MJRefreshAutoNormalFooter *footer1 = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _currentIndex++;
            [self getOrderList];
        }];
        footer1.automaticallyHidden = NO;
        [footer1 setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
        [footer1 setTitle:@"正在加载更多数据..." forState:MJRefreshStateRefreshing];
        [footer1 setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
        footer1.stateLabel.font = [UIFont systemFontOfSize:13.0f];
        _tableView.mj_footer = footer1;
        [_tableView.mj_footer setHidden:NO];
        
    }
    return _tableView;
}

- (UIView *)emptyDataView {
    if (_emptyDataView == nil) {
        _emptyDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, MainScreenCGRect.size.height - 64)];
        _emptyDataView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record_empty"]];
        imageView.size = imageView.image.size;
        imageView.centerX = _emptyDataView.width / 2;
        imageView.bottom = _emptyDataView.height / 2 - 10;
        [_emptyDataView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"无支付记录";
        label.font = [UIFont systemFontOfSize:19];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.size = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                              options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName : label.font}
                                              context:nil].size;
        label.top = _emptyDataView.centerY + 10;
        label.centerX = imageView.centerX;
        [_emptyDataView addSubview:label];
        _emptyDataView.hidden = YES;
    }
    return _emptyDataView;
}


#pragma mark - UITableViewDelegate and UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPayRecordCellHeight;
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
    PayRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayRecordCell"];
    cell.model = _dataSource[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillsInfoVC* vc = [[BillsInfoVC alloc]init];
    vc.model = _dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
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

