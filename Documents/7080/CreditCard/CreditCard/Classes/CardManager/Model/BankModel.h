//
//  BankModel.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/27.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankModel : NSObject
@property(nonatomic, strong) NSString *Id;
@property(nonatomic, strong) NSString *BankName;
@property(nonatomic, strong) NSString *IcoUrl;
@property(nonatomic, strong) NSString *BgUrl;
@property(nonatomic, strong) NSString *SortCode;
@end
