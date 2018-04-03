//
//  MyHeaderView.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/9.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "MyHeaderView.h"

@implementation MyHeaderView

- (void)layoutSubviews
{
    [super layoutSubviews];
    _btn1.titleEdgeInsets = UIEdgeInsetsMake(_btn1.imageView.frame.size.height, -_btn1.imageView.frame.size.width, 0, 0);
    _btn1.imageEdgeInsets = UIEdgeInsetsMake(-_btn1.titleLabel.bounds.size.height-15, 0, 0, -_btn1.titleLabel.bounds.size.width);
    
    _btn2.titleEdgeInsets = UIEdgeInsetsMake(_btn2.imageView.frame.size.height, -_btn2.imageView.frame.size.width, 0, 0);
    _btn2.imageEdgeInsets = UIEdgeInsetsMake(-_btn2.titleLabel.bounds.size.height-15, 0, 0, -_btn2.titleLabel.bounds.size.width);
    
    _btn3.titleEdgeInsets = UIEdgeInsetsMake(_btn3.imageView.frame.size.height, -_btn3.imageView.frame.size.width, 0, 0);
    _btn3.imageEdgeInsets = UIEdgeInsetsMake(-_btn3.titleLabel.bounds.size.height-15, 0, 0, -_btn3.titleLabel.bounds.size.width);
    
    _headBtn.layer.cornerRadius = 18;
}

@end
