//
//  PayRecordModel.h
//  CreditCard
//
//  Created by cass on 2018/3/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayRecordModel : NSObject
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) NSString *payDate;
@property (nonatomic, strong) NSString *amtn;
@property (nonatomic, strong) NSString *status;
@end
