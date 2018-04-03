//
//  CustomKeyboard.h
//  keyboard
//
//  Created by zhaowang on 14-3-25.
//  Copyright (c) 2014年 anyfish. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    keyboardTypeScan,
    keyboardTypeQrCode
} keyboardType;

@protocol AFFNumericKeyboardDelegate <NSObject>

- (void) numberKeyboardInput:(NSInteger) number;
- (void) numberKeyboardBackspace;
- (void) writeInRadixPoint;
@optional
- (void) beganScan;
@end

@interface AFFNumericKeyboard : UIView
{
    NSArray *arrLetter;
}
@property(nonatomic, assign) keyboardType type;
- (id)initWithFrame:(CGRect)frame WithType:(keyboardType)type;
@property (nonatomic,assign) id<AFFNumericKeyboardDelegate> delegate;
@end
