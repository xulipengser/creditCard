//
//  RealNameAuthViewController2.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/23.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "RealNameAuthViewController2.h"
#import "RealNameAuthViewController3.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import "UIButton+WebCache.h"
#import "RealNameCertModel.h"

@interface RealNameAuthViewController2 ()
@property(nonatomic, strong) RealNameCertModel *realNameModel;
@end

@implementation RealNameAuthViewController2

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nextBtn.layer.cornerRadius = 23;
    self.nextBtn.layer.masksToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
}

- (instancetype)initWithModel:(RealNameCertModel *)realNameModel
{
    self = [super init];
    if (self) {
        _realNameModel = realNameModel;
    }
    return self;
}

#pragma mark - Action

- (IBAction)scanBtnAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIViewController *vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard andImageHandler:^(UIImage *image) {
        // 成功扫描出银行卡
        
        [[AipOcrService shardService] detectBankCardFromImage:image successHandler:^(id result) {
            self.realNameModel.BankCardImg = image;
            NSDictionary *resultDict = [result objectForKey:@"result"];
            NSString *bank_card_number = [resultDict objectForKey:@"bank_card_number"];
            NSString *bank_name = [resultDict objectForKey:@"bank_name"];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakSelf.scanBtn setImage:image forState:UIControlStateNormal];
                weakSelf.cardTextField.text = bank_card_number;
                weakSelf.bankTextField.text = bank_name;
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
        } failHandler:^(NSError *err) {
             NSLog(@"err:%@", err);
        }];
    }];
    // 展示ViewController
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)nextBtnAction:(id)sender {
    if (self.cardTextField.text.length <= 0) {
        [MBProgressHUD showProgressWithTitle:@"请先扫描银行卡" message:nil duration:1.0];
        return;
    }
    self.realNameModel.BankCardNo = self.cardTextField.text;
    self.realNameModel.BankId = self.bankTextField.text;  // 银行卡名称
    RealNameAuthViewController3 *realNameVc3 = [[RealNameAuthViewController3 alloc] initWithModel:self.realNameModel];
    [self.navigationController pushViewController:realNameVc3 animated:YES];
}


@end
