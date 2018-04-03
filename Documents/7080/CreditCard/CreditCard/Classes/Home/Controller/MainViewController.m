//
//  MainViewController.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/9.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "MainViewController.h"
#import "OMESoft.h"
#import "MyHeaderView.h"
#import "MyFooterView.h"
#import "HomeCollectionViewCell.h"
#import "InformationVC.h"
#import "RealNameAuthViewController.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MapVC.h"
#import "BankCardVC.h"
#import "CashierViewController.h"
#import "AccountUpdateViewController.h"
#import "MBProgressHUD+CAAdd.h"
#import "FeatureModel.h"
#import "MJExtension.h"
#import "UpgradeViewController.h"
#import "BillsVC.h"
#import "WBalanceVC.h"
// 注意const的位置
static NSString *const cellId = @"HomeCollectionViewCell";
static NSString *const headerId = @"MyHeaderView";
static NSString *const footerId = @"MyFooterView";

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) NSArray *moduleList;  // 功能列表
@property(nonatomic, strong) UserModel *userModel;
@property(nonatomic, strong) MyHeaderView *headView;
@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:UserInfoUpdateNotification object:nil];
    [self updateUserInfo];
    [self getModuleList];
    
    NSString* oldDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"updateVersion"];
    NSString* currentDate = [[NSDate date]ageDetailInfo];
    if (![oldDate isEqualToString:currentDate]) {
        [self checkVersion];
    }
    
}



#pragma mark - Private
-(void)checkVersion{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 20.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [mgr POST:IOSVersion parameters:NULL progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSDictionary *dict = [dic objectForKey:@"Data"];
//        NSString *VersionName = [dict objectForKey:@"VersionName"];
//        NSString *UpdateInfo = [dict objectForKey:@"UpdateInfo"];
        
        
        NSString* date = [[NSDate date]ageDetailInfo];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"updateVersion"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSString *UpdateUrl = [dict objectForKey:@"UpdateUrl"];
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        NSString *VersionCode = [fmt stringFromNumber:[dict objectForKey:@"VersionCode"]];
        //获得build号:
        NSString* build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        if (![VersionCode isEqualToString:build]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"有新版本更新" preferredStyle:UIAlertControllerStyleAlert];
            // 2.创建并添加按钮
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (![UpdateUrl isEqualToString:@""]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UpdateUrl]];
                }
                NSLog(@"OK Action");
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"Cancel Action");
            }];
            
            [alertController addAction:okAction];           // A
            [alertController addAction:cancelAction];       // B
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


-(void)updateUserInfo{
    NSDictionary *userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoData"];
    self.userModel = [UserModel objectWithKeyValues:userInfoDict];
    

    NSString* strUrl = [NSString stringWithFormat:@"%@%@", ImgBaseURL, self.userModel.HeadImgUrl];
    dispatch_main_sync_safe((^{
        [_headView.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
    }))
}

- (void)getModuleList
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
    
    [mgr POST:ModuleListURL parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            self.moduleList = [FeatureModel objectArrayWithKeyValuesArray:[dataDict objectForKey:@"ModuleList"]];
            [self.collectionView reloadData];
        } else {
            [hud hide:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

- (IBAction)bankCardAction:(id)sender {
    BankCardVC *bankVc = [[BankCardVC alloc] init];
    bankVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bankVc animated:YES];
}

- (IBAction)refundBtnAction1:(id)sender {
    if (_userModel.AuthStatus.intValue != 1){
        [self showAlertView];
        return;
    }
    MapVC *mapVc = [[MapVC alloc] init];
    mapVc.type = 1;
    mapVc.userID = _userModel.UserID;
    mapVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapVc animated:YES];
}

- (IBAction)refundBtnAction2:(id)sender {
    if (_userModel.AuthStatus.intValue < 1){
        [self showAlertView];
        return;
    }
    MapVC *mapVc = [[MapVC alloc] init];
    mapVc.type = 2;
    mapVc.userID = _userModel.UserID;
    mapVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapVc animated:YES];
}
- (IBAction)billsAction {
    BillsVC *controller = [[BillsVC alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)cellBtnClick:(UIButton *)button;
{
    if (_userModel.AuthStatus.intValue == 1) {
        FeatureModel *featureModel = self.moduleList[button.tag];
        if ([featureModel.ModuleName isEqualToString:@"收银台"]) {
            CashierViewController *controller = [[CashierViewController alloc] init];
            controller.userModel = _userModel;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            return;
        } else if ([featureModel.ModuleName isEqualToString:@"升级"]) {
            UpgradeViewController *controller = [[UpgradeViewController alloc] init];
            controller.userModel = _userModel;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            return;
        } else if ([featureModel.ModuleName isEqualToString:@"信用卡申请"]) {
            BankCardVC *bankVc = [[BankCardVC alloc] init];
            FeatureModel* model = _moduleList[button.tag];
            bankVc.navigationItem.title = featureModel.ModuleName;
            bankVc.url = [NSURL URLWithString:model.Link];;
            bankVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bankVc animated:YES];
            return;
        }else if ([featureModel.ModuleName isEqualToString:@"我的收益"]){
            if (_userModel.AuthStatus.intValue < 1){
                [self showAlertView];
                return;
            }
            WBalanceVC* ctr = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"WBalanceVC"];
            ctr.userModel = self.userModel;
            ctr.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctr animated:true];
            return;
        }else if ([featureModel.Type isEqualToString:@"2"]&&![featureModel.Link isEqualToString:@""]){
            BankCardVC *bankVc = [[BankCardVC alloc] init];
            FeatureModel* model = _moduleList[button.tag];
            bankVc.navigationItem.title = featureModel.ModuleName;
            bankVc.url = [NSURL URLWithString:model.Link];;
            bankVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bankVc animated:YES];
        }
        
        [MBProgressHUD showProgressWithTitle:@"正在开发中，敬请期待" message:nil duration:1.0];
    } else {
        [self showAlertView];
    }
}

- (void)showAlertView
{
    if (_userModel.AuthStatus.intValue < 0) {
        [MBProgressHUD showProgressWithTitle:@"提示" message:@"实名认证正在审核" duration:1.0];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先实名认证" preferredStyle:UIAlertControllerStyleAlert];
    // 2.创建并添加按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去实名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RealNameAuthViewController *realNameVc = [[RealNameAuthViewController alloc] init];
        realNameVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:realNameVc animated:YES];
        NSLog(@"OK Action");
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Action");
    }];
    
    [alertController addAction:okAction];           // A
    [alertController addAction:cancelAction];       // B
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.moduleList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    FeatureModel *featureModel = self.moduleList[indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ImgBaseURL, featureModel.IcoUrl]]];
    cell.nameLbl.text = featureModel.ModuleName;
    [cell.cellBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.cellBtn.tag = indexPath.row;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        MyHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        headerView.phoneLbl.text = [NSString stringWithFormat:@"%@****%@", [self.userModel.MobilePhone substringToIndex:3], [self.userModel.MobilePhone substringFromIndex:7]];
        headerView.headBtn.layer.cornerRadius = 18;
        headerView.headBtn.layer.masksToBounds = YES;
        _headView = headerView;
        [headerView.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ImgBaseURL, self.userModel.HeadImgUrl]] forState:UIControlStateNormal];
        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        MyFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat WH = (MainScreenCGRect.size.width - 5) / 4;
    return (CGSize){WH,WH};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 1, 5, 1);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (MainScreenCGRect.size.height == 812.0) {
        return (CGSize){MainScreenCGRect.size.width,199};
    } else {
        return (CGSize){MainScreenCGRect.size.width,175};
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){MainScreenCGRect.size.width,120};
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


// 长按某item，弹出copy和paste的菜单
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 使copy和paste有效
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"] || [NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        return YES;
    }
    
    return NO;
}

//
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if([NSStringFromSelector(action) isEqualToString:@"copy:"])
    {
        //        NSLog(@"-------------执行拷贝-------------");
    }
    else if([NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        NSLog(@"-------------执行粘贴-------------");
    }
}

@end
