//
//  CardManagerViewController.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "CardManagerViewController.h"
#import "BankCardTableViewCell.h"
#import "CardAddViewController.h"
#import "MBProgressHUD+CAAdd.h"
#import "UserModel.h"
#import "DebitCardModel.h"
#import "UIImageView+WebCache.h"
#import "BankCardSetView.h"
@interface CardManagerViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *footerView;
@property(nonatomic, strong) UserModel *userModel;
@property(nonatomic, strong) NSMutableArray *bankList;
@end

@implementation CardManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.navigationItem.title = @"结算卡管理";
    [self.view addSubview:self.tableView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBankList) name:@"UpdateDebitCardList" object:nil];
    NSDictionary *userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoData"];
    self.userModel = [UserModel objectWithKeyValues:userInfoDict];
    [self getBankList];
}

#pragma mark - Private

- (void)getBankList
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
            self.bankList = [NSMutableArray arrayWithArray:[DebitCardModel objectArrayWithKeyValuesArray:[dataDict objectForKey:@"DebitCardList"]]];
            [self.tableView reloadData];
        } else {
            [hud hide:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}


- (void)btnClick
{
    CardAddViewController *addVc = [[CardAddViewController alloc] init];
    [self.navigationController pushViewController:addVc animated:YES];
}

-(void)bankSet:(UIButton*)sender{
    __weak typeof(self) myself = self;
    [BankCardSetView LoadDel:^{
        DebitCardModel* card = _bankList[sender.tag];
        if (card.IsDefault) {
            [MBProgressHUD showMessage:@"不能删除默认卡"];
            return;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showMessageWithActivityIndicator:@"" toView:self.view];
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [parametersDict setObject:myself.userModel.UserID forKey:@"UserID"];
        [parametersDict setObject:card.DebitCardID forKey:@"DebitCardID"];
        [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
        
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
        [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        mgr.requestSerializer.timeoutInterval = 20.f;
        [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [mgr POST:RemoveDebitCard parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"111");
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [hud hide:YES];
            NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
            
            NSString *RespCode = [dict objectForKey:@"RespCode"];
            if ([RespCode isEqualToString:@"000000"]) {
                [MBProgressHUD showMessage:@"删除成功"];
                [myself.bankList removeObject:card];
                [myself.tableView deleteSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [hud hide:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [hud hide:YES];
            [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
        }];
    } Def:^{
        DebitCardModel* card = _bankList[sender.tag];
        if (card.IsDefault) {
            return;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showMessageWithActivityIndicator:@"" toView:self.view];
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [parametersDict setObject:myself.userModel.UserID forKey:@"UserID"];
        [parametersDict setObject:card.DebitCardID forKey:@"DebitCardID"];
        [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
        
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
        [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        mgr.requestSerializer.timeoutInterval = 20.f;
        [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [mgr POST:SetDefaultDebitCard parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"111");
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [hud hide:YES];
            NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
            
            NSString *RespCode = [dict objectForKey:@"RespCode"];
            if ([RespCode isEqualToString:@"000000"]) {
                
                for (DebitCardModel* card in myself.bankList) {
                    if (card.IsDefault) {
                        card.IsDefault = NO;
                        myself.bankList[[myself.bankList indexOfObject:card]] = card;
                        break;
                    }
                }
                card.IsDefault = YES;
                myself.bankList[sender.tag] = card;
                [myself.tableView reloadData];
            } else {
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [hud hide:YES];
            [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
        }];
        
    }];
    
    
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.bankList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BankCardTableViewCell"];
    cell.layer.cornerRadius = 4;
    cell.layer.masksToBounds = YES;
    [cell.setBtn setHidden:NO];
    cell.setBtn.tag = indexPath.section;
    [cell.setBtn addTarget:self action:@selector(bankSet:) forControlEvents:UIControlEventTouchUpInside];
    DebitCardModel *bankModel = self.bankList[indexPath.section];
    [cell setDebitCard:bankModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark - Get

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width - 20, 66)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, MainScreenCGRect.size.width - 20, 46)];
        [btn setTitleColor:[UIColor colorWithHexString:@"#4262C4"] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 23;
        btn.layer.masksToBounds = YES;
        [btn setTitle:@"添加银行卡" forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor colorWithHexString:@"#4262C4"].CGColor;
        btn.layer.borderWidth = 1;
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:btn];
    }
    return _footerView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, MainScreenCGRect.size.width - 20, MainScreenCGRect.size.height - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = self.footerView;
    
        [_tableView registerNib:[UINib nibWithNibName:@"BankCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"BankCardTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
