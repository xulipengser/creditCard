//
//  PayRecordCell.m
//  CreditCard
//
//  Created by cass on 2018/3/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "PayRecordCell.h"
#import "YYKit.h"
@interface PayRecordCell()
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *amtnLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation PayRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _typeLabel.font = [UIFont systemFontOfSize:15];
    _typeLabel.textColor = [UIColor blackColor];
    _typeLabel.height = 16;
    _typeLabel.left = 16;
    _typeLabel.width = 200;
    _typeLabel.top = 11.5;
    _typeLabel.text = @"闪付";
    [self addSubview:_typeLabel];
    
    _amtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _amtnLabel.font = [UIFont systemFontOfSize:15];
    _amtnLabel.textColor = [UIColor blackColor];
    _amtnLabel.height = 16;
    _amtnLabel.width = 100;
    _amtnLabel.right = kPayRecordCellWidth - 16;
    _amtnLabel.top = 11.5;
    _amtnLabel.textAlignment = NSTextAlignmentRight;
    _amtnLabel.text = @"+4680.00";
    [self addSubview:_amtnLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _dateLabel.font = [UIFont systemFontOfSize:15];
    _dateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _dateLabel.height = 16;
    _dateLabel.left = _typeLabel.left;
    _dateLabel.width = 200;
    _dateLabel.bottom = kPayRecordCellHeight - 11.5;
    _dateLabel.text = @"2017-09-29";
    [self addSubview:_dateLabel];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _statusLabel.font = [UIFont systemFontOfSize:15];
    _statusLabel.textColor = [UIColor colorWithHexString:@"#424758"];
    _statusLabel.height = 16;
    _statusLabel.width = 100;
    _statusLabel.right = kPayRecordCellWidth - 16;
    _statusLabel.bottom = kPayRecordCellHeight - 11.5;
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.text = @"交易成功";
    [self addSubview:_statusLabel];
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;

    
    return self;
}

- (void)setModel:(OrderModel *)model {
    _model = model;
    _typeLabel.text = model.OrderNo;
    _amtnLabel.text = [NSString stringWithFormat:@"+%@", model.Amount];
    _dateLabel.text = model.CreatorTime;
    
    switch (_model.OrderStatus.intValue) {
        case 0:
            _statusLabel.text = @"未知";
            break;
        case 100:
            _statusLabel.text = @"交易成功";
            break;
        case 101:
            _statusLabel.text = @"正在处理";
            break;
        case 102:
            _statusLabel.text = @"交易失败";
            break;
        default:
            break;
    }
    
}

@end
