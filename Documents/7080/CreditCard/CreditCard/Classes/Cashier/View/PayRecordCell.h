//
//  PayRecordCell.h
//  CreditCard
//
//  Created by cass on 2018/3/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#define kPayRecordCellHeight 65.5
#define kPayRecordCellWidth (kScreenWidth - 9 * 2)
@interface PayRecordCell : UITableViewCell
@property (nonatomic, strong) OrderModel *model;
@end
