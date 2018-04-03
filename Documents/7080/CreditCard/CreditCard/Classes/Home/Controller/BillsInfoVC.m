//
//  BillsInfoVC.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/29.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "BillsInfoVC.h"

@interface BillsInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *Amount;//金额
@property (weak, nonatomic) IBOutlet UILabel *OrderType;//订单类型
@property (weak, nonatomic) IBOutlet UILabel *OrderStatus;//订单状态
@property (weak, nonatomic) IBOutlet UILabel *Brokerage;//本次交易手续费
@property (weak, nonatomic) IBOutlet UILabel *OrderNo;//订单号
@property (weak, nonatomic) IBOutlet UILabel *ActualAmount;//实际到账金额
@property (weak, nonatomic) IBOutlet UILabel *CreatorTime;//创建时间
@property (weak, nonatomic) IBOutlet UILabel *bankCardNo;//银行卡号
@property (weak, nonatomic) IBOutlet UILabel *CreditCardNo;//信用卡号
@property (weak, nonatomic) IBOutlet UILabel *SettleTime;//到账时间
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCardViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creditCardViewHeight;

@end

@implementation BillsInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"订单详情";
    
    self.Amount.text = [NSString stringWithFormat:@"¥%0.2f",_model.Amount.floatValue];
    switch (_model.OrderType.intValue) {
        case 0:
            self.OrderType.text = @"还款金充值";
            break;
        case 1:
            self.OrderType.text = @"信用卡还款";
            break;
        case 2:
            self.OrderType.text = @"提现金充值";
            break;
        case 3:
            self.OrderType.text = @"借记卡提现";
            break;
        case 4:
            self.OrderType.text = @"升级会员";
            break;
        case 5:
            self.OrderType.text = @"信用卡绑定";
            break;
        case 6:
            self.OrderType.text = @"信用卡提现";
            break;
        default:
            self.OrderType.text = @"未知";
            break;
    }
    
    switch (_model.OrderStatus.intValue) {
        case 0:
            self.OrderStatus.text = @"未知";
            break;
        case 100:
            self.OrderStatus.text = @"交易成功";
            break;
        case 101:
            self.OrderStatus.text = @"正在处理";
            break;
        case 102:
            self.OrderStatus.text = @"交易失败";
            break;
        default:
            break;
    }
    self.Brokerage.text = [NSString stringWithFormat:@"¥%0.2f",_model.Brokerage.floatValue];;
    
    self.CreatorTime.text = _model.CreatorTime;
    if (_model.IsSettle) {
        self.SettleTime.text = _model.SettleTime;
    }else{
        self.SettleTime.text = @"未到账";
    }
    self.ActualAmount.text = [NSString stringWithFormat:@"¥%0.2f",_model.ActualAmount.floatValue];
    
    if (![_model.InBankName isEqualToString:@""]) {
        self.bankCardNo.text = [NSString stringWithFormat:@"%@(%@)",_model.InBankName,[_model.InCardNo substringWithRange:NSMakeRange(_model.InCardNo.length - 4, 4)]];
        _bankCardViewHeight.constant = 30;
    }
    if (![_model.OutBankName isEqualToString:@""]) {
        self.CreditCardNo.text = [NSString stringWithFormat:@"%@(%@)",_model.OutBankName,[_model.OutCardNo substringWithRange:NSMakeRange(_model.OutCardNo.length - 4, 4)]];
        _creditCardViewHeight.constant = 30;
    }
    
    self.OrderNo.text = _model.OrderNo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
