//
//  UpgradeViewController.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/12.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "UpgradeViewController.h"
#import "MKJCollectionViewFlowLayout.h"
#import "UpgradeCollectionViewCell.h"
#import "MKJCircleLayout.h"
#import "Masonry.h"
#import "AccountUpdateViewController.h"
#import "MBProgressHUD+CAAdd.h"
#import "RankInfo.h"
#import "UIImageView+WebCache.h"
@interface UpgradeViewController () <UICollectionViewDelegate,UICollectionViewDataSource,MKJCollectionViewFlowLayoutDelegate>
@property(nonatomic, strong) UIView *topView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *imgList;
@property(nonatomic, strong) NSMutableArray *imgUrlList;
@property(nonatomic, strong) NSMutableArray *detailList;  // 详细介绍等级的
@property (nonatomic,assign) NSInteger selectedIndex; // 选择了哪个
@property(nonatomic, strong) UIButton *gradeBtn;

@property(nonatomic, strong) UILabel *equityLbl;
@property(nonatomic, strong) UILabel *Rate;
@property(nonatomic, strong) UILabel *Brokerage;
@property(nonatomic, strong) UILabel *UpGradeBrokerage;
@property(nonatomic, strong) UILabel *Level1Rate;
@property(nonatomic, strong) UILabel *Level2Rate;
@property(nonatomic, strong) UILabel *Level3Rate;
@property(nonatomic, strong) UILabel *Level1UpGradeBrokerage;
@property(nonatomic, strong) UILabel *Level2UpGradeBrokerage;
@property(nonatomic, strong) UILabel *Level3UpGradeBrokerage;
@property(nonatomic, strong) UIButton *nextBtn;

@property(nonatomic, strong) NSArray *rankInfoList;
@property(nonatomic, strong) RankInfo *rankInfo;

@end

static NSString *indentify = @"UpgradeCollectionViewCell";

@implementation UpgradeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"付费升级";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.equityLbl];
    [self.view addSubview:self.Rate];
    [self.view addSubview:self.Brokerage];
    [self.view addSubview:self.UpGradeBrokerage];
    [self.view addSubview:self.Level1Rate];
    [self.view addSubview:self.Level2Rate];
    [self.view addSubview:self.Level3Rate];
    [self.view addSubview:self.Level1UpGradeBrokerage];
    [self.view addSubview:self.Level2UpGradeBrokerage];
    [self.view addSubview:self.Level3UpGradeBrokerage];
    
    [self.view addSubview:self.nextBtn];
    [self getRankList];
}


- (void)getRankList
{
    MBProgressHUD *hud = [MBProgressHUD showMessageWithActivityIndicator:@"" toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [parametersDict setObject:self.userModel.UserID forKey:@"UserID"];
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 20.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [mgr POST:RankList parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            self.rankInfoList = [RankInfo objectArrayWithKeyValuesArray:[dataDict objectForKey:@"RankList"]];
            [self.collectionView reloadData];
        } else {
            [hud hide:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

#pragma mark - Private

- (void)upGrade
{
    AccountUpdateViewController *controller = [[AccountUpdateViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.rankInfoList = self.rankInfoList;
    controller.rankInfo = self.rankInfo;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma makr - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *img = self.imgList[indexPath.item];
    UpgradeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentify forIndexPath:indexPath];
    cell.imgView.image = img;
    if (_imgUrlList[indexPath.row]!=NULL) {
        [cell.imgView sd_setImageWithURL:(NSURL*)_imgUrlList[indexPath.row] placeholderImage:img];
    }
    
    return cell;
}

// 点击item的时候
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    if ([self.collectionView.collectionViewLayout isKindOfClass:[MKJCollectionViewFlowLayout class]]) {
        CGPoint pInUnderView = [self.view convertPoint:collectionView.center toView:collectionView];
        
        // 获取中间的indexpath
        NSIndexPath *indexpathNew = [collectionView indexPathForItemAtPoint:pInUnderView];
        
        if (indexPath.row == indexpathNew.row)
        {
            NSLog(@"点击了同一个");
            return;
        }
        else
        {
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
    else if ([self.collectionView.collectionViewLayout isKindOfClass:[MKJCircleLayout class]])
    {
        _selectedIndex = 0;
        [self.imgList removeObjectAtIndex:indexPath.item];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
    else
    {
        
    }
}

#pragma CustomLayout的代理方法

- (void)collectioViewScrollToIndex:(NSInteger)index
{
    _selectedIndex = index;
    
    RankInfo* rankinfo = self.rankInfoList[index];
    self.Rate.text = [NSString stringWithFormat:@"还款费率：%0.2f%%",rankinfo.Rate.floatValue*100];
    self.Brokerage.text = [NSString stringWithFormat:@"还款基本手续费：%0.2f元",rankinfo.Brokerage.floatValue];
    self.UpGradeBrokerage.text = [NSString stringWithFormat:@"升级所需手续费：%0.2f元",rankinfo.UpGradeBrokerage.floatValue];
    self.Level1Rate.text = [NSString stringWithFormat:@"一级费率分佣：%0.2f%%",rankinfo.Level1Rate.floatValue*100];
    self.Level2Rate.text = [NSString stringWithFormat:@"二级费率分佣：%0.2f%%",rankinfo.Level2Rate.floatValue*100];
    self.Level3Rate.text = [NSString stringWithFormat:@"代理费率分佣：%0.2f%%",rankinfo.Level3Rate.floatValue*100];
    self.Level1UpGradeBrokerage.text = [NSString stringWithFormat:@"一级升级手续费分佣：%0.2f元",rankinfo.Level1UpGradeBrokerage.floatValue];
    self.Level2UpGradeBrokerage.text = [NSString stringWithFormat:@"一级升级手续费分佣：%0.2f元",rankinfo.Level2UpGradeBrokerage.floatValue];
    self.Level3UpGradeBrokerage.text = [NSString stringWithFormat:@"一级升级手续费分佣：%0.2f元",rankinfo.Level3UpGradeBrokerage.floatValue];
    
    
    
}

#pragma mark - Get
- (UILabel *)equityLbl
{
    if (_equityLbl == nil) {
        _equityLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.topView.frame) + 5, 100, 30)];
        _equityLbl.text = @"会员权益";
        _equityLbl.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _equityLbl;
}

- (UILabel *)Rate
{
    if (_Rate == nil) {
        _Rate = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.equityLbl.frame)-5, MainScreenCGRect.size.width - 25, 18)];
        _Rate.font = [UIFont systemFontOfSize:13.0f];
        _Rate.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _Rate;
}

- (UILabel *)Brokerage
{
    if (_Brokerage == nil) {
        _Brokerage = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.Rate.frame), MainScreenCGRect.size.width - 25, 18)];
        _Brokerage.font = [UIFont systemFontOfSize:13.0f];
        _Brokerage.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _Brokerage;
}

- (UILabel *)UpGradeBrokerage
{
    if (_UpGradeBrokerage == nil) {
        _UpGradeBrokerage = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.Brokerage.frame), MainScreenCGRect.size.width - 25, 18)];
        _UpGradeBrokerage.font = [UIFont systemFontOfSize:13.0f];
        _UpGradeBrokerage.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _UpGradeBrokerage;
}

- (UILabel *)Level1Rate
{
    if (_Level1Rate == nil) {
        _Level1Rate = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.UpGradeBrokerage.frame), MainScreenCGRect.size.width - 25, 18)];
        _Level1Rate.font = [UIFont systemFontOfSize:13.0f];
        _Level1Rate.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _Level1Rate;
}

- (UILabel *)Level2Rate
{
    if (_Level2Rate == nil) {
        _Level2Rate = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.Level1Rate.frame), MainScreenCGRect.size.width - 25, 18)];
        _Level2Rate.font = [UIFont systemFontOfSize:13.0f];
        _Level2Rate.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _Level2Rate;
}

- (UILabel *)Level3Rate
{
    if (_Level3Rate == nil) {
        _Level3Rate = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.Level2Rate.frame), MainScreenCGRect.size.width - 25, 18)];
        _Level3Rate.font = [UIFont systemFontOfSize:13.0f];
        _Level3Rate.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _Level3Rate;
}

- (UILabel *)Level1UpGradeBrokerage
{
    if (_Level1UpGradeBrokerage == nil) {
        _Level1UpGradeBrokerage = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.Level3Rate.frame), MainScreenCGRect.size.width - 25, 18)];
        _Level1UpGradeBrokerage.font = [UIFont systemFontOfSize:13.0f];
        _Level1UpGradeBrokerage.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _Level1UpGradeBrokerage;
}

- (UILabel *)Level2UpGradeBrokerage
{
    if (_Level2UpGradeBrokerage == nil) {
        _Level2UpGradeBrokerage = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.Level1UpGradeBrokerage.frame), MainScreenCGRect.size.width - 25, 18)];
        _Level2UpGradeBrokerage.font = [UIFont systemFontOfSize:13.0f];
        _Level2UpGradeBrokerage.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _Level2UpGradeBrokerage;
}

- (UILabel *)Level3UpGradeBrokerage
{
    if (_Level3UpGradeBrokerage == nil) {
        _Level3UpGradeBrokerage = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.Level2UpGradeBrokerage.frame), MainScreenCGRect.size.width - 25, 18)];
        _Level3UpGradeBrokerage.font = [UIFont systemFontOfSize:13.0f];
        _Level3UpGradeBrokerage.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _Level3UpGradeBrokerage;
}




- (UIButton *)nextBtn
{
    if (_nextBtn == nil) {
        CGFloat H = 48;
        CGFloat Y = MainScreenCGRect.size.height - H - 30 - 64;
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, Y, MainScreenCGRect.size.width - 50, H)];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"upgradeBtn"] forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn setTitle:@"立即升级" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(upGrade) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIButton *)gradeBtn
{
    if (_gradeBtn == nil) {
        CGFloat Y = _topView.frame.size.height - 25 - 20;
        _gradeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, Y, 180, 25)];
        [_gradeBtn setImage:[UIImage imageNamed:@"crown"] forState:UIControlStateNormal];
        [_gradeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        NSString * gradeStr = @"当前等级:试用会员";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",gradeStr]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,5)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FDA83A"] range:NSMakeRange(5,4)];
        [_gradeBtn setAttributedTitle:str forState:UIControlStateNormal];
    }
    return _gradeBtn;
}

- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, 275*HPFrameRatioHeight)];
        _topView.backgroundColor = [UIColor colorWithHexString:@"#4263CA"];
        [_topView addSubview:self.collectionView];
        [_topView addSubview:self.gradeBtn];
    }
    return _topView;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        MKJCollectionViewFlowLayout *flow = [[MKJCollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.itemSize = CGSizeMake(100, 100);
        flow.minimumLineSpacing = 40;
        flow.minimumInteritemSpacing = 25;
        flow.needAlpha = YES;
        flow.delegate = self;
        CGFloat oneX = (MainScreenCGRect.size.width - 100) / 2;
        flow.sectionInset = UIEdgeInsetsMake(0, oneX, 0, oneX);
        
        CGFloat Y = ((275 - 180)/2.0 - 15) * HPFrameRatioHeight;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Y, MainScreenCGRect.size.width, 180) collectionViewLayout:flow];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:indentify bundle:nil] forCellWithReuseIdentifier:indentify];
    }
    return _collectionView;
}

- (NSMutableArray *)imgList
{
    if (_imgList == nil) {
        _imgList = [NSMutableArray array];
        [_imgList addObject:[UIImage imageNamed:@"grade1"]];
        [_imgList addObject:[UIImage imageNamed:@"grade2"]];
        [_imgList addObject:[UIImage imageNamed:@"grade3"]];
    }
    return _imgList;
}

- (NSMutableArray *)detailList
{
    if (_detailList == nil) {
        _detailList = [NSMutableArray array];
        [_detailList addObject:@"试用会员:0.79%,还款一笔一元。10000元79元手续费，推荐一个用户，享受分润万20+推广升级奖励直推150元+间推二级30元+间推三级10元"];
        [_detailList addObject:@"普通会员:0.69%,还款一笔一元。10000元69元手续费，推荐一个用户，享受分润万20+推广升级奖励直推150元+间推二级30元+间推三级10元"];
         [_detailList addObject:@"超级会员:0.59%,还款一笔一元。10000元59元手续费，推荐一个用户，享受分润万20+推广升级奖励直推150元+间推二级30元+间推三级10元"];
    }
    return _detailList;
}
-(void)setRankInfoList:(NSArray *)rankInfoList{
    _rankInfoList = rankInfoList;
    
    
    _imgUrlList = [NSMutableArray array];
    for (RankInfo* rankinfo in rankInfoList) {
        [_imgUrlList addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ImgBaseURL, rankinfo.IcoUrl]]];
        if ([rankinfo.Id isEqualToString:_userModel.RankId]) {
            self.rankInfo = rankinfo;
        }
    }
    [self collectioViewScrollToIndex:0];
    
}

-(void)setRankInfo:(RankInfo *)rankInfo{
    _rankInfo = rankInfo;
    NSString * gradeStr = [NSString stringWithFormat:@"当前等级:%@",rankInfo.RankName];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",gradeStr]];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,5)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FDA83A"] range:NSMakeRange(5,str.length-5)];
    [_gradeBtn setAttributedTitle:str forState:UIControlStateNormal];
}


@end
