//
//  MXProgressView.m
//  Sport
//
//  Created by OMESOFT-112 on 14-6-7.
//  Copyright (c) 2014年 omesoft. All rights reserved.
//

#import "MXProgressView.h"
#import "OMESoft.h"

@implementation MXProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

#pragma mark - setMethods

- (void)setProgress:(CGFloat)newProgress
{
    _progress = fmaxf(0.0f, fminf(1.0f, newProgress));
    [self setNeedsDisplay];
}

- (void)setBarBorderWidth:(CGFloat)barBorderWidth
{
    _barBorderWidth = barBorderWidth;
    [self setNeedsDisplay];
}

- (void)setBarBorderColor:(UIColor *)barBorderColor
{
    _barBorderColor = barBorderColor;
    [self setNeedsDisplay];
}

- (void)setBarInnerBorderWidth:(CGFloat)barInnerBorderWidth
{
    _barInnerBorderWidth = barInnerBorderWidth;
    [self setNeedsDisplay];
}

- (void)setBarInnerBorderColor:(UIColor *)barInnerBorderColor
{
    _barInnerBorderColor = barInnerBorderColor;
    [self setNeedsDisplay];
}

- (void)setBarFillColor:(UIColor *)barFillColor
{
    _barFillColor = barFillColor;
    [self setNeedsDisplay];
}

#pragma  mark - Class Method

+ (UIColor *)defaultBarColor
{
    return [UIColor colorWithHexString:@"#f9e012"];
}

#pragma mark - Private

- (void)initialize
{
    self.contentMode = UIViewContentModeRedraw;
    self.backgroundColor = [UIColor clearColor];
    
    _progress = 0.0f;
    _barBorderWidth = 0.0f;
    _barBorderColor = [[self class] defaultBarColor];
    _barFillColor = self.barBorderColor;
    _barInnerBorderWidth = 0.0f;
    _barInnerBorderColor = nil;
    _barInnerPadding = 0.0f;
    _barBackgroundColor = [UIColor colorWithHexString:@"#505050"];
}

#pragma mark - Drawing Functions

- (void)strokeRoundedRectInContext:(CGContextRef)context CGRect:(CGRect)rect CGFloat:(CGFloat)lineWidth CGFloat:(CGFloat)radius
{
    CGContextSetLineWidth(context, lineWidth);
    [self setRoundedRectPathInContext:context CGRect:rect CGFloat:radius];
    CGContextStrokePath(context);
}

- (void)fillRoundedRectInContext:(CGContextRef)context CGRect:(CGRect)rect CGFloat:(CGFloat)radius
{
    [self setRoundedRectPathInContext:context CGRect:rect CGFloat:radius];
    CGContextFillPath(context);
}

- (void)setRoundedRectPathInContext:(CGContextRef)context CGRect:(CGRect)rect CGFloat:(CGFloat)radius
{
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius);
    CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetAllowsAntialiasing(context, TRUE);
    
    CGRect currentRect = rect;
    CGFloat radius;
    CGFloat halfLineWidth;
    
    // Background
    if (self.backgroundColor) {
        radius = currentRect.size.height / 2;
        [self.barBackgroundColor setFill];
        [self fillRoundedRectInContext:context CGRect:currentRect CGFloat:radius];
    }
    
    // Border
    if (self.barBorderColor && self.barBorderWidth > 0.0f) {
        halfLineWidth = self.barBorderWidth / 2;
        currentRect = CGRectInset(currentRect, halfLineWidth, halfLineWidth);
        radius = currentRect.size.height / 2;
        [self.barBorderColor setStroke];
        [self strokeRoundedRectInContext:context CGRect:currentRect CGFloat:self.barBorderWidth CGFloat:radius];
        currentRect = CGRectInset(currentRect, halfLineWidth, halfLineWidth);
    }
    
    // Padding
    currentRect = CGRectInset(currentRect, self.barInnerPadding, self.barInnerPadding);
    
    BOOL hasInnerBorder = NO;
    // Inner border
    if (self.barInnerBorderColor && self.barInnerBorderWidth > 0.0f) {
        hasInnerBorder = YES;
        halfLineWidth = self.barInnerBorderWidth / 2;
        currentRect = CGRectInset(currentRect, halfLineWidth, halfLineWidth);
        radius = currentRect.size.height / 2;
        // progress
        currentRect.size.width *= self.progress;
        currentRect.size.width = MAX(currentRect.size.width, 2 * radius);
        [self.barInnerBorderColor setStroke];
        [self strokeRoundedRectInContext:context CGRect:currentRect CGFloat:self.barInnerBorderWidth CGFloat:radius];
        currentRect = CGRectInset(currentRect, halfLineWidth, halfLineWidth);
    }
    
    // Fill
    if (self.barFillColor) {
        radius = currentRect.size.height / 2;
        // recalculate width
        if (!hasInnerBorder) {
            currentRect.size.width *= self.progress;
            currentRect.size.width = MAX(currentRect.size.width, 2 * radius);
        }
        
        [self.barFillColor setFill];
        [self fillRoundedRectInContext:context CGRect:currentRect CGFloat:radius];
    }
    
    // Restore the context
    CGContextRestoreGState(context);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
