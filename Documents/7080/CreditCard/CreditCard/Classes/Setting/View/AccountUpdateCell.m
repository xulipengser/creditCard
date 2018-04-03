//
//  AccountUpdateCellTableViewCell.m
//  CreditCard
//
//  Created by cass on 2018/3/25.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "AccountUpdateCell.h"
#import "AccountUpdateModel.h"
#import "YYKit.h"
@interface AccountUpdateCell()
@property (nonatomic, strong) UILabel *currentAccountLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *payButton;
@end

@implementation AccountUpdateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    CALayer *topBackground = [CALayer layer];
    topBackground.backgroundColor = [UIColor colorWithHexString:@"#464646"].CGColor;
    topBackground.size = CGSizeMake(kScreenWidth - 5 * 2 * HPFrameRatioWidth, 63);
    [self.layer addSublayer:topBackground];
    
    _currentAccountLabel = [[UILabel alloc] init];
    _currentAccountLabel.font = [UIFont systemFontOfSize:14 * HPFrameRatioWidth];
    _currentAccountLabel.textColor = [UIColor whiteColor];
    _currentAccountLabel.width = 100;
    _currentAccountLabel.height = 15;
    _currentAccountLabel.left = 10 * HPFrameRatioWidth;
    _currentAccountLabel.top = 21;
    _currentAccountLabel.text = @"实用会员(免费)";
    [self addSubview:_currentAccountLabel];
    
    _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"update_arrow_right"]];
    _arrowImageView.size = _arrowImageView.image.size;
    _arrowImageView.left = _currentAccountLabel.right;
    _arrowImageView.centerY = _currentAccountLabel.centerY;
    
    [self addSubview:_arrowImageView];
    
    _accountLabel = [[UILabel alloc] init];
    _accountLabel.font = [UIFont systemFontOfSize:14 * HPFrameRatioWidth];
    _accountLabel.textColor = [UIColor whiteColor];
    _accountLabel.height = 15;
    _accountLabel.width = 80;
    _accountLabel.left = _arrowImageView.right + 3 * HPFrameRatioWidth;
    _accountLabel.centerY = _currentAccountLabel.centerY;
    _accountLabel.text = @"超级会员";
    [self addSubview:_accountLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = [UIFont systemFontOfSize:16.5 * HPFrameRatioWidth];
    _priceLabel.textColor = [UIColor whiteColor];
    _priceLabel.width = 120;
    _priceLabel.height = 18;
    _priceLabel.text = @"付费289.00元";
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.right = (kScreenWidth - 5 * 2 * HPFrameRatioWidth) - 10 * HPFrameRatioWidth;
    _priceLabel.centerY = _currentAccountLabel.centerY;
    [self addSubview:_priceLabel];
    
    _payButton = [[UIButton alloc] init];
    _payButton.titleLabel.font = [UIFont systemFontOfSize:16.5 * HPFrameRatioWidth];
    _payButton.width = 117;
    _payButton.height = 35;
    _payButton.top = topBackground.bottom + 8;
    _payButton.right = (kScreenWidth - 5 * 2 * HPFrameRatioWidth) - 10.5 * HPFrameRatioWidth;
    _payButton.layer.cornerRadius = _payButton.height / 2;
    _payButton.layer.masksToBounds = YES;
    [_payButton setBackgroundColor:[UIColor colorWithHexString:@"#ffa83a"]];
    [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_payButton setTitle:@"点击付费" forState:UIControlStateNormal];
    [_payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_payButton];
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    return self;
}

- (void)setModel:(AccountUpdateModel *)model {
    _model = model;
    _currentAccountLabel.text = model.currentMember;
    _accountLabel.text = model.updateMember;
    _priceLabel.text = [NSString stringWithFormat:@"付费%.2f元", model.price];
}

- (void)payAction:(id)sender {
    if (_didClickPayBlock) _didClickPayBlock(self.model, self);
}

@end
