//
//  OrderModel.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/29.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
@property (nonatomic, strong) NSString *Id;//主键
@property (nonatomic, strong) NSString *MerchantNo;//商户号
@property (nonatomic, strong) NSString *OrderNo;//订单号
@property (nonatomic, strong) NSString *AppUserId;//App用户Id
@property (nonatomic, strong) NSNumber *OrderType;//订单类型
@property (nonatomic, strong) NSNumber *OrderStatus;//订单状态
@property (nonatomic, strong) NSNumber *Amount;//金额
@property (nonatomic, strong) NSNumber *ActualAmount;//实际到账金额
@property (nonatomic, strong) NSString *InCardNo;//入账卡号
@property(nonatomic, strong) NSString *InBankName;//入账银行
@property (nonatomic, strong) NSString *OutCardNo;//出账卡号
@property(nonatomic, strong) NSString *OutBankName;//出账银行

@property (nonatomic, strong) NSString *Rate;//本次交易费率
@property (nonatomic, strong) NSNumber *Brokerage;//本次交易手续费
@property (nonatomic, strong) NSString *Description;//备注
@property (nonatomic, strong) NSString *CreatorTime;//创建时间
@property(nonatomic, strong) NSString *SettleTime;//到账时间
@property(nonatomic) bool IsSettle;//是否到账
@end
