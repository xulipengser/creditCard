//
//  AccountUpdateViewController.h
//  CreditCard
//
//  Created by cass on 2018/3/25.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankInfo.h"
@interface AccountUpdateViewController : UIViewController
@property(nonatomic, strong) NSArray *rankInfoList;
@property(nonatomic, strong) RankInfo *rankInfo;
@end
