//
//  AccountUpdateCellTableViewCell.h
//  CreditCard
//
//  Created by cass on 2018/3/25.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountUpdateModel;

typedef void(^AccountUpdateDidClickPayButtonBlock)(AccountUpdateModel *model, UITableViewCell *cell);
@interface AccountUpdateCell : UITableViewCell
@property (nonatomic, strong) AccountUpdateModel *model;
@property (nonatomic, copy) AccountUpdateDidClickPayButtonBlock didClickPayBlock;
@end
