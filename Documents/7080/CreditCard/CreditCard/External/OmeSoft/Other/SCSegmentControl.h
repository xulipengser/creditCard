//
//  SCSegmentControl.h
//  MediXPub
//
//  Created by sincan on 12-11-23.
//  Copyright (c) 2012年 Omesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SCSegmentStatNormal,
    SCSegmentStatSelected
}SCSegmentStat;

@interface SCSegmentControl : UIControl
{
    NSInteger selectedIndex;
}
@property (nonatomic) NSInteger selectedIndex;


- (id)initWithItemCount:(NSInteger)count;
- (void)setSelectedImage:(UIImage *)img forSegmentAtIndex:(NSInteger)index;
- (void)setBackgroundImage:(UIImage *)img forSegmentAtIndex:(NSInteger)index;
- (void)setTitle:(NSString *)text forSegmentAtIndex:(NSUInteger)index;
- (void)setTitleColor:(UIColor *)color forSegmentSate:(SCSegmentStat)state;
- (void)setTitleShadowSize:(CGSize)size forSegmentSate:(SCSegmentStat)state;
- (void)setTitleShadowColor:(UIColor *)color forSegmentSate:(SCSegmentStat)state;
- (void)setTitleFont:(UIFont *)font forSegmentSate:(SCSegmentStat)state;
@end
