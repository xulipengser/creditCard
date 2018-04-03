//
//  CardAddViewController.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "CardAddViewController.h"
#import "UserModel.h"
#import "MBProgressHUD+CAAdd.h"
#import "BankModel.h"
#import "DebitCardModel.h"

@interface CardAddViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *footerView;
@property(nonatomic, strong) UITextField *cardNumTextField;
@property(nonatomic, strong) UITextField *phoneNumber;
@property(nonatomic, strong) UserModel *userModel;
@property(nonatomic, strong) NSArray *bankList;

@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) UIPickerView *pickView;
@property(nonatomic, strong) DebitCardModel *debitCardModel;
@end

@implementation CardAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.navigationItem.title = @"新增银行卡";
    [self.view addSubview:self.tableView];
    
    NSDictionary *userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoData"];
    self.userModel = [UserModel objectWithKeyValues:userInfoDict];
    [self getBankList];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

#pragma mark - Private



- (void)confirmAction
{
    if (self.cardNumTextField.text.length != 18) {
        [MBProgressHUD showProgressWithTitle:@"请输入正确的卡号" message:nil duration:1.2];
        return;
    }
    if (self.debitCardModel.BankId.length<=0) {
        [MBProgressHUD showProgressWithTitle:@"请选择银行" message:nil duration:1.2];
        return;
    }
    self.debitCardModel.BankCardNo = self.cardNumTextField.text;
    
    
    self.debitCardModel.RealName = self.userModel.RealName;
    self.debitCardModel.IdCardNo = self.userModel.IdCardNo;
    self.debitCardModel.BankPhone = self.userModel.MobilePhone;
    self.debitCardModel.IsDefault = @"1";
    
    [self addBankInfo];
}

- (void)addBankInfo
{
    if ([_phoneNumber.text isEqualToString:@""]) {
        [MBProgressHUD showProgressWithTitle:NULL message:@"请输入银行预留手机号" duration:1];
        return;
    }
    
    if ([_phoneNumber.text isEqualToString:@""]) {
        [MBProgressHUD showProgressWithTitle:NULL message:@"请输入银行卡号" duration:1];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showMessageWithActivityIndicator:@"" toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:9];
    [parametersDict setObject:self.userModel.UserID forKey:@"UserID"];
    [parametersDict setObject:self.debitCardModel.BankId forKey:@"BankID"];
    [parametersDict setObject:self.debitCardModel.BranchBankName forKey:@"BranchBankName"];
    [parametersDict setObject:self.debitCardModel.BankCardNo forKey:@"DebitCardNo"];
    [parametersDict setObject:self.debitCardModel.RealName forKey:@"RealName"];
    [parametersDict setObject:self.debitCardModel.IdCardNo forKey:@"IdCardNo"];
    [parametersDict setObject:_phoneNumber.text forKey:@"BankPhone"];
    [parametersDict setObject:[NSNumber numberWithInt:0] forKey:@"IsDefault"];
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 20.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [mgr POST:AddDebitCardURL parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDebitCardList" object:nil];
            [MBProgressHUD showProgressWithTitle:@"添加成功" message:nil duration:1.2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [hud hide:YES];
            NSString *msg = [dict objectForKey:@"RespMsg"];
            [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

- (void)maskClick
{
    [self.maskView removeFromSuperview];
}

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
    
    [mgr POST:BankListURL parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            self.bankList = [BankModel objectArrayWithKeyValuesArray:[dataDict objectForKey:@"BankList"]];

        } else {
            [hud hide:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    BankModel *bankModel = self.bankList[row];
    self.debitCardModel.BankId = bankModel.Id;
    self.debitCardModel.BranchBankName = bankModel.BankName;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text = bankModel.BankName;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.bankList.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return MainScreenCGRect.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    BankModel *bankModel = self.bankList[row];
    return bankModel.BankName;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"选择银行";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"持卡人";
        cell.detailTextLabel.text = self.userModel.RealName;
    } else  if (indexPath.row == 2) {
        cell.textLabel.text = @"卡号";
        [cell.contentView addSubview:self.cardNumTextField];
    }else{
        cell.textLabel.text = @"银行预留手机号";
        [cell.contentView addSubview:self.phoneNumber];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:true];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        [self.view addSubview:self.maskView];
        self.pickView.transform = CGAffineTransformMakeTranslation(0, self.pickView.frame.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            self.pickView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
        
        
    }
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

- (DebitCardModel *)debitCardModel
{
    if (_debitCardModel == nil) {
        _debitCardModel = [[DebitCardModel alloc] init];
    }
    return _debitCardModel;
}

- (UIView *)maskView
{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, MainScreenCGRect.size.height)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_maskView addSubview:self.pickView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskClick)];
        [_maskView addGestureRecognizer:tapGesture];
        
     
    }
    return _maskView;
}

- (UIPickerView *)pickView
{
    if (_pickView == nil) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, MainScreenCGRect.size.height - 64 - 256, MainScreenCGRect.size.width, 256)];
        _pickView.backgroundColor = [UIColor colorWithHexString:@"#F0EFF5"];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

- (UITextField *)cardNumTextField
{
    if (_cardNumTextField == nil) {
        CGFloat W = 200;
        CGFloat X = MainScreenCGRect.size.width - W;
        _cardNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(X, 5, 200, 35)];
        _cardNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _cardNumTextField;
}

-(UITextField*)phoneNumber{
    if (_phoneNumber == nil) {
        CGFloat W = 200;
        CGFloat X = MainScreenCGRect.size.width - W;
        _phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(X, 5, 200, 35)];
        _phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneNumber;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width - 20, 66)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, MainScreenCGRect.size.width - 20, 46)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithHexString:@"#4161C3"];
        btn.layer.cornerRadius = 23;
        btn.layer.masksToBounds = YES;
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:btn];
    }
    return _footerView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, MainScreenCGRect.size.height - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

@end
