//
//  ShareViewController.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/5.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "ShareViewController.h"
#import "MKJCollectionViewCell.h"
#import "MKJCollectionViewFlowLayout.h"
#import "MKJItemModel.h"
#import "OMESoft.h"
#import "MKJCircleLayout.h"
#import "MKJConstant.h"
#import "ShareStep2ViewController.h"
#import "MBProgressHUD+CAAdd.h"
#import "UserModel.h"
#import "ShareModel.h"

@interface ShareViewController () <UICollectionViewDelegate,UICollectionViewDataSource,MKJCollectionViewFlowLayoutDelegate>
@property(nonatomic, strong) NSArray *shareModelList;
@property(nonatomic, strong) NSMutableArray *imgList;
@property (nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIImageView *imgView;
@property (nonatomic,assign) NSInteger selectedIndex; // 选择了哪个

@property(nonatomic, strong) UserModel *userModel;
@property(nonatomic, strong) NSOperation *lastOperation;
@property(nonatomic, strong) UIButton *nextBtn;
@end

static NSString *indentify = @"MKJCollectionViewCell";

@implementation ShareViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoData"];
   self.userModel = [UserModel objectWithKeyValues:userInfoDict];
    
    self.navigationItem.title = @"分享";
    [self setRightBarBtn];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#4C4C4C"];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.imgView];
    
    [self getSharePictureList];
}

#pragma mark - Private

- (void)getSharePictureList
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
    
    [mgr POST:SharePictureListURL parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
    
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            self.shareModelList = [ShareModel objectArrayWithKeyValuesArray:[dataDict objectForKey:@"SPList"]];
            // 获取图片
            if (self.shareModelList.count == 0) {
                [hud hide:YES];
                return;
            }
            for (int i=0; i<self.shareModelList.count; i++) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    ShareModel *shareModel = self.shareModelList[i];
                    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ImgBaseURL, shareModel.BgUrl]]];
                    UIImage *pic = [UIImage imageWithData:imageData];
                    [self.imgList addObject:pic];
                    dispatch_async(dispatch_get_main_queue(),^{
                        //返回主线程
                        [hud hide:YES];
                        self.imgView.image = self.imgList[0];
                        [self.collectionView reloadData];
                    });
                    
                });
            }
        } else {
            [hud hide:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

- (void)nextBtnClick:(UIButton *)btn
{
    ShareStep2ViewController *share2Vc = [[ShareStep2ViewController alloc] initWithImg:self.imgList[_selectedIndex]];
    share2Vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:share2Vc animated:YES];
}

- (void)setRightBarBtn
{
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    _nextBtn = nextBtn;
    _nextBtn.enabled = NO;
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
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
    MKJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentify forIndexPath:indexPath];
    cell.heroImageVIew.image = self.imgList[indexPath.item];
    return cell;
}

// 点击item的时候
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.imgView.image = self.imgList[indexPath.item];
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
    else
    {
        
    }
}

#pragma CustomLayout的代理方法

- (void)collectioViewScrollToIndex:(NSInteger)index
{
    _selectedIndex = index;
    self.imgView.image = self.imgList[index];
}


#pragma mark - Get

- (NSMutableArray *)imgList
{
    if (_imgList == nil) {
        _imgList = [NSMutableArray array];
    }
    return _imgList;
}

- (UIImageView *)imgView
{
    if (_imgView == nil) {
        CGFloat Y = 30;
        CGFloat height = CGRectGetMinY(self.collectionView.frame) - Y - 20;
        CGFloat width = height / 1.5;
        CGFloat X = (MainScreenCGRect.size.width - width)/2.0;
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, width, height)];
        _imgView.backgroundColor = [UIColor grayColor];
    }
    return _imgView;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        MKJCollectionViewFlowLayout *flow = [[MKJCollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat width  = MainScreenCGRect.size.width / 4;
        flow.itemSize = CGSizeMake(width, 110);
        flow.minimumLineSpacing = 30;
        flow.minimumInteritemSpacing = 30;
        flow.needAlpha = YES;
        flow.delegate = self;
        CGFloat oneX = (MainScreenCGRect.size.width - width) / 2;
        flow.sectionInset = UIEdgeInsetsMake(0, oneX, 0, oneX);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MainScreenCGRect.size.height - 274, MainScreenCGRect.size.width, 160) collectionViewLayout:flow];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#4C4C4C"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:indentify bundle:nil] forCellWithReuseIdentifier:indentify];
    }
    return _collectionView;
}

@end
