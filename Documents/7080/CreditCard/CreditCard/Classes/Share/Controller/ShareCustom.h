//
//  ShareCustom.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/8.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareCustom : NSObject
/*
 自定义的分享类，使用的是类方法，其他地方只要 构造分享内容publishContent就行了
 */

+(void)shareWithContent:(id)publishContent;      //自定义分享界面

@end
