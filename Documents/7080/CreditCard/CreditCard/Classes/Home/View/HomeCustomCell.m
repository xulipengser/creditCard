//
//  HomeCustomCell.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/5.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "HomeCustomCell.h"

@implementation HomeCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.homeImgView.layer.cornerRadius = 10;
    self.homeImgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
