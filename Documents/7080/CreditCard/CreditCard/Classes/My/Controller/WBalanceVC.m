//
//  WBalanceVC.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/28.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "WBalanceVC.h"
#import "BankCardSelectViewController.h"
#import "DebitCardModel.h"
#import "MBProgressHUD+CAAdd.h"
#import "WBalanceRecordVC.h"
@interface WBalanceVC ()
@property (weak, nonatomic) IBOutlet UILabel *wbAlance;
@property (weak, nonatomic) IBOutlet UILabel *WAbleBalance;
@property (weak, nonatomic) IBOutlet UILabel *WUnAbleBalance;
@property (weak, nonatomic) IBOutlet UILabel *bankCardName;

@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) DebitCardModel *bankCard;
@property (weak, nonatomic) IBOutlet UIButton *submitBrn;

@end

@implementation WBalanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationItem.title = @"我的收益";
//    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
//    self.navigationItem.rightBarButtonItem = addItem;
    
    _submitBrn.layer.masksToBounds = YES;
    _submitBrn.layer.cornerRadius = 24;
    
    _wbAlance.text = [NSString stringWithFormat:@"%0.2f",_userModel.WBalance.floatValue];
    _WAbleBalance.text = [NSString stringWithFormat:@"%0.2f",_userModel.WAbleBalance.floatValue];
    _WUnAbleBalance.text = [NSString stringWithFormat:@"%0.2f",_userModel.WUnAbleBalance.floatValue];
    
    
    [self getDebitCardList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationBar* bar = self.navigationController.navigationBar;
    bar.translucent = YES;
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 1)] forBarMetrics:UIBarMetricsDefault];
    bar.barTintColor = [UIColor clearColor];
    [bar setShadowImage:[UIImage new]];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - Private
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
            NSArray* arr = [DebitCardModel objectArrayWithKeyValuesArray:[dataDict objectForKey:@"DebitCardList"]];
            for (DebitCardModel* car in arr) {
                if (car.IsDefault) {
                    self.bankCard = car;
                    break;
                }
            }
            if (_bankCard==NULL) {
                self.bankCard = arr.firstObject;
            }
        } else {
            [hud hide:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

- (void)setBankCard:(DebitCardModel *)bankCard {
    _bankCard = bankCard;
    if (_bankCard != NULL){
        _bankCardName.text = [NSString stringWithFormat:@"提现到借记卡-%@(%@)",bankCard.BankName,[bankCard.BankCardNo substringWithRange:NSMakeRange(bankCard.BankCardNo.length - 4, 4)]];
    }
}

#pragma mark - Action
- (IBAction)sibmitAction {
    if ([_money.text isEqualToString:@""]) {
        [MBProgressHUD showProgressWithTitle:NULL message:@"请输入金额" duration:1];
        return;
    }
    
    if (_bankCard == NULL) {
        [MBProgressHUD showError:@"请先添加一张银行卡"];
        return;
    }
    
    if ([_password.text isEqualToString:@""]) {
        [MBProgressHUD showProgressWithTitle:NULL message:@"请输入交易密码" duration:1];
        return;
    }
    
    MBProgressHUD* hud = [MBProgressHUD showMessageWithActivityIndicator:@"正在提交订单" toView:self.view.window];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [parametersDict setObject:self.userModel.UserID forKey:@"UserID"];
    [parametersDict setObject:[NSNumber numberWithFloat:3] forKey:@"OrderType"];
    [parametersDict setObject:_money.text forKey:@"Amount"];
    [parametersDict setObject:[NSNumber numberWithFloat:0] forKey:@"CardType"];
    [parametersDict setObject:_bankCard.DebitCardID forKey:@"BankCardId"];
    
    [parametersDict setObject:_password.text.MD5 forKey:@"TradePassword"];
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
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
            switch (OrderStatus.intValue) {
                case 0:
                    [MBProgressHUD showMessage:@"未知状态"];
                    break;
                case 100:
                    [MBProgressHUD showMessage:@"提现成功"];
                    break;
                case 101:
                    [MBProgressHUD showMessage:@"提交成功"];
                    break;
                default:
                    [MBProgressHUD showMessage:@"提现失败"];
                    break;
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            NSString *msg = [dict objectForKey:@"RespMsg"];
            [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:1.0];
        }
        [hud hide:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
        [hud hide:YES];
    }];
}


- (IBAction)chooseBankCard {
    BankCardSelectViewController *controller = [[BankCardSelectViewController alloc] init];
    controller.type = 2;
    __weak typeof (self) myself = self;
    controller.didSelectBlock = ^(id model, UIViewController *controller) {
        myself.bankCard = (DebitCardModel*)model;
        //储蓄卡选择处理
        [controller.navigationController popViewControllerAnimated:YES];
    };
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)addAction:(id)sender {
    WBalanceRecordVC *controller = [[WBalanceRecordVC alloc] init];
    controller.userModel = self.userModel;
    [self.navigationController pushViewController:controller animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
