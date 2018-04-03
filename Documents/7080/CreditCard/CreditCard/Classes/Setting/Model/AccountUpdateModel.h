//
//  AccountUpdateModel.h
//  CreditCard
//
//  Created by cass on 2018/3/25.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountUpdateModel : NSObject
@property (nonatomic, strong) NSString *currentMember;
@property (nonatomic, strong) NSString *updateMember;
@property(nonatomic, strong) NSString *UpGradeRankID;
@property (nonatomic) CGFloat price;

@end
