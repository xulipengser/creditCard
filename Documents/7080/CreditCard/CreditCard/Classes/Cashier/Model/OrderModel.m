//
//  OrderModel.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/29.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
-(NSString*)CreatorTime{
    return [_CreatorTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
}

-(NSString*)SettleTime{
    return [_SettleTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
}

@end
