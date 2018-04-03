//
//  DebitCardModel.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/27.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <Foundation/Foundation.h>

// 借记卡
@interface DebitCardModel : NSObject
@property(nonatomic, strong) NSString *DebitCardID;//借记卡ID
@property(nonatomic, strong) NSString *BankId;//银行Id
@property(nonatomic, strong) NSString *BankName;//银行名称
@property(nonatomic, strong) NSString *BranchBankName;//支行名称
@property(nonatomic, strong) NSString *BankCardNo;//借记卡号
@property(nonatomic, strong) NSString *RealName;//卡主真实姓名
@property(nonatomic, strong) NSString *IdCardNo;//卡主身份证号
@property(nonatomic, strong) NSString *BankPhone;//银行预留手机号
@property(nonatomic, strong) NSString *IcoUrl;//银行图标Url
@property(nonatomic, strong) NSString *BgUrl;//银行背景图Url
@property(nonatomic) bool IsDefault;//是否默认卡（0：否，1：是）
@end
