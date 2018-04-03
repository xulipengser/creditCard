//
//  MXProgressView.h
//  Sport
//
//  Created by OMESOFT-112 on 14-6-7.
//  Copyright (c) 2014年 omesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXProgressView : UIView
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat barBorderWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor *barBorderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat barInnerBorderWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor *barInnerBorderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat barInnerPadding UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor *barFillColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor *barBackgroundColor UI_APPEARANCE_SELECTOR;

+ (UIColor *)defaultBarColor;
@end
