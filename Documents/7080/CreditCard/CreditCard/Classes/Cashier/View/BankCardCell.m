//
//  BankCardCell.m
//  CreditCard
//
//  Created by cass on 2018/3/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "BankCardCell.h"

#import "YYKit.h"
@interface BankCardCell()

@property (nonatomic, strong) UIImageView *bankIconImageView;
@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
@end

@implementation BankCardCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    _bankIconImageView = [[UIImageView alloc] init];
    _bankIconImageView.size = CGSizeMake(44, 44);
    _bankIconImageView.centerY = kBankCardCellHeight / 2;
    _bankIconImageView.left = 15;
    _bankIconImageView.layer.cornerRadius = _bankIconImageView.height / 2;
    _bankIconImageView.layer.masksToBounds = YES;
    _bankIconImageView.backgroundColor = [UIColor redColor];
    [self addSubview:_bankIconImageView];
    
    _bankNameLabel = [[UILabel alloc] init];
    _bankNameLabel.font = [UIFont systemFontOfSize:17];
    _bankNameLabel.textColor = [UIColor blackColor];
    _bankNameLabel.text = @"中国工商银行";
    _bankNameLabel.height = 18;
    _bankNameLabel.left = _bankIconImageView.right + 14;
    _bankNameLabel.width = self.width - _bankNameLabel.left - 10;
    _bankNameLabel.bottom = _bankIconImageView.centerY - 4;
    [self addSubview:_bankNameLabel];
    
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.text = @"尾号1231储蓄卡";
    _numberLabel.font = [UIFont systemFontOfSize:14];
    _numberLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _numberLabel.height = 15;
    _numberLabel.left = _bankNameLabel.left;
    _numberLabel.width = _bankNameLabel.width;
    _numberLabel.top = _bankIconImageView.centerY + 4;
    [self addSubview:_numberLabel];
    
    _markImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_selected_mark"]];
    _markImageView.size = _markImageView.image.size;
    _markImageView.centerY = kBankCardCellHeight / 2;
    _markImageView.right = kScreenWidth - 15;
    _markImageView.hidden = YES;
    [self addSubview:_markImageView];
    
    _topLine = [CALayer layer];
    _topLine.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"].CGColor;
    _topLine.height = 0.5;
    _topLine.width = kScreenWidth;
    _topLine.hidden = YES;
    [self.layer addSublayer:_topLine];
    
    _bottomLine = [CALayer layer];
    _bottomLine.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"].CGColor;
    _bottomLine.height = 0.5;
    _bottomLine.left = 15;
    _bottomLine.width = kScreenWidth - _bottomLine.left;
    _bottomLine.bottom = kBankCardCellHeight;
    [self.layer addSublayer:_bottomLine];
    
    return self;
}

- (void)setModel:(BankCardModel *)model {
    _model = model;
    
    
    [_bankIconImageView setImageWithURL:[NSURL URLWithString:model.bankIconUrl] placeholder:nil];
    _bankNameLabel.text = model.bankName;
    NSString *cardNumber = model.cardNumber;
    if (model.cardNumber.length >= 4) {
        cardNumber = [model.cardNumber substringWithRange:NSMakeRange(model.cardNumber.length - 4, 4)];
    }
    if (cardNumber != nil && ![cardNumber isEqualToString:@""]) {
        _numberLabel.text = [NSString stringWithFormat:@"尾号:%@ 储蓄卡", cardNumber];
    }
}

- (void)setFirstCell:(BOOL)firstCell {
    _firstCell = firstCell;
    _topLine.hidden = firstCell;
}

- (void)setLastCell:(BOOL)lastCell {
    _lastCell = lastCell;
    if (_lastCell) {
        _bottomLine.left = 0;
        _bottomLine.width = kScreenWidth;
    } else {
        _bottomLine.left = 15;
        _bottomLine.width = kScreenWidth - _bottomLine.left;
    }
}

- (void)setMark:(BOOL)mark {
    _mark = mark;
    _markImageView.hidden = !_mark;
}


@end
