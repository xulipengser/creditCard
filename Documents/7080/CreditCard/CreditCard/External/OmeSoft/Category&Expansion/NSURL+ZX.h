//
//  NSURL+ZX.h
//  OMESOFT
//
//  Created by omesoft on 15-1-13.
//  Copyright (c) 2015年 Xin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ZX)

/**@brief 获取网页链接传递的参数
 */
- (NSDictionary *)parametersInfo;

/**@brief 获取网页链接传递的参数为Json
 */
- (NSDictionary *)jsonParameters;
- (BOOL)addSkipBackupAttribute;
@end

@interface NSString (ZX)
- (NSString *)URLDecoded;
@end
