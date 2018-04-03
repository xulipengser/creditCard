//
//  UserModel.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/22.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property(nonatomic, strong) NSString *UserID;           // App用户表主键
@property(nonatomic, strong) NSString *MerchantNo;       // 平台商户号
@property(nonatomic, strong) NSString *RealName;         // 用户真实姓名
@property(nonatomic, strong) NSString *IdCardNo;         // 用户身份证号
@property(nonatomic, strong) NSString *ParentId1;        // 一级分销上级用户Id
@property(nonatomic, strong) NSString *ParentId2;        // 二级分销上级用户Id
@property(nonatomic, strong) NSString *ParentId3;        // 三级分销上级用户Id
@property(nonatomic, strong) NSString *MobilePhone;      // 手机号(登录账号)
@property(nonatomic, strong) NSString *HeadImgUrl;       // 头像路径
@property(nonatomic, assign) NSNumber *AuthStatus;;       // 实名状态
@property(nonatomic, strong) NSString *IdCardImgUrl;     // 身份证正面照Url
@property(nonatomic, strong) NSString *BankCardImgUrl;   // 银行卡正面照Url
@property(nonatomic, strong) NSString *HoldIdCardImgUrl; // 手持身份证照片Url
@property(nonatomic, strong) NSString *AuthTime;     // 实名认证时间
@property(nonatomic, strong) NSString *RankId;       // 会员等级Id
@property(nonatomic, strong) NSString *RankName;    //会员等级名称
@property(nonatomic, strong) NSNumber *Rate;         // 还款费率
@property(nonatomic, strong) NSNumber *Brokerage;    // 还款基本手续费率
@property(nonatomic, strong) NSNumber *WRate;         // 提现费率
@property(nonatomic, strong) NSNumber *WBrokerage;    // 提现基本手续费

@property(nonatomic, strong) NSNumber *Balance;       // 还款金总余额
@property(nonatomic, strong) NSNumber *AbleBalance;   // 还款金可用余额
@property(nonatomic, strong) NSNumber *UnAbleBalance; // 还款金冻结余额


@property(nonatomic, strong) NSNumber *WBalance;      // 用户可提现余额
@property(nonatomic, strong) NSNumber *WAbleBalance;      // 可用可提现余额
@property(nonatomic, strong) NSNumber *WUnAbleBalance;      // 冻结可提现余额

@property(nonatomic, strong) NSString *DeleteMark;   // 删除标志
@property(nonatomic, strong) NSString *EnabledMark;  // 有效标志
@property(nonatomic, strong) NSString *RegisterTime;
@end
