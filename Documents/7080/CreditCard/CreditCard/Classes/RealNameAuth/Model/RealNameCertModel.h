//
//  RealNameCertModel.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/14.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealNameCertModel : NSObject
@property(nonatomic, strong) NSString *UserID;
@property(nonatomic, strong) NSString *RealName;
@property(nonatomic, strong) NSString *IdCardNo;
@property(nonatomic, strong) NSString *BankMobile;       // 银行预留手机号
@property(nonatomic, strong) NSString *BankCardNo;
@property(nonatomic, strong) NSString *BankId;
@property(nonatomic, strong) NSString *IdCardImgUrl;
@property(nonatomic, strong) NSString *BankCardImgUrl;
@property(nonatomic, strong) NSString *HoldIdCardImgUrl;
@property(nonatomic, strong) NSString *Signature;
// 下面是过程中用到的
@property(nonatomic, strong) UIImage *IdCardImg;      // 身份证照片
@property(nonatomic, strong) UIImage *BankCardImg;    // 银行卡照片
@property(nonatomic, strong) UIImage *HoldIdCardImg;  // 手持身份证照片
@end
