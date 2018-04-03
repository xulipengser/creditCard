//
//  CardChoiceControl.m
//  CreditCard
//
//  Created by cass on 2018/3/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "CardChoiceControl.h"
#import "YYKit.h"
@interface CardChoiceControl()
@property (nonatomic, strong) UILabel *cardTitleLabel;
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UILabel *cardNameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@end

@implementation CardChoiceControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.height = 109;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    
    _cardTitleLabel = [[UILabel alloc] init];
    _cardTitleLabel.text = @"";
    _cardTitleLabel.font = [UIFont systemFontOfSize:16];
    _cardTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _cardTitleLabel.height = 17;
    _cardTitleLabel.left = 18;
    _cardTitleLabel.width = self.width - _cardTitleLabel.left;
    _cardTitleLabel.top = 14;
    [self addSubview:_cardTitleLabel];
    
    
    _cardImageView = [[UIImageView alloc] init];
    _cardImageView.size = CGSizeMake(44, 44);
    _cardImageView.top = _cardTitleLabel.bottom + 24;
    _cardImageView.left = _cardTitleLabel.left;
    _cardImageView.layer.cornerRadius = _cardImageView.height / 2;
    _cardImageView.layer.masksToBounds = YES;
//    _cardImageView.backgroundColor = [UIColor redColor];
    [self addSubview:_cardImageView];
    
    _cardNameLabel = [[UILabel alloc] init];
    _cardNameLabel.font = [UIFont systemFontOfSize:16];
    _cardNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _cardNameLabel.text = @"--";
    _cardNameLabel.height = 17;
    _cardNameLabel.left = _cardImageView.right + 14;
    _cardNameLabel.width = self.width - _cardNameLabel.left - 10;
    _cardNameLabel.bottom = _cardImageView.centerY - 4;
    [self addSubview:_cardNameLabel];
    
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.text = @"--";
    _numberLabel.font = [UIFont systemFontOfSize:16];
    _numberLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _numberLabel.height = _cardNameLabel.height;
    _numberLabel.left = _cardNameLabel.left;
    _numberLabel.width = _cardNameLabel.width;
    _numberLabel.top = _cardImageView.centerY + 4;
    [self addSubview:_numberLabel];
    
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    arrowImageView.size = arrowImageView.image.size;
    arrowImageView.right = self.width - 10;
    arrowImageView.bottom = self.height - 24;
    [self addSubview:arrowImageView];
    return self;
}

- (void)setModel:(CardChoiceControlModel *)model {
    _model = model;
    NSString *cardType = nil;
    if (_model.cardType == CardTypeCreditCard) {
        cardType = @"信用卡";
        _cardTitleLabel.text =@"选择信用卡";
    } else {
        cardType = @"储蓄卡";
        _cardTitleLabel.text =@"选择结算卡";
    }
    
    [_cardImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ImgBaseURL, model.cardImageUrl]] placeholder:nil];
    if (model.cardName != nil && ![model.cardName isEqualToString:@""]) {
        _cardNameLabel.text = model.cardName;
    }
    NSString *cardNumber = model.cardNumber;
    if (model.cardNumber.length >= 4) {
        cardNumber = [model.cardNumber substringWithRange:NSMakeRange(model.cardNumber.length - 4, 4)];
    }
    if (cardNumber != nil && ![cardNumber isEqualToString:@""]) {
        _numberLabel.text = [NSString stringWithFormat:@"尾号%@ %@", cardNumber, cardType];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context =UIGraphicsGetCurrentContext();
    // 设置线条的样式
    CGContextSetLineCap(context, kCGLineCapRound);
    // 绘制线的宽度
    CGContextSetLineWidth(context, 0.5);

    // 线的颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#dcdcdc"].CGColor);
    // 开始绘制
    CGContextBeginPath(context);
    // 设置虚线绘制起点
    CGContextMoveToPoint(context, 19.5, 44.0);
    // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
    CGFloat lengths[] = {6.5,2.5};
    // 虚线的起始点
    CGContextSetLineDash(context, 0, lengths,2);
    // 绘制虚线的终点
    CGContextAddLineToPoint(context, self.width - 6.5,44.0);
    // 绘制
    CGContextStrokePath(context);
    // 关闭图像
    CGContextClosePath(context);
}

@end
