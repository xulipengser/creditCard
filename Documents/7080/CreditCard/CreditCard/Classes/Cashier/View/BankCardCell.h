//
//  BankCardCell.h
//  CreditCard
//
//  Created by cass on 2018/3/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardModel.h"
#define kBankCardCellHeight 67
@interface BankCardCell : UITableViewCell
@property (nonatomic, strong) BankCardModel *model;
@property (nonatomic) BOOL firstCell;
@property (nonatomic) BOOL lastCell;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic) BOOL mark;
@end
