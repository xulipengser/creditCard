//
//  RealNameAuthViewController.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/6.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealNameAuthViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *cardBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end
