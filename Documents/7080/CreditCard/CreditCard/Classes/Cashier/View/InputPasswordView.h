//
//  InputPasswordView.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/29.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^InputPasswordViewSure)(NSString* password);
@interface InputPasswordView : UIView
@property(nonatomic, strong) InputPasswordViewSure myblock;
+(instancetype)Load;
- (void)showInView:(UIView *)view;
-(void)show:(InputPasswordViewSure)myblock;
@end
