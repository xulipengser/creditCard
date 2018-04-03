//
//  BankCardTableViewCell.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditCardModel.h"
#import "DebitCardModel.h"
@interface BankCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *bankTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLbl;
-(void)setCreditCard:(CreditCardModel*)card;
-(void)setDebitCard:(DebitCardModel*)card;
@end
