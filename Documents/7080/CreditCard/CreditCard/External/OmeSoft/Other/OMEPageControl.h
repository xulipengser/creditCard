//
//  OMEPageControl.h
//  MediX
//
//  Created by zhihai luo on 12-5-7.
//  Copyright (c) 2012年 Omesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMEPageControl : UIPageControl

@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHightlighted;


- (id) initWithFrame:(CGRect)frame;

@end
