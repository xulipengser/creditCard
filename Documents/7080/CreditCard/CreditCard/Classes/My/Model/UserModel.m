//
//  UserModel.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/22.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel



-(NSString*)AuthTime{
    return [_AuthTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
}
-(NSString*)RegisterTime{
    return [_RegisterTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
}


@end
