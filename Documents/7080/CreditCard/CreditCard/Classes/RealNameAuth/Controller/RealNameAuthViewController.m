//
//  RealNameAuthViewController.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/6.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "RealNameAuthViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import "UIButton+WebCache.h"
#import "OMESoft.h"
#import "ZYObjectToDictionary.h"
#import "RealNameAuthViewController2.h"
#import "RealNameCertModel.h"

@interface RealNameAuthViewController ()
@property(nonatomic, strong) RealNameCertModel *realNameModel;
@end

@implementation RealNameAuthViewController

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

#pragma mark - Private

- (IBAction)scanAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIViewController *vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont andImageHandler:^(UIImage *image) {
        // 成功扫描出身份证
        [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                     withOptions:nil
                                                  successHandler:^(id result){
                                                      // 在成功回调中，保存图片到系统相册
                                                      self.realNameModel.IdCardImg = image;
                                                      UIImageWriteToSavedPhotosAlbum(image, nil, nil, (__bridge void *)self);
                                                      NSDictionary *wordsResultDict = [result objectForKey:@"words_result"];
                                                      NSDictionary *cardNumDict = [wordsResultDict objectForKey:@"公民身份号码"];
                                                      NSString *cardNum = [cardNumDict objectForKey:@"words"];
                                                      
                                                      NSDictionary *nameDict = [wordsResultDict objectForKey:@"姓名"];
                                                      NSString *name = [nameDict objectForKey:@"words"];
                                                      
                                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                          [weakSelf.cardBtn setImage:image forState:UIControlStateNormal];
                                                          weakSelf.cardNumTextField.text = cardNum;
                                                          weakSelf.nameTextField.text = name;
                                                          [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                      }];
                                                  }
                                                     failHandler:^(NSError *err) {
                                                         NSLog(@"err:%@", err);
                                                     }];
    }];
    // 展示ViewController
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)nextAction:(id)sender {
    if (self.cardNumTextField.text.length <= 0 || self.realNameModel.IdCardImg == NULL) {
        [MBProgressHUD showProgressWithTitle:@"请先扫描身份证" message:nil duration:1.0];
        return;
    }
    
    
    
    self.realNameModel.IdCardNo = self.cardNumTextField.text;
    self.realNameModel.RealName = self.nameTextField.text;
    NSDictionary *userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoData"];
    self.realNameModel.UserID = [userInfoDict objectForKey:@"UserID"];
    self.realNameModel.BankMobile = [userInfoDict objectForKey:@"MobilePhone"];// 先用注册用的手机号
    RealNameAuthViewController2 *realNameVc2 = [[RealNameAuthViewController2 alloc] initWithModel:self.realNameModel];
    [self.navigationController pushViewController:realNameVc2 animated:YES];
}

#pragma mark - Get

- (RealNameCertModel *)realNameModel
{
    if (_realNameModel == nil) {
        _realNameModel = [[RealNameCertModel alloc] init];
    }
    return _realNameModel;
}

@end
