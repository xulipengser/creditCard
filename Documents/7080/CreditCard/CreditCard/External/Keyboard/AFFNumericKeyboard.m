//
//  CustomKeyboard.m
//  keyboard
//
//  Created by zhaowang on 14-3-25.
//  Copyright (c) 2014年 anyfish. All rights reserved.
//

#import "AFFNumericKeyboard.h"
#import "OMESoft.h"
#define kLineWidth 1
#define kNumFont [UIFont systemFontOfSize:27]
#define kRatioWidth ([[UIScreen mainScreen] bounds].size.width > 320.0f ? [[UIScreen mainScreen] bounds].size.width / 320.0f : 1.0)

@implementation AFFNumericKeyboard

- (id)initWithFrame:(CGRect)frame WithType:(keyboardType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        //
        arrLetter = [NSArray arrayWithObjects:@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"PQRS",@"TUV",@"WXYZ", nil];
        
        
        //
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                [self addSubview:button];
            }
        }
        
        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];
        //
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(105*kRatioWidth, 0, kLineWidth, 216)];
        line1.backgroundColor = color;
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(214*kRatioWidth, 0, kLineWidth, 216)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        for (int i=0; i<3; i++)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54*(i+1), frame.size.width, kLineWidth)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
        
        if (self.type == keyboardTypeScan) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 216, frame.size.width, 50)];
            btn.backgroundColor = [UIColor colorWithHexString:MainColor];
            [btn setTitle:@"开始扫码" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(beganScanClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

-(UIButton *)creatButtonWithX:(NSInteger) x Y:(NSInteger) y
{
    UIButton *button;
    //
    CGFloat frameX;
    CGFloat frameW;
    switch (y)
    {
        case 0:
            frameX = 0.0;
            frameW = 106.0*kRatioWidth;
            break;
        case 1:
            frameX = 105.0*kRatioWidth;
            frameW = 110.0*kRatioWidth;
            break;
        case 2:
            frameX = 214.0*kRatioWidth;
            frameW = 106.0*kRatioWidth;
            break;
            
        default:
            break;
    }
    CGFloat frameY = 54*x;
    
    //
    button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, frameW, 54)];
    
    //
    NSInteger num = y+3*x+1;
    button.tag = num;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *colorNormal = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
    UIColor *colorHightlighted = [UIColor colorWithHexString:@"#d1d5db"];
    
    if (num == 10 || num == 12)
    {
        UIColor *colorTemp = colorNormal;
        colorNormal = colorHightlighted;
        colorHightlighted = colorTemp;
    }
    button.backgroundColor = colorNormal;
    CGSize imageSize = CGSizeMake(frameW, 54);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [colorHightlighted set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [button setImage:pressedColorImg forState:UIControlStateHighlighted];
    
    

    if (num<10)
    {
        UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, frameW, 28)];
        labelNum.text = [NSString stringWithFormat:@"%ld",(long)num];
        labelNum.textColor = [UIColor blackColor];
        labelNum.textAlignment = NSTextAlignmentCenter;
        labelNum.font = kNumFont;
        [button addSubview:labelNum];
        
        if (num != 1)
        {
            UILabel *labelLetter = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, frameW, 16)];
            labelLetter.text = [arrLetter objectAtIndex:num-2];
            labelLetter.textColor = [UIColor blackColor];
            labelLetter.textAlignment = NSTextAlignmentCenter;
            labelLetter.font = [UIFont systemFontOfSize:12];
            [button addSubview:labelLetter];
        }
    }
    else if (num == 11)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.text = @"0";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kNumFont;
        [button addSubview:label];
    }
    else if (num == 10)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.text = @".";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
    else
    {
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(42*kRatioWidth, 19, 22, 17)];
        arrow.image = [UIImage imageNamed:@"arrowInKeyboard"];
        [button addSubview:arrow];
        
    }
    
    return button;
}

- (void)beganScanClick
{
    if ([self.delegate respondsToSelector:@selector(beganScan)]) {
        [self.delegate beganScan];
    }
}

-(void)clickButton:(UIButton *)sender
{
    if (sender.tag == 10)
    {
        if ([self.delegate respondsToSelector:@selector(writeInRadixPoint)]) {
            [self.delegate writeInRadixPoint];
        }
        
        return;
    }
    else if(sender.tag == 12)
    {
        if ([self.delegate respondsToSelector:@selector(numberKeyboardBackspace)]) {
            [self.delegate numberKeyboardBackspace];
        }
        
    }
    else
    {
        NSInteger num = sender.tag;
        if (sender.tag == 11)
        {
            num = 0;
        }
        if ([self.delegate respondsToSelector:@selector(numberKeyboardInput:)]) {
            [self.delegate numberKeyboardInput:num];
        }
        
    }
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
