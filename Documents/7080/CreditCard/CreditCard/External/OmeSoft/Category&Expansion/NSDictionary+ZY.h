//
//  NSDictionary+ZY.h
//  CounterTest
//
//  Created by 廖智尧 on 2017/10/26.
//  Copyright © 2017年 廖智尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ZY)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
-(NSString*)getSignature:(NSString*)privateKey;
@end
