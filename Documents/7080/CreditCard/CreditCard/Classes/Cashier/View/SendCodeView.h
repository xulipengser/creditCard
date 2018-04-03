//
//  SendCodeView.h
//  CreditCard
//
//  Created by cass on 2018/3/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendCodeView : UIView
@property (nonatomic, strong) NSString *phoneNumber;
- (void)showInView:(UIView *)view;
@end
