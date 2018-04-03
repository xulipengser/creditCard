//
//  TextFieldAlertView.h
//  Hypnotist
//
//  Created by OmeSoft-iOS on 14/12/5.
//
//

#import <UIKit/UIKit.h>

@protocol TextFieldAlertViewDelegate;
@interface TextFieldAlertView : UIView

@property (assign, nonatomic) id <TextFieldAlertViewDelegate> delegate;
@property (strong, nonatomic) UITextField *textField;
- (id)initWithTitle:(NSString *)title Message:(NSString *)message CancelButtonTitle:(NSString *)cancelButtonTitle OtherButtonTitle:(NSString *)otherButtonTitle;
- (void)showIn:(UIView *)view;
- (void)dismiss;
@end

@protocol TextFieldAlertViewDelegate <NSObject>

- (void)textFieldAlertView:(TextFieldAlertView *)view buttonDidSelected:(NSInteger)tag;

@end