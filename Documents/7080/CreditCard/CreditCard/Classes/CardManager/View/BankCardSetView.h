//
//  BankCardSetView.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/31.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BankCardSetViewSure)(void);
@interface BankCardSetView : UIView
+(void)LoadDel:(BankCardSetViewSure)delblock Def:(BankCardSetViewSure)defblock;
@end
