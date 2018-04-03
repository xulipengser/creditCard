//
//  BackPassWordVC.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/28.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "BackPassWordVC.h"
#import "YYKit.h"
#import "UserModel.h"
#import "MBProgressHUD+CAAdd.h"

@interface BackPassWordVC ()
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UITextField *verificationCodeTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *sendCodeButton;
@property (nonatomic) NSInteger counter;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) NSString *userID;

@end

@implementation BackPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"找回密码";
    
    [self.view addSubview:self.phoneNumberTextField];
    CALayer *separatorLine = [CALayer layer];
    separatorLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
    separatorLine.height = 1;
    separatorLine.left = 25;
    separatorLine.width = kScreenWidth - 2 * separatorLine.left;
    separatorLine.top = self.phoneNumberTextField.bottom + 22;
    [self.view.layer addSublayer:separatorLine];
    
    self.verificationCodeTextField.top = separatorLine.bottom + 22;
    
    [self.view addSubview:self.verificationCodeTextField];
    [self.view addSubview:self.sendCodeButton];
    self.sendCodeButton.centerY = self.verificationCodeTextField.centerY;
    CALayer *hLayer = [CALayer layer];
    hLayer.height = self.verificationCodeTextField.height;
    hLayer.width = 1;
    hLayer.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
    hLayer.right = self.sendCodeButton.left - 20;
    hLayer.centerY = self.verificationCodeTextField.centerY;
    [self.view.layer addSublayer:hLayer];
    
    separatorLine = [CALayer layer];
    separatorLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
    separatorLine.height = 1;
    separatorLine.left = 25;
    separatorLine.width = kScreenWidth - 2 * separatorLine.left;
    separatorLine.top = self.verificationCodeTextField.bottom + 22;
    [self.view.layer addSublayer:separatorLine];
    
    self.passwordTextField.top = separatorLine.bottom + 22;
    [self.view addSubview:self.passwordTextField];
    
    separatorLine = [CALayer layer];
    separatorLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
    separatorLine.height = 1;
    separatorLine.left = 25;
    separatorLine.width = kScreenWidth - 2 * separatorLine.left;
    separatorLine.top = self.passwordTextField.bottom + 22;
    [self.view.layer addSublayer:separatorLine];
    
    self.confirmButton.top = separatorLine.bottom + 21;
    [self.view addSubview:self.confirmButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITextField *)phoneNumberTextField {
    if (_phoneNumberTextField == nil) {
        _phoneNumberTextField = [[UITextField alloc] init];
        _phoneNumberTextField.placeholder = @"请输入手机号";
        _phoneNumberTextField.font = [UIFont systemFontOfSize:18];
        _phoneNumberTextField.top = 40;
        _phoneNumberTextField.left = 33;
        _phoneNumberTextField.width = kScreenWidth - 2 * _phoneNumberTextField.left;
        _phoneNumberTextField.height = 19;
        _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneNumberTextField setValue:[UIColor colorWithHexString:@"dbdbdb"] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _phoneNumberTextField;
}

- (UITextField *)verificationCodeTextField {
    if (_verificationCodeTextField == nil) {
        _verificationCodeTextField = [[UITextField alloc] init];
        _verificationCodeTextField.placeholder = @"请输入验证码";
        _verificationCodeTextField.font = [UIFont systemFontOfSize:18];
        _verificationCodeTextField.left = 33;
        _verificationCodeTextField.height = 19;
        _verificationCodeTextField.width = kScreenWidth - 2 * _verificationCodeTextField.left - self.sendCodeButton.width - 20 - 10;
        [_verificationCodeTextField setValue:[UIColor colorWithHexString:@"dbdbdb"] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _verificationCodeTextField;
}

- (UITextField *)passwordTextField {
    if (_passwordTextField == nil) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.placeholder = @"设置6位数字交易密码";
        _passwordTextField.font = [UIFont systemFontOfSize:18];
        _passwordTextField.left = 33;
        _passwordTextField.height = 19;
        _passwordTextField.width = kScreenWidth - 2 * _passwordTextField.left;
        [_passwordTextField setValue:[UIColor colorWithHexString:@"dbdbdb"] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _passwordTextField;
}

- (UIButton *)sendCodeButton {
    if (_sendCodeButton == nil) {
        _sendCodeButton = [[UIButton alloc] init];
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_sendCodeButton setTitleColor:[UIColor colorWithHexString:@"#4161c3"] forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _sendCodeButton.size = [_sendCodeButton.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                                             options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                                          attributes:@{NSFontAttributeName : _sendCodeButton.titleLabel.font}
                                                                             context:nil].size;
        _sendCodeButton.right = self.view.width - 25;
        
        
        [_sendCodeButton addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendCodeButton;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [[UIButton alloc] init];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[UIImage imageNamed:@"button_blue_background"] forState:UIControlStateNormal];
        
        _confirmButton.height = 47;
        _confirmButton.left = 22;
        _confirmButton.width = kScreenWidth - _confirmButton.left * 2;
        _confirmButton.layer.cornerRadius = _confirmButton.height / 2;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

#pragma mark - Action

- (void)sendCodeAction:(id)sender {
    if (_phoneNumberTextField.text.length != 11){
        [MBProgressHUD showMessage:@"手机号不规范" ];
        return;
    }
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:10];
    [parametersDict setValue:_phoneNumberTextField.text forKey:@"Mobile"];
    [parametersDict setValue:[NSNumber numberWithInt:10] forKey:@"AuthCodeType"];
    
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr POST:AuthCode parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSLog(@"发送成功");
            NSDictionary* dic = [dict objectForKey:@"Data"];
            _userID = dic[@"UserID"];
        } else {
            NSString *msg = [dict objectForKey:@"RespMsg"];
            [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:1.0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
    
    
    
    //发送验证码
    self.sendCodeButton.enabled = NO;
    self.counter = 60;
    @weakify(self);
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        self.counter--;
        if (self.counter <= 0) {
            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
            weak_self.sendCodeButton.enabled = YES;
            [weak_self.sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [weak_self.sendCodeButton setTitle:@"60"
                                      forState:UIControlStateDisabled];
            return;
        }
        
        [weak_self.sendCodeButton setTitle:[NSString stringWithFormat:@"(%zd)", self.counter]
                                  forState:UIControlStateDisabled];
    } repeats:YES];
}

- (void)confirmAction:(id)sender {
    if (![_phoneNumberTextField.text isPhoneNumber]){
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:10];
    [parametersDict setValue:_verificationCodeTextField.text forKey:@"AuthCode"];
    [parametersDict setObject:_phoneNumberTextField.text forKey:@"Mobile"];
    [parametersDict setValue:_passwordTextField.text.MD5 forKey:@"Password"];
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr POST:UpdateLoginPassword parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            [MBProgressHUD showProgressWithTitle:@"修改成功" message:nil duration:1.0];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            NSString *msg = [dict objectForKey:@"RespMsg"];
            [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:1.0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}
@end
