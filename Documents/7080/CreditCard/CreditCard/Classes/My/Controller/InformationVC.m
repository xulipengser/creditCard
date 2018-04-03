//
//  InfomationVC.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/11.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "InformationVC.h"
#import "UserModel.h"
#import "UIButton+WebCache.h"

@interface InformationVC () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *headBtn;
@property(nonatomic, strong) UserModel *userModel;
@end

@implementation InformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户信息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (instancetype)initWithUserInfo:(UserModel *)userModel
{
    self = [super init];
    if (self) {
        _userModel = userModel;
    }
    return self;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
    } else {
        return 45;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"头像";
                cell.detailTextLabel.hidden = YES;
                [cell.contentView addSubview:self.headBtn];
                break;
            }
            case 1:
            {
                cell.textLabel.text = @"姓名";
                cell.detailTextLabel.text = self.userModel.RealName;
                break;
            }
            case 2:
            {
                cell.textLabel.text = @"手机号";
                cell.detailTextLabel.text = self.userModel.MobilePhone;
                break;
            }
            case 3:
            {
                cell.textLabel.text = @"商户号";
                cell.detailTextLabel.text = self.userModel.MerchantNo;
                break;
            }
            case 4:
            {
                cell.textLabel.text = @"注册日期";
                cell.detailTextLabel.text = self.userModel.RegisterTime;
                break;
            }
            case 5:
            {
                cell.textLabel.text = @"实名日期";
                cell.detailTextLabel.text = self.userModel.AuthTime;
                break;
            }
            case 6:
            {
                cell.textLabel.text = @"实名状态";
                NSString* str = @"已实名";
                if (self.userModel.AuthStatus.intValue == 0){
                    str = @"未实名";
                }else if (self.userModel.AuthStatus.intValue == -1)
                    str = @"审核中";
                else if (self.userModel.AuthStatus.intValue == 2)
                    str = @"审核失败";
                cell.detailTextLabel.text =  str;
                cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#F17600"];
                break;
            }
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"还款手续费";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/笔", self.userModel.Brokerage];
                cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#4263C7"];
                break;
            }
            case 1:
            {
                cell.textLabel.text = @"快速还款费率";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f%%", self.userModel.Rate.floatValue*100];
                cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#4263C7"];
                break;
            }
            case 2:
            {
                cell.textLabel.text = @"完美还款费率";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f%%", self.userModel.Rate.floatValue*100];
                cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#4263C7"];
                break;
            }
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}


#pragma mark - Get

- (UIButton *)headBtn
{
    if (_headBtn == nil) {
        CGFloat WH = 36;
        CGFloat Y = (60 - WH)/2.0;
        CGFloat X = MainScreenCGRect.size.width - WH - 20;
        _headBtn = [[UIButton alloc] initWithFrame:CGRectMake(X, Y, WH, WH)];
        _headBtn.layer.cornerRadius = WH / 2.0;
        _headBtn.layer.masksToBounds = YES;
        [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ImgBaseURL, self.userModel.HeadImgUrl]] forState:UIControlStateNormal];
    }
    return _headBtn;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, MainScreenCGRect.size.height - SafeAreaTopHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

@end
