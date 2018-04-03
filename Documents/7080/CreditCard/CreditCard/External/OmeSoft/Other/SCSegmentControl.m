//
//  SCSegmentControl.m
//  MediXPub
//
//  Created by sincan on 12-11-23.
//  Copyright (c) 2012年 Omesoft. All rights reserved.
//

#import "SCSegmentControl.h"
#import "OMESoft.h"

@interface SCSegmentControl ()
@property (assign, nonatomic) NSInteger totalItems;
@property (retain, nonatomic) NSMutableArray *selectedImages;
@property (retain, nonatomic) NSMutableArray *backgroundImages;
@property (retain, nonatomic) NSMutableArray *titles;
@property (retain, nonatomic) NSMutableArray *titleColors;
@property (retain, nonatomic) NSMutableArray *titleShadowSizes;
@property (retain, nonatomic) NSMutableArray *titleShadowColors;
@property (retain, nonatomic) NSMutableArray *titleFonts;
@end
@implementation SCSegmentControl
@synthesize totalItems = _totalItems;
@synthesize selectedIndex = _selectedIndex;
@synthesize selectedImages = _selectedImages;
@synthesize backgroundImages = _backgroundImages;
@synthesize titles = _titles;
@synthesize titleColors = _titleColors;
@synthesize titleShadowSizes = _titleShadowSizes;
@synthesize titleShadowColors = _titleShadowColors;
@synthesize titleFonts = _titleFonts;

- (void)dealloc
{
#if __has_feature(objc_arc)
    _selectedImages = nil;
    _backgroundImages = nil;
    _titles = nil;
    _titleColors = nil;
    _titleShadowSizes = nil;
    _titleShadowColors = nil;
    _titleFonts = nil;

#else
    [_selectedImages release];
    [_backgroundImages release];
    [_titles release];
    [_titleColors release];
    [_titleShadowSizes release];
    [_titleShadowColors release];
    [_titleFonts release];
    [super dealloc];
#endif
    
}

//- (id)initWithFrame:(CGRect)frame
//{
//    return [self initWithItemCount:3];
//}
//
//- (id)init
//{
//    return [self initWithItemCount:3];
//}

- (id)initWithItemCount:(NSInteger)count
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.totalItems = count;
        self.selectedIndex = 0;
#if __has_feature(objc_arc)
        self.selectedImages = [[NSMutableArray alloc] initWithCapacity:count];
        self.backgroundImages = [[NSMutableArray alloc] initWithCapacity:count];
        self.titles = [[NSMutableArray alloc] initWithCapacity:count];
        self.titleColors = [[NSMutableArray alloc] initWithCapacity:2];
        self.titleShadowSizes = [[NSMutableArray alloc] initWithCapacity:2];
        self.titleShadowColors = [[NSMutableArray alloc] initWithCapacity:2];
        self.titleFonts = [[NSMutableArray alloc] initWithCapacity:2];
#else
        self.selectedImages = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
        self.backgroundImages = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
        self.titles = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
        self.titleColors = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
        self.titleShadowSizes = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
        self.titleShadowColors = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
        self.titleFonts = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
#endif
        
        for (int i = 0; i < count; i++) {
            [_selectedImages addObject:[[UIImage createImageWithColor:[UIColor redColor]] stretchableImageWithLeftCapWidth:1 topCapHeight:1]];
            [_backgroundImages addObject:[[UIImage createImageWithColor:[UIColor redColor]] stretchableImageWithLeftCapWidth:1 topCapHeight:1]];
            [_titles addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        
        for (int j = 0; j < 2; j++) {
            if (j == 0) {
                [_titleColors addObject:[UIColor colorWithWhite:0 alpha:1.0]];
                [_titleShadowSizes addObject:[NSValue valueWithCGSize:CGSizeMake(0, 0)]];
                [_titleShadowColors addObject:[UIColor blackColor]];

            }else{
                [_titleColors addObject:[UIColor colorWithWhite:1 alpha:1.0]];
                [_titleShadowSizes addObject:[NSValue valueWithCGSize:CGSizeMake(0, 0)]];
                [_titleShadowColors addObject:[UIColor whiteColor]];
            }
            [_titleFonts addObject:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        }
    }
    return self;
}

- (void)setSelectedImage:(UIImage *)img forSegmentAtIndex:(NSInteger)index
{
    if (index > self.totalItems - 1 || img == nil) {
        return;
    }
    [self.selectedImages replaceObjectAtIndex:index withObject:img];
    [self setNeedsDisplay];
}

- (void)setBackgroundImage:(UIImage *)img forSegmentAtIndex:(NSInteger)index
{
    if (index > self.totalItems - 1 || img == nil) {
        return;
    }
    [self.backgroundImages replaceObjectAtIndex:index withObject:img];
    [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)text forSegmentAtIndex:(NSUInteger)index
{
    if (index > self.totalItems - 1 || text == nil) {
        return;
    }
    [self.titles replaceObjectAtIndex:index withObject:text];
    [self setNeedsDisplay];
}

- (void)setTitleColor:(UIColor *)color forSegmentSate:(SCSegmentStat)state
{
    NSInteger index = state== SCSegmentStatNormal ? 0 : 1;
    [self.titleColors replaceObjectAtIndex:index withObject:color];
    [self setNeedsDisplay];
}

- (void)setTitleShadowSize:(CGSize)size forSegmentSate:(SCSegmentStat)state
{
    NSInteger index = state== SCSegmentStatNormal ? 0 : 1;
    [self.titleShadowSizes replaceObjectAtIndex:index withObject:[NSValue valueWithCGSize:size]];
    [self setNeedsDisplay];
    
}

- (void)setTitleShadowColor:(UIColor *)color forSegmentSate:(SCSegmentStat)state
{
    NSInteger index = state== SCSegmentStatNormal ? 0 : 1;
    [self.titleShadowColors replaceObjectAtIndex:index withObject:color];
    [self setNeedsDisplay];
}

- (void)setTitleFont:(UIFont *)font forSegmentSate:(SCSegmentStat)state
{
    NSInteger index = state== SCSegmentStatNormal ? 0 : 1;
    [self.titleFonts replaceObjectAtIndex:index withObject:font];
    [self setNeedsDisplay];
}

- (void)setSelectedIndex:(NSInteger)index
{
    if (index > self.totalItems - 1 || _selectedIndex == index) {
        return;
    }
    _selectedIndex = index;
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == nil) {
        return;
    }
    float width = rect.size.width / (float)self.totalItems;
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    for (int i = 0 ; i < [self.backgroundImages count]; i++) {
        UIImage *img;
        if (i == self.selectedIndex) {
            img = (UIImage *)[self.selectedImages objectAtIndex:i];
        }else{
            img = (UIImage *)[self.backgroundImages objectAtIndex:i];
        }
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextDrawImage(context, CGRectMake(i * width, 0, width, rect.size.height), img.CGImage);
        UIGraphicsEndImageContext();
    }
    CGContextRestoreGState(context);
    for (int j = 0; j < [self.titles count]; j++) {
        NSInteger index = j == self.selectedIndex ? 1 : 0;

        CGContextSaveGState(context);
        if (!CGSizeEqualToSize([[self.titleShadowSizes objectAtIndex:index] CGSizeValue], CGSizeZero)) {
            CGContextSetShadowWithColor(context, [[self.titleShadowSizes objectAtIndex:index] CGSizeValue], 0, [(UIColor *)[self.titleShadowColors objectAtIndex:index] CGColor]);
        }
        CGContextBeginTransparencyLayer(context, NULL);
        UIColor *color = (UIColor *)[self.titleColors objectAtIndex:index];
        [color setFill];
        NSString *titlestr = [self.titles objectAtIndex:j];
        CGSize titlestrSize = HP_MULTILINE_TEXTSIZE(titlestr, (UIFont *)[self.titleFonts objectAtIndex:index], CGSizeMake(width, rect.size.height), NSLineBreakByWordWrapping);
        [titlestr zxdrawAtPoint:CGPointMake((width - titlestrSize.width) / 2 + width * j, (rect.size.height - titlestrSize.height) / 2.0) forWidth:width withFont:(UIFont *)[self.titleFonts objectAtIndex:index] lineBreakMode:NSLineBreakByWordWrapping color:color];
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    float width = self.frame.size.width / (float)self.totalItems;
    NSInteger index = point.x / width;
    if (index > self.totalItems - 1 || self.selectedIndex == index) {
        return;
    }
    self.selectedIndex = index;
    [self performSelector:@selector(sendTouch) withObject:nil afterDelay:0];
}

- (void)sendTouch
{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
@end
