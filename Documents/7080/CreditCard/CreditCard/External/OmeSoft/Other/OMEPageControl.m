//
//  OMEPageControl.m
//  MediX
//
//  Created by zhihai luo on 12-5-7.
//  Copyright (c) 2012年 Omesoft. All rights reserved.
//

#import "OMEPageControl.h"

@interface OMEPageControl ()
- (void)updateDots;
@end

@implementation OMEPageControl
@synthesize imagePageStateNormal = _imagePageStateNormal, imagePageStateHightlighted = _imagePageStateHightlighted;

- (void)dealloc
{

#if __has_feature(objc_arc)
    _imagePageStateHightlighted = nil;
    _imagePageStateNormal = nil;
#else
    [_imagePageStateHightlighted release];
    [_imagePageStateNormal release];
    [super dealloc];
#endif
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    #if __has_feature(objc_arc)
        self.imagePageStateNormal = [[UIImage alloc] init];
        self.imagePageStateHightlighted = [[UIImage alloc] init];
    #else
        self.imagePageStateNormal = [[[UIImage alloc] init] autorelease];
        self.imagePageStateHightlighted = [[[UIImage alloc] init] autorelease];
    #endif
        
    }
    return self;
}

- (void) setImagePageStateNormal:(UIImage *)image
{
#if __has_feature(objc_arc)
    _imagePageStateNormal = image;
#else
    [_imagePageStateNormal release];
	_imagePageStateNormal = [image retain];
#endif
	[self updateDots];
}

- (void) setImagePageStateHightlighted:(UIImage *)image
{
#if __has_feature(objc_arc)
    _imagePageStateHightlighted = image;
#else
    [_imagePageStateHightlighted release];
	_imagePageStateHightlighted = [image retain];
#endif
	[self updateDots];
}

- (void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) {
            if ([dot respondsToSelector:@selector(setImage:)]) {
                dot.image = _imagePageStateHightlighted;
            }
        } else {
            if ([dot respondsToSelector:@selector(setImage:)]) {
                 dot.image = _imagePageStateNormal;
            }
           
        }
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

@end
