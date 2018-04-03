//
//  BankCardTableViewCell.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "BankCardTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Omesoft.h"

@implementation BankCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCreditCard:(CreditCardModel*)card{
    _bankNameLbl.text = card.BankName;
    [_leftImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ImgBaseURL, card.IcoUrl]]];
    _bankNumLbl.text = [NSString idCardToAsterisk:card.CreditCardNo];
    _bankTypeLbl.text = @"信用卡";
    
}

-(void)setDebitCard:(DebitCardModel*)card{
    if (card.IsDefault){
        _bankNameLbl.text = [NSString stringWithFormat:@"%@(默认)",card.BankName];
    }else{
        _bankNameLbl.text = card.BankName;
    }
    
    [_leftImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ImgBaseURL, card.IcoUrl]]];
    _bankNumLbl.text = [NSString bankCardToAsterisk:card.BankCardNo];
    _bankTypeLbl.text = @"储蓄卡";
}

@end
