//
//  WalletViewController.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/13.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "WalletViewController.h"
#import "BankCardSelectViewController.h"
#import "CreditCardModel.h"
#import "MBProgressHUD+CAAdd.h"
#import "WithdrawalRecordVC.h"
@class UserModel;
@interface WalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *AbleBalance;
@property (weak, nonatomic) IBOutlet UILabel *UnAbleBalance;
@property (weak, nonatomic) IBOutlet UITextField *useMoney;
@property (weak, nonatomic) IBOutlet UITextField *payPassword;

@property (weak, nonatomic) IBOutlet UILabel *bankCardName;

@property (strong, nonatomic) CreditCardModel *bankCard;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation WalletViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"还款金";
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"还款记录" style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 24;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.money.text = [NSString stringWithFormat:@"%0.2f",self.userModel.Balance.floatValue];
    self.UnAbleBalance.text = [NSString stringWithFormat:@"%0.2f",self.userModel.UnAbleBalance.floatValue ];
    self.AbleBalance.text = [NSString stringWithFormat:@"%0.2f",self.userModel.AbleBalance.floatValue ];
    [self getCreditCardList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:UserInfoUpdateNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationBar* bar = self.navigationController.navigationBar;
    bar.translucent = YES;
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 1)] forBarMetrics:UIBarMetricsDefault];
    bar.barTintColor = [UIColor clearColor];
    [bar setShadowImage:[UIImage new]];
    
    [NSNotificationCenter.defaultCenter postNotificationName:UserInfoChangeNotification object:NULL];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UINavigationBar* bar = self.navigationController.navigationBar;
    bar.translucent = NO;
    bar.barTintColor = [UIColor colorWithHexString:MainColor];
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:MainColor] size:CGSizeMake(1, 1)]
             forBarPosition:UIBarPositionAny
                 barMetrics:UIBarMetricsDefault];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
    
}

-(void)updateUserInfo{
    self.money.text = [NSString stringWithFormat:@"%0.2f",self.userModel.Balance.floatValue];
}
//信用卡列表
- (void)getCreditCardList
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
    
    [mgr POST:CreditCardListURL parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            self.bankCard = [CreditCardModel objectArrayWithKeyValuesArray:[dataDict objectForKey:@"CreditCardList"]].firstObject;
        } else {
            [hud hide:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

- (void)setBankCard:(CreditCardModel *)bankCard {
    _bankCard = bankCard;
    if (_bankCard != NULL){
        _bankCardName.text = [NSString stringWithFormat:@"还款到信用卡-%@(%@)",bankCard.BankName,[bankCard.CreditCardNo substringWithRange:NSMakeRange(bankCard.CreditCardNo.length - 4, 4)]];
    }
    
}

#pragma mark - Actino
- (IBAction)submitAction {
    if (_bankCard == NULL) {
        [MBProgressHUD showError:@"请先添加一张信用卡"];
        return ;
    }
    
    if ([_money.text isEqualToString:@""]) {
        [MBProgressHUD showProgressWithTitle:NULL message:@"请输入金额" duration:1];
        return;
    }
    
    if ([_payPassword.text isEqualToString:@""]) {
        [MBProgressHUD showProgressWithTitle:NULL message:@"请输入交易密码" duration:1];
        return;
    }
    
    
    MBProgressHUD* hud = [MBProgressHUD showMessageWithActivityIndicator:@"正在提交订单" toView:self.view.window];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [parametersDict setObject:self.userModel.UserID forKey:@"UserID"];
    [parametersDict setObject:_useMoney.text forKey:@"Amount"];
    [parametersDict setObject:_payPassword.text.MD5 forKey:@"TradePassword"];
    [parametersDict setObject:[NSNumber numberWithFloat:1] forKey:@"OrderType"];
    [parametersDict setObject:[NSNumber numberWithFloat:1] forKey:@"InCardType"];
    [parametersDict setObject:_bankCard.CreditCardID forKey:@"InCardId"];
    
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    NSLog(@"%@",parametersDict);
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr POST:CreateOrder parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            NSNumber *OrderStatus = [dataDict objectForKey:@"OrderStatus"];
            NSString* str = @"";
            switch (OrderStatus.intValue) {
                case 0:
                    str = @"未知状态";
                    break;
                case 100:
                    str = @"还款成功";
                    [NSNotificationCenter.defaultCenter postNotificationName:UserInfoChangeNotification object:NULL];
                    break;
                case 101:
                    str = @"提交成功";
                    break;
                default:
                    str = @"还款失败";
                    break;
            }
            [MBProgressHUD showProgressWithTitle:str message:nil duration:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            NSString *msg = [dict objectForKey:@"RespMsg"];
            [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:3.0];
        }
        [hud hide:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
        [hud hide:YES];
    }];
}

- (IBAction)chooseBankCard {
    BankCardSelectViewController *controller = [[BankCardSelectViewController alloc] init];
    controller.type = 1;
    __weak typeof (self) myself = self;
    controller.didSelectBlock = ^(id model, UIViewController *controller) {
        myself.bankCard = (CreditCardModel*)model;
        
        //信用卡选择处理
        [controller.navigationController popViewControllerAnimated:YES];
    };
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}




- (void)addAction:(id)sender {
    WithdrawalRecordVC *controller = [[WithdrawalRecordVC alloc] init];
    controller.userModel = self.userModel;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
