//
//  RankInfo.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/29.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankInfo : NSObject
@property(nonatomic, strong) NSString *Id;           // 主键
@property(nonatomic, strong) NSString *RankName;     // 等级名称
@property(nonatomic, strong) NSString *IcoUrl;       // 图标Url
@property(nonatomic, strong) NSNumber *Rate;         // 还款费率
@property(nonatomic, strong) NSNumber *Brokerage;            // 还款基本手续费
@property(nonatomic, strong) NSNumber *UpGradeBrokerage;     // 升级所需手续费
@property(nonatomic, strong) NSNumber *Level1Rate;           //一级费率分佣
@property(nonatomic, strong) NSNumber *Level2Rate;           //二级费率分佣
@property(nonatomic, strong) NSNumber *Level3Rate;           //代理费率分佣
@property(nonatomic, strong) NSNumber *Level1UpGradeBrokerage;//一级升级手续费分佣
@property(nonatomic, strong) NSNumber *Level2UpGradeBrokerage;//二级升级手续费分佣
@property(nonatomic, strong) NSNumber *Level3UpGradeBrokerage;//代理升级手续费分佣
@property(nonatomic, strong) NSNumber *SortCode;//排序ma码


@end
