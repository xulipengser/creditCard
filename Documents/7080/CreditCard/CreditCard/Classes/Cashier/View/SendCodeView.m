//
//  SendCodeView.m
//  CreditCard
//
//  Created by cass on 2018/3/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "SendCodeView.h"
#import "YYKit.h"
#import "YYTextKeyboardManager.h"
@interface SendCodeView()<YYTextKeyboardObserver>
@property (nonatomic, strong) UIView *frontView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *sendCodeButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic) NSInteger counter;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) CGRect frontViewOriginFrame;
@property (nonatomic) CGRect codeTextFieldOriginFrame;
@end

@implementation SendCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.size = CGSizeMake(kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self addSubview:self.frontView];
    _frontViewOriginFrame = self.frontView.frame;
    _codeTextFieldOriginFrame = [self.frontView convertRect:self.codeTextField.frame toView:self];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    return self;
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (UIView *)frontView {
    if (_frontView == nil) {
        _frontView = [[UIView alloc] init];
        _frontView.width = kScreenWidth - 18 * 2;
        _frontView.height = 237;
        _frontView.centerX = kScreenWidth / 2;
        _frontView.centerY = kScreenHeight / 2;
        _frontView.layer.cornerRadius = 20;
        _frontView.layer.masksToBounds = YES;
        _frontView.backgroundColor = [UIColor whiteColor];
        [_frontView addSubview:self.closeButton];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"发送验证码到手机";
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:16];
        label.size = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                              options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName : label.font}
                                              context:nil].size;
        label.top = 35;
        label.centerX = _frontView.width / 2;
        [_frontView addSubview:label];
        self.phoneNumberLabel.top = label.bottom + 11;
        [_frontView addSubview:self.phoneNumberLabel];
        
        
        CALayer *separatorLine = [CALayer layer];
        separatorLine.backgroundColor = [UIColor colorWithHexString:@"#cecece"].CGColor;
        separatorLine.height = 0.5;
        separatorLine.left = 16.5;
        separatorLine.width = _frontView.width - 16.5 * 2;
        separatorLine.top = self.phoneNumberLabel.bottom + 21.5;
        [_frontView.layer addSublayer:separatorLine];
        
        label = [[UILabel alloc] init];
        label.text = @"验证码:";
        label.textColor = [UIColor colorWithHexString:@"#9a9a9a"];
        label.font = [UIFont systemFontOfSize:16];
        label.size = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                              options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName : label.font}
                                              context:nil].size;
        label.top = separatorLine.bottom + 24;
        label.left = separatorLine.left;
        [_frontView addSubview:label];
        
        
        _codeTextField = [[UITextField alloc] init];
        _codeTextField.left = label.right + 10;
        _codeTextField.width = self.sendCodeButton.left - _codeTextField.left;
        _codeTextField.height = 30;
        _codeTextField.centerY = label.centerY;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;

        [_frontView addSubview:_codeTextField];
        
        self.sendCodeButton.centerY = label.centerY;
        [_frontView addSubview:self.sendCodeButton];
        
        separatorLine = [CALayer layer];
        separatorLine.backgroundColor = [UIColor colorWithHexString:@"#cecece"].CGColor;
        separatorLine.height = 0.5;
        separatorLine.left = 16.5;
        separatorLine.width = _frontView.width - 16.5 * 2;
        separatorLine.top = self.sendCodeButton.bottom + 16;
        [_frontView.layer addSublayer:separatorLine];
        
        [_frontView addSubview:self.confirmButton];
    }
    return _frontView;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] init];
        _closeButton.size = CGSizeMake(44, 44);
        _closeButton.right = self.frontView.width;
        [_closeButton setImage:[UIImage imageNamed:@"close_button"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeButton;
}

- (UILabel *)phoneNumberLabel {
    if (_phoneNumberLabel == nil) {
        _phoneNumberLabel = [[UILabel alloc] init];
        _phoneNumberLabel.font = [UIFont systemFontOfSize:13];
        _phoneNumberLabel.textColor = [UIColor colorWithHexString:@"#4161c3"];
        _phoneNumberLabel.height = 14;
        _phoneNumberLabel.width = self.frontView.width;
        _phoneNumberLabel.centerX = self.frontView.width / 2;
        _phoneNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneNumberLabel;
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
        _sendCodeButton.right = self.frontView.width - 16.5;
        
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
        [_confirmButton setBackgroundColor:[UIColor colorWithHexString:@"#4d6dcf"]];
        _confirmButton.left = 16.5;
        _confirmButton.height = 44;
        _confirmButton.width = self.frontView.width - _confirmButton.left * 2;
        _confirmButton.bottom = self.frontView.height - 20;
        _confirmButton.layer.cornerRadius = _confirmButton.height / 2;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

#pragma mark - SET

- (void)setPhoneNumber:(NSString *)phoneNumber {
    _phoneNumber = phoneNumber;
    self.phoneNumberLabel.text = phoneNumber;
}

#pragma mark - Action

- (void)showInView:(UIView *)view {
    [view addSubview:self];
}

- (void)closeAction:(id)sender {
    [self removeFromSuperview];
}

- (void)sendCodeAction:(id)sender {
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
    
}

#pragma mark - YYTextKeyboardObserver

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect fromFrame = transition.fromFrame;
    CGRect toFrame = transition.toFrame;
    [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption animations:^{
        
        CGRect newFrame = _frontViewOriginFrame;
        if (toFrame.origin.y <= fromFrame.origin.y) {
            //up
            if (toFrame.origin.y < _codeTextFieldOriginFrame.origin.y + _codeTextFieldOriginFrame.size.height) {
                newFrame.origin.y -= (_codeTextFieldOriginFrame.origin.y + _codeTextFieldOriginFrame.size.height - toFrame.origin.y + 10);
                self.frontView.frame = newFrame;
            }
        } else {
            self.frontView.frame = _frontViewOriginFrame;
        }
    } completion:^(BOOL finished) {
        
    }];
}

@end
