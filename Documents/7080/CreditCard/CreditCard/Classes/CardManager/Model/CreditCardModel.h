//
//  CreditCardModel.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/27.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <Foundation/Foundation.h>

// 信用卡
@interface CreditCardModel : NSObject
@property(nonatomic, strong) NSString *CreditCardID;
@property(nonatomic, strong) NSString *BankId;
@property(nonatomic, strong) NSString *BankName;
@property(nonatomic, strong) NSString *BranchBankName;
@property(nonatomic, strong) NSString *CreditCardNo;
@property(nonatomic, strong) NSString *RealName;
@property(nonatomic, strong) NSString *IdCardNo;
@property(nonatomic, strong) NSString *BankPhone;
@property(nonatomic, strong) NSString *IcoUrl;
@property(nonatomic, strong) NSString *BgUrl;
@property(nonatomic, strong) NSString *BillDate;
@property(nonatomic, strong) NSString *RepayDate;
@end
