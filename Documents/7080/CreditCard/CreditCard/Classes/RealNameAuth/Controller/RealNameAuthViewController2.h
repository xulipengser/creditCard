//
//  RealNameAuthViewController2.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/23.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RealNameCertModel;

@interface RealNameAuthViewController2 : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UITextField *bankTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

- (instancetype)initWithModel:(RealNameCertModel *)realNameModel;

@end
