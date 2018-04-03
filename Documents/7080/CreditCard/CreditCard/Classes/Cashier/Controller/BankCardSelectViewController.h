//
//  BankCardSelectViewController.h
//  CreditCard
//
//  Created by cass on 2018/3/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardModel.h"
typedef void(^BankCardSelectViewControllerDidSelectBlock)(id model,UIViewController *controller);
@interface BankCardSelectViewController : UIViewController
@property (nonatomic, strong) BankCardSelectViewControllerDidSelectBlock didSelectBlock;
@property(nonatomic) long type;
@end
