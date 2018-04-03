//
//  NSDictionary+ZY.m
//  CounterTest
//
//  Created by 廖智尧 on 2017/10/26.
//  Copyright © 2017年 廖智尧. All rights reserved.
//

#import "NSDictionary+ZY.h"

@implementation NSDictionary (ZY)
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(NSString*)getSignature:(NSString*)privateKey{
    if ([self.allKeys indexOfObject:@"FuckHacker"] > 100){
        [self setValue:[[NSString stringWithFormat:@"%f",[[NSDate new]timeIntervalSince1970]] MD5] forKey:@"FuckHacker"];//指定每次不同参数
    }
    
    NSArray* newArr =  [self.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString* str = [NSString stringWithFormat:@""];
    for (NSString* key in newArr) {
        id value = self[key];
        NSString* testStr = @"";
        if ([value isKindOfClass:[NSNumber class]]){
            NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
            testStr = [fmt stringFromNumber:value];
            
        }
        
        if ([value isKindOfClass:[NSString class]]){
            testStr = value;
        }
        
        if (![testStr isEqualToString:@""] ){
            str = [NSString stringWithFormat:@"%@%@=%@&",str,key,testStr];
        }
    }
    
    NSString* resultStr = [str substringToIndex:str.length-1];
    resultStr = [NSString stringWithFormat:@"%@&%@",resultStr,privateKey];
    return resultStr.MD5;
}

@end
