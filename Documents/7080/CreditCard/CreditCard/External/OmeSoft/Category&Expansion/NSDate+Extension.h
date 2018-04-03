//
//  NSDate+Extension.h
//  Weibo
//
//  Created by LiaoZhiyao on 15/9/25.
//  Copyright (c) 2015年 LiaoZhiyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear;
/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday;

@end
