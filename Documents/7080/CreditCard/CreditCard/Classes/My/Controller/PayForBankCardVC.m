//
//  PayForBankCardVC.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/29.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "PayForBankCardVC.h"
#import "UserModel.h"
#import "MBProgressHUD+CAAdd.h"
#import "DebitCardModel.h"
#import "BankCardTableViewCell.h"
#import "InputPasswordView.h"
#import "CardAddViewController.h"
#import "PayMembersVC.h"
@interface PayForBankCardVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) UserModel *userModel;
@property(nonatomic, strong) InputPasswordView *inputView;
@end

@implementation PayForBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    _dataSource = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.view addSubview:self.tableView];
    
    NSDictionary *userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoData"];
    self.userModel = [UserModel objectWithKeyValues:userInfoDict];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDebitCardList];//借记卡
    self.navigationItem.title = @"选择结算卡";
}

//借记卡列表
- (void)getDebitCardList
{
    MBProgressHUD *hud = [MBProgressHUD showMessageWithActivityIndicator:@"" toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [parametersDict setObject:self.userModel.UserID forKey:@"UserID"];
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 20.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [mgr POST:DebitCardListURL parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            self.dataSource = [DebitCardModel objectArrayWithKeyValuesArray:[dataDict objectForKey:@"DebitCardList"]];
            [self.tableView reloadData];
        } else {
            [hud hide:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

#pragma mark - GET

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, MainScreenCGRect.size.height - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerNib:[UINib nibWithNibName:@"BankCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"BankCardTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


#pragma mark - UITableViewDelegate and UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
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
    BankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BankCardTableViewCell"];
    [cell setDebitCard:(DebitCardModel*)_dataSource[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_inputView == NULL){
        _inputView = [InputPasswordView Load];
        [self.inputView showInView:self.view.window];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.inputView show:^(NSString *password) {
        MBProgressHUD *hud = [MBProgressHUD showMessageWithActivityIndicator:@"" toView:self.view];
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:3];
        [parametersDict setObject:weakSelf.userModel.UserID forKey:@"UserID"];
        
        [parametersDict setObject:weakSelf.model.UpGradeRankID forKey:@"UpGradeRankID"];
        [parametersDict setObject:[NSNumber numberWithFloat:0] forKey:@"CardType"];
        
        DebitCardModel* model = weakSelf.dataSource[indexPath.row];
        [parametersDict setObject:model.DebitCardID forKey:@"BankCardId"];
        
        [parametersDict setObject:password.MD5 forKey:@"TradePassword"];
        [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
        [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        mgr.requestSerializer.timeoutInterval = 10.f;
        [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [mgr POST:UpGrade parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"111");
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
            NSString *RespCode = [dict objectForKey:@"RespCode"];
            if ([RespCode isEqualToString:@"000000"]) {
                NSDictionary *inof = [dict objectForKey:@"Data"];
                NSString* url = [inof objectForKey:@"PayInfo"];
                PayMembersVC* vc = [[PayMembersVC alloc]init];
                vc.url = [NSURL URLWithString:url];
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {
                NSString *msg = [dict objectForKey:@"RespMsg"];
                [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:1.0];
            }
            [hud hide:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
            [hud hide:YES];
        }];
        
    }];
    
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

#pragma mark - Actino

- (void)addAction:(id)sender {
    CardAddViewController *controller = [[CardAddViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
