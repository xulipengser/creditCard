//
//  RealNameAuthViewController3.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/23.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RealNameCertModel;

@interface RealNameAuthViewController3 : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;

- (instancetype)initWithModel:(RealNameCertModel *)realNameModel;

@end
