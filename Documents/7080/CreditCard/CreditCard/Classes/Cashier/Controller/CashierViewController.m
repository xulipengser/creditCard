//
//  CashierViewController.m
//  CreditCard
//
//  Created by cass on 2018/3/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "CashierViewController.h"
#import "PayRecordViewController.h"
#import "BankCardSelectViewController.h"
#import "YYKit.h"
#import "CardChoiceControl.h"
#import "CardChoiceControlModel.h"
#import "SendCodeView.h"
#import "IQKeyboardManager.h"
#import "CreditCardModel.h"
#import "DebitCardModel.h"
#import "InputPasswordView.h"
#import "MBProgressHUD+CAAdd.h"
@interface CashierViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *amtnView;
@property (nonatomic, strong) UITextField *amtnTextField;
@property (nonatomic, strong) UILabel *receiveAmtnLabel;

@property (nonatomic, strong) UILabel *taxRateLabel;
@property (nonatomic, strong) UILabel *transactionFeeLabel;

@property (nonatomic, strong) CardChoiceControl *creditCard;
@property (nonatomic, strong) CardChoiceControlModel *creditCardModel;

@property (nonatomic, strong) CardChoiceControl *debitCard;
@property (nonatomic, strong) CardChoiceControlModel *debitCardModel;

@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) SendCodeView *sendCodeView;

@property(nonatomic, strong) InputPasswordView *inputView;
@end

@implementation CashierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收银台";
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, MainScreenCGRect.size.height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height/2 - 50, view.frame.size.width, 30)];
    lab.text = @"功能即将上线...";
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    [self.view addSubview:view];
    
//    UIBarButtonItem *bill = [[UIBarButtonItem alloc] initWithTitle:@"支付记录" style:UIBarButtonItemStylePlain target:self action:@selector(payRecordAction:)];
//
//    self.navigationItem.rightBarButtonItem = bill;
//    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
//    [self.view addSubview:self.scrollView];
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.nextButton.bottom + 0.5);
//
//
//    _amtnTextField.delegate = self;
//    _taxRateLabel.text = [NSString stringWithFormat:@"费率 : %0.2f%%",(_userModel.WRate.floatValue*100)];
//    _transactionFeeLabel.text = [NSString stringWithFormat:@"单笔手续费: %0.2f元",(_userModel.WBrokerage.floatValue)];
//    [_taxRateLabel sizeToFit];
//    __weak typeof(self) weakSelf = self;
//
//    [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//        [weakSelf.scrollView endEditing:YES];
//    }]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    _inputView = NULL;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    float count = textField.text.floatValue - textField.text.floatValue * _userModel.WRate.floatValue - _userModel.WBrokerage.floatValue;
    _receiveAmtnLabel.text = [NSString stringWithFormat: @"预计到账金额:¥%0.2f",count];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - GET

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, MainScreenCGRect.size.height - 64)];
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + 0.5);
        _scrollView.backgroundColor = self.view.backgroundColor;
        [_scrollView addSubview:self.amtnView];
        self.taxRateLabel.top = self.amtnView.bottom + 9 * HPFrameRatioHeight;
        self.transactionFeeLabel.top = self.taxRateLabel.top;
        [_scrollView addSubview:self.taxRateLabel];
        [_scrollView addSubview:self.transactionFeeLabel];
        
        [_scrollView addSubview:self.creditCard];
        [_scrollView addSubview:self.debitCard];
        [_scrollView addSubview:self.nextButton];
        
    }
    return _scrollView;
}

- (UIView *)amtnView {
    if (_amtnView == nil) {
        _amtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 163.5)];
        _amtnView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"收款金额(元)";
        titleLabel.size = [titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : titleLabel.font}
                                                        context:nil].size;
        titleLabel.top = 20;
        titleLabel.left = 14 * HPFrameRatioWidth;
        [_amtnView addSubview:titleLabel];
        
        UILabel *symbolLabel = [[UILabel alloc] init];
        symbolLabel.font = [UIFont systemFontOfSize:18];
        symbolLabel.textColor = [UIColor blackColor];
        symbolLabel.text = @"¥";
        symbolLabel.size = [symbolLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                          options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName : titleLabel.font}
                                                          context:nil].size;
        symbolLabel.top = titleLabel.bottom + 26;
        symbolLabel.left = 22 * HPFrameRatioWidth;
        [_amtnView addSubview:symbolLabel];
        
        self.amtnTextField.left = symbolLabel.right + 18 * HPFrameRatioWidth;
        self.amtnTextField.centerY = symbolLabel.centerY;
        self.amtnTextField.width = _amtnView.width - self.amtnTextField.left;
        self.amtnTextField.height = 22;
        self.amtnTextField.bottom = symbolLabel.bottom;
        [_amtnView addSubview:self.amtnTextField];
        
        CALayer *separatorLine = [CALayer layer];
        separatorLine.backgroundColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
        separatorLine.left = 15.5 * HPFrameRatioWidth;
        separatorLine.width = _amtnView.width - separatorLine.left;
        separatorLine.height = 0.5;
        separatorLine.top = self.amtnTextField.bottom + 34;
        [_amtnView.layer addSublayer:separatorLine];
        
        self.receiveAmtnLabel.top = separatorLine.bottom;
        self.receiveAmtnLabel.height = _amtnView.height - self.receiveAmtnLabel.top;
        [_amtnView addSubview:self.receiveAmtnLabel];
        
        separatorLine = [CALayer layer];
        separatorLine.backgroundColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
        separatorLine.width = _amtnView.width;
        separatorLine.height = 0.5;
        separatorLine.bottom = _amtnView.height;
        [_amtnView.layer addSublayer:separatorLine];
        
    }
    return _amtnView;
}

- (UITextField *)amtnTextField {
    if (_amtnTextField == nil) {
        _amtnTextField = [[UITextField alloc] init];
        _amtnTextField.placeholder = @"0.00";
        _amtnTextField.font = [UIFont systemFontOfSize:20];
        _amtnTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_amtnTextField setValue:[UIColor colorWithHexString:@"#e2e2e2"] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _amtnTextField;
}

- (UILabel *)receiveAmtnLabel {
    if (_receiveAmtnLabel == nil) {
        _receiveAmtnLabel = [[UILabel alloc] init];
        _receiveAmtnLabel.text = @"预计到账金额:¥0.00";
        _receiveAmtnLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _receiveAmtnLabel.font = [UIFont systemFontOfSize:16];
        _receiveAmtnLabel.height = 40.5 * HPFrameRatioHeight;
        _receiveAmtnLabel.width = self.amtnView.width - 15.5 * HPFrameRatioWidth;
        _receiveAmtnLabel.left = 15.5 * HPFrameRatioWidth;
    }
    return _receiveAmtnLabel;
}

- (UILabel *)taxRateLabel {
    if (_taxRateLabel == nil) {
        _taxRateLabel = [[UILabel alloc] init];
        _taxRateLabel.text = @"费率 : 0.60%";
        _taxRateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _taxRateLabel.font = [UIFont systemFontOfSize:16];
        _taxRateLabel.width = 110;
        _taxRateLabel.height = 16;
        _taxRateLabel.left = 14 * HPFrameRatioWidth;
    }
    return _taxRateLabel;
}

- (UILabel *)transactionFeeLabel {
    if (_transactionFeeLabel == nil) {
        _transactionFeeLabel = [[UILabel alloc] init];
        _transactionFeeLabel.text = @"单笔手续费 : 1元";
        _transactionFeeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _transactionFeeLabel.font = [UIFont systemFontOfSize:16];
        _transactionFeeLabel.left = self.taxRateLabel.right + 8.5 * HPFrameRatioWidth;
        _transactionFeeLabel.width = self.amtnView.width - _transactionFeeLabel.left;
        _transactionFeeLabel.height = 16;
    }
    return _transactionFeeLabel;
}

- (CardChoiceControl *)creditCard {
    if (_creditCard == nil) {
        _creditCard = [[CardChoiceControl alloc] initWithFrame:CGRectMake(17, self.taxRateLabel.bottom + 20 * HPFrameRatioHeight, self.view.width - 17 * 2, 109)];
        _creditCardModel = [[CardChoiceControlModel alloc] init];
        _creditCardModel.cardType = CardTypeCreditCard;
        _creditCardModel.cardName = @"";
        _creditCardModel.cardNumber = @"";
        _creditCard.model = _creditCardModel;
        [_creditCard addTarget:self action:@selector(bankCardAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _creditCard;
}

- (CardChoiceControl *)debitCard {
    if (_debitCard == nil) {
        _debitCard = [[CardChoiceControl alloc] initWithFrame:CGRectMake(17, self.creditCard.bottom + 15 * HPFrameRatioHeight, self.view.width - 17 * 2, 109)];
        _debitCardModel = [[CardChoiceControlModel alloc] init];
        _debitCardModel.cardType = CardTypeDebitCard;
        _debitCardModel.cardName = @"";
        _debitCardModel.cardNumber = @"";
        _debitCard.model = _debitCardModel;
        [_debitCard addTarget:self action:@selector(bankDebitCard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _debitCard;
}

- (UIButton *)nextButton {
    if (_nextButton == nil) {
        _nextButton = [[UIButton alloc] init];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextButton.width = self.creditCard.width;
        _nextButton.height = 46;
        _nextButton.layer.cornerRadius = _nextButton.height / 2;
        _nextButton.layer.masksToBounds = YES;
        _nextButton.top = self.debitCard.bottom + 20 * HPFrameRatioHeight;
        _nextButton.left = self.debitCard.left;
        [_nextButton setBackgroundColor:[UIColor colorWithHexString:@"#899cd7"]];
        [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (SendCodeView *)sendCodeView {
    if (_sendCodeView == nil) {
        _sendCodeView = [[SendCodeView alloc] init];
    }
    return _sendCodeView;
}

#pragma mark - SET

- (void)setTaxRate:(CGFloat)taxRate {
    self.taxRateLabel.text = [NSString stringWithFormat:@"费率: %.2f",taxRate];
}

- (void)setTransactionFee:(CGFloat)fee {
    self.transactionFeeLabel.text = [NSString stringWithFormat:@"单笔手续费 : %.0f", fee];
}

- (void)setReceiveAmtn:(CGFloat)amtn {
    self.receiveAmtnLabel.text = [NSString stringWithFormat:@"实际到账金额:¥%.2f", amtn];
}

#pragma mark - Action

- (void)payRecordAction:(id)sender {
    PayRecordViewController *controller = [[PayRecordViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)bankCardAction:(id)sender {
    [self.view endEditing:YES];
    BankCardSelectViewController *controller = [[BankCardSelectViewController alloc] init];
    controller.type = 1;
    controller.didSelectBlock = ^(id model, UIViewController *controller) {
        CreditCardModel* mdl = (CreditCardModel*)model;
        _creditCardModel.cardName = mdl.BankName;
        _creditCardModel.cardNumber = mdl.CreditCardID;
        _creditCardModel.cardImageUrl = mdl.IcoUrl;
        _creditCardModel.cardType = 0;
        [_creditCard setModel:_creditCardModel];
//        _debitCardModel
        //信用卡选择处理
        [controller.navigationController popViewControllerAnimated:YES];
    };
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)bankDebitCard:(id)sender {
    [self.view endEditing:YES];
    BankCardSelectViewController *controller = [[BankCardSelectViewController alloc] init];
    controller.type = 2;
    controller.didSelectBlock = ^(id model, UIViewController *controller) {
        DebitCardModel* mdl = (DebitCardModel*)model;
        _debitCardModel.cardName = mdl.BankName;
        _debitCardModel.cardNumber = mdl.DebitCardID;
        _debitCardModel.cardImageUrl = mdl.IcoUrl;
        _debitCardModel.cardType = 1;
        [_debitCard setModel:_debitCardModel];
        //储蓄卡选择处理
        [controller.navigationController popViewControllerAnimated:YES];
    };
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)nextAction:(id)sender {
    [self.view endEditing:YES];
    if ([_amtnTextField.text isEqualToString:@""]) {
        [MBProgressHUD showProgressWithTitle:@"提示" message:@"请输入金额" duration:1.0];
        return;
    }
    
    if ([_debitCardModel.cardNumber isEqualToString:@""]) {
        [MBProgressHUD showProgressWithTitle:@"提示" message:@"请选择储蓄卡" duration:1.0];
        return;
    }
    
    if ([_creditCardModel.cardNumber isEqualToString:@""]) {
        [MBProgressHUD showProgressWithTitle:@"提示" message:@"请选择信用卡" duration:1.0];
        return;
    }
    
    if (_inputView == NULL){
        _inputView = [InputPasswordView Load];
        [self.inputView showInView:self.view.window];
    }
    __weak typeof(self) weakSelf = self;
    [self.inputView show:^(NSString *password) {
        MBProgressHUD* hud = [MBProgressHUD showMessageWithActivityIndicator:@"正在提交订单" toView:self.view.window];
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:3];
        [parametersDict setObject:self.userModel.UserID forKey:@"UserID"];
        [parametersDict setObject:[NSNumber numberWithFloat:6] forKey:@"OrderType"];
        [parametersDict setObject:weakSelf.amtnTextField.text forKey:@"Amount"];
        [parametersDict setObject:[NSNumber numberWithFloat:0] forKey:@"InCardType"];//入账卡。 储蓄卡
        [parametersDict setObject:weakSelf.debitCardModel.cardNumber forKey:@"InCardId"];
        
        [parametersDict setObject:[NSNumber numberWithFloat:1] forKey:@"OutCardType"];//出账卡。 信用卡
        [parametersDict setObject:weakSelf.creditCardModel.cardNumber forKey:@"OutCardId"];
        [parametersDict setObject:password.MD5 forKey:@"TradePassword"];
        
        [parametersDict  setObject:[parametersDict getSignature:PrivateKey] forKey:@"Signature"];
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
                        [MBProgressHUD showMessage:@"交易成功"];
                        break;
                    case 101:
                        [MBProgressHUD showMessage:@"提交成功"];
                        break;
                    default:
                        [MBProgressHUD showMessage:@"交易失败"];
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
        
    }];
}
@end
