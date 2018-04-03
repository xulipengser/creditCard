//
//  BankCardSetView.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/31.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "BankCardSetView.h"
#import "YYKit.h"

@interface BankCardSetView()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bg1;
@property (weak, nonatomic) IBOutlet UIView *bg2;
@property(nonatomic, strong) BankCardSetViewSure delBlock;
@property(nonatomic, strong) BankCardSetViewSure defBlock;
@end

@implementation BankCardSetView


-(void)awakeFromNib{
    [super awakeFromNib];
}

+(void)LoadDel:(BankCardSetViewSure)delblock Def:(BankCardSetViewSure)defblock{
    BankCardSetView* view = [[NSBundle.mainBundle loadNibNamed:@"BankCardSetView" owner:NULL options:NULL]firstObject];
    view.size = CGSizeMake(kScreenWidth, kScreenHeight);
    view.bg1.layer.cornerRadius = 5;
    view.bg2.layer.cornerRadius = 5;
    view.defBlock = defblock;
    view.delBlock = delblock;
    [UIApplication.sharedApplication.keyWindow addSubview:view];
    
    view.alpha = 0;
    view.contentView.transform = CGAffineTransformTranslate(view.contentView.transform,0, view.contentView.frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = 1;
        view.contentView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}


- (IBAction)delAction {
    if (_delBlock)_delBlock();
    [self cancelAction];
}

- (IBAction)sureAction {
    if (_defBlock)_defBlock();
    [self cancelAction];
}

- (IBAction)cancelAction {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform,0, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelAction];
}
@end
