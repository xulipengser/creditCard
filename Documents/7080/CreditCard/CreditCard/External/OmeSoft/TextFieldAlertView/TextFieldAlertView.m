//
//  TextFieldAlertView.m
//  Hypnotist
//
//  Created by OmeSoft-iOS on 14/12/5.
//
//

#import "TextFieldAlertView.h"
#import "OMESoft.h"

@interface TextFieldAlertView()
@property (strong, nonatomic) UIView *contextView;

@end

@implementation TextFieldAlertView

- (id)initWithTitle:(NSString *)title Message:(NSString *)message CancelButtonTitle:(NSString *)cancelButtonTitle OtherButtonTitle:(NSString *)otherButtonTitle
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MainScreenCGRect.size.width, MainScreenCGRect.size.height);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self.contextView addSubview:self.textField];
        
        for (int i = 0; i < 2; i++) {
            //标题，提示信息
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 + i * 10, self.contextView.frame.size.width, i ? 40: 20)];
            label.text = i ? message: title;
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            label.font = i? [UIFont systemFontOfSize:16.0f]: [UIFont boldSystemFontOfSize:18.0f];
            label.numberOfLines = 0;
            [self.contextView addSubview:label];
            //按键
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:[UIColor colorWithHexString:@"#007aff"] forState:UIControlStateNormal];
            button.titleLabel.font = i?[UIFont boldSystemFontOfSize:16.0f]: [UIFont systemFontOfSize:16.0f];
            button.frame = CGRectMake(i*140, 140, 140, 44);
            [button setTitle:i ? otherButtonTitle: cancelButtonTitle forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [self.contextView addSubview:button];
        }
        //横线和竖线
        UIView *horizonLine = [[UIView alloc] initWithFrame:CGRectMake(0, 140, self.frame.size.width, 0.5)];
        horizonLine.backgroundColor = [UIColor colorWithHexString:@"#b4b4b4"];
        [self.contextView addSubview:horizonLine];
        
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(self.contextView.frame.size.width/2, 140, 0.5, 45)];
        verticalLine.backgroundColor = [UIColor colorWithHexString:@"#b4b4b4"];
        [self.contextView addSubview:verticalLine];
        [self addSubview:self.contextView];
    }
    return self;
}

- (UIView *)contextView
{
    if (!_contextView) {
        _contextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 184)];
        if (SCREEN_LESS_IPHONE5) {
            _contextView.center = CGPointMake(MainScreenCGRect.size.width / 2.0, (MainScreenCGRect.size.height - 216) / 2.0 -30);
        } else {
            _contextView.center = CGPointMake(MainScreenCGRect.size.width / 2.0, (MainScreenCGRect.size.height - 216) / 2.0 + 10);
        }
        _contextView.backgroundColor = [UIColor whiteColor];
        [_contextView.layer setMasksToBounds:YES];
        [_contextView.layer setCornerRadius:3.0f];
    }
    return _contextView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.contextView.frame.size.width - 30, 30)];
        _textField.center = CGPointMake(self.contextView.frame.size.width / 2.0, self.contextView.frame.size.height / 2.0);
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
        _textField.layer.borderWidth = 1.0;
        _textField.layer.cornerRadius = 3.5;
        _textField.layer.masksToBounds = YES;
        _textField.font = [UIFont systemFontOfSize:16.0f];
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _textField.leftView.backgroundColor = [UIColor clearColor];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_textField becomeFirstResponder];
    }
    return _textField;
}

- (void)showIn:(UIView *)view
{
    self.contextView.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.35 animations:^{
        self.contextView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss
{
    [self.textField resignFirstResponder];
    [UIView animateWithDuration:0.35 animations:^{
        self.contextView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)buttonPressed:(UIButton *)sender
{
    if (sender.tag == 0) {
        [self dismiss];
    }
    if ([_delegate respondsToSelector:@selector(textFieldAlertView:buttonDidSelected:)]) {
        [_delegate textFieldAlertView:self buttonDidSelected:sender.tag];
    }
}


@end
