//
//  InputPasswordView.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/29.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "InputPasswordView.h"
#import "YYKit.h"
@interface InputPasswordView()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIView *sureView;

@end
@implementation InputPasswordView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.layer.cornerRadius = 10;
    
    [self setHidden:YES];
    
}

+(instancetype)Load{
    InputPasswordView* view = [[NSBundle.mainBundle loadNibNamed:@"InputPasswordView" owner:NULL options:NULL]firstObject];
    view.size = CGSizeMake(kScreenWidth, kScreenHeight);
    view.sureView.layer.cornerRadius = 20;
    view.sureView.clipsToBounds = YES;
    return view;
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
}

-(void)show:(InputPasswordViewSure)myblock{
    self.myblock = NULL;
    self.myblock = myblock;
    self.alpha = 0;
    [self setHidden:NO];
    
    CGAffineTransform  transform = CGAffineTransformScale(self.contentView.transform, 0.1, 0.1);
    self.contentView.transform = transform;
    CGAffineTransform  transformTranslation1 = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform  transform1 = CGAffineTransformScale(transformTranslation1, 1, 1);
    self.password.text = @"";
//    self.sureView.transform
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        self.contentView.transform = transform1;
    }];
}
- (IBAction)sureAction {
    [self endEditing:YES];
    [self closeAction];
    if (_myblock)_myblock(_password.text);
}

- (IBAction)closeAction {
    [self endEditing:YES];
    CGAffineTransform  transform = CGAffineTransformScale(self.contentView.transform, 0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.contentView.transform = transform;
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
@end
