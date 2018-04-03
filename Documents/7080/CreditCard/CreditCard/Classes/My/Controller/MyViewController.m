//
//  MyViewController.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/5.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "MyViewController.h"
#import "MyCustomCell.h"
#import "OMESoft.h"
#import "InformationVC.h"
#import "UpgradeViewController.h"
#import "CardManagerViewController.h"
#import "SettingViewController.h"
#import "UserModel.h"
#import "RealNameAuthViewController.h"
#import "MBProgressHUD+CAAdd.h"
#import <AVFoundation/AVFoundation.h>
#import "UIButton+WebCache.h"
#import "WalletViewController.h"
#import "UserAgreementViewController.h"
#import "WBalanceVC.h"
#import "OperationManualVC.h"
@interface MyViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
@property(nonatomic, strong) UserModel *userModel;
@property(nonatomic, strong) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UIView *kefuView;
@property (weak, nonatomic) IBOutlet UIView *kefuContentView;
@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tableView.bounces = NO;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (_userModel.AuthStatus.intValue != 1){
        
        [self updateUserInfo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:UserInfoChangeNotification object:nil];
    
    _kefuContentView.layer.cornerRadius = 10;
    
    
    NSDictionary *userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoData"];
    self.userModel = [UserModel objectWithKeyValues:userInfoDict];
    [self updateUserInfo];
    [self updateView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _btn1.titleEdgeInsets = UIEdgeInsetsMake(_btn1.imageView.frame.size.height, -_btn1.imageView.frame.size.width, 0, 0);
    _btn1.imageEdgeInsets = UIEdgeInsetsMake(-_btn1.titleLabel.bounds.size.height-15, 0, 0, -_btn1.titleLabel.bounds.size.width);
    
    _btn2.titleEdgeInsets = UIEdgeInsetsMake(_btn2.imageView.frame.size.height, -_btn2.imageView.frame.size.width, 0, 0);
    _btn2.imageEdgeInsets = UIEdgeInsetsMake(-_btn2.titleLabel.bounds.size.height-15, 0, 0, -_btn2.titleLabel.bounds.size.width);
    
    _btn3.titleEdgeInsets = UIEdgeInsetsMake(_btn3.imageView.frame.size.height, -_btn3.imageView.frame.size.width, 0, 0);
    _btn3.imageEdgeInsets = UIEdgeInsetsMake(-_btn3.titleLabel.bounds.size.height-15, 0, 0, -_btn3.titleLabel.bounds.size.width);
    
    _btn4.titleEdgeInsets = UIEdgeInsetsMake(_btn4.imageView.frame.size.height, -_btn4.imageView.frame.size.width, 0, 0);
    _btn4.imageEdgeInsets = UIEdgeInsetsMake(-_btn4.titleLabel.bounds.size.height-15, 0, 0, -_btn4.titleLabel.bounds.size.width);
    
    _btn5.titleEdgeInsets = UIEdgeInsetsMake(_btn5.imageView.frame.size.height, -_btn5.imageView.frame.size.width, 0, 0);
    _btn5.imageEdgeInsets = UIEdgeInsetsMake(-_btn5.titleLabel.bounds.size.height-15, 0, 0, -_btn5.titleLabel.bounds.size.width);
    
    _btn6.titleEdgeInsets = UIEdgeInsetsMake(_btn6.imageView.frame.size.height, -_btn6.imageView.frame.size.width, 0, 0);
    _btn6.imageEdgeInsets = UIEdgeInsetsMake(-_btn6.titleLabel.bounds.size.height-15, 0, 0, -_btn6.titleLabel.bounds.size.width);
    
    _headBtn.layer.cornerRadius = 38;
    _headBtn.layer.masksToBounds = YES;
    
    _upgradeBtn.layer.cornerRadius = 16;
    _upgradeBtn.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    _upgradeBtn.layer.borderWidth = 1;
    
    _realNameBtn.layer.cornerRadius = 16;
    _realNameBtn.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    _realNameBtn.layer.borderWidth = 1;
}

- (IBAction)realNameAction:(id)sender {
    RealNameAuthViewController *realNameVc = [[RealNameAuthViewController alloc] init];
    realNameVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:realNameVc animated:YES];
}
#pragma mark - Private
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

#pragma mark - Action

- (IBAction)cancel {
    CGAffineTransform  transform = CGAffineTransformScale(self.kefuContentView.transform, 0.1, 0.1);
    [UIView animateWithDuration:0.3 animations:^{
        _kefuView.alpha = 0;
        _kefuContentView.transform = transform;
    } completion:^(BOOL finished) {
        [_kefuView setHidden:YES];
    }];
}

- (IBAction)goin {
    NSString  *qqNumber=@"3451688993";
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqNumber]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        webView.delegate = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"nil" message:@"对不起，您还没安装QQ" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            return ;
        }];
        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    [self cancel];
}

- (void)updateView
{
    
    _realNameBtn.enabled = self.userModel.AuthStatus.intValue == 0 || self.userModel.AuthStatus.intValue == 2;
    if (self.userModel.AuthStatus.intValue == 1) {
        [_realNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _realNameBtn.backgroundColor = [UIColor whiteColor];
        [_realNameBtn setTitle:@"已实名" forState:UIControlStateNormal];
    } else if(_userModel.AuthStatus.intValue == 0){
        [_realNameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _realNameBtn.backgroundColor = [UIColor clearColor];
        [_realNameBtn setTitle:@"点击实名" forState:UIControlStateNormal];
    }else if(_userModel.AuthStatus.intValue == 2){
        [_realNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _realNameBtn.backgroundColor = [UIColor whiteColor];
        [_realNameBtn setTitle:@"审核失败" forState:UIControlStateNormal];
    }else{
        [_realNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _realNameBtn.backgroundColor = [UIColor whiteColor];
        [_realNameBtn setTitle:@"审核中" forState:UIControlStateNormal];
    }
    if (self.userModel.HeadImgUrl.length > 0) {
        [self.headBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ImgBaseURL, self.userModel.HeadImgUrl]] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRefreshCached];
    }
    
    self.phoneLbl.text = [NSString stringWithFormat:@"%@****%@", [self.userModel.MobilePhone substringToIndex:3], [self.userModel.MobilePhone substringFromIndex:7]];
    self.rankLbl.text = self.userModel.RankName;
}

- (void)updateUserInfo
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [parametersDict setObject:self.userModel.UserID forKey:@"UserID"];
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr POST:GetUserInfoURL parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            [[NSUserDefaults standardUserDefaults] setObject:dataDict forKey:@"userInfoData"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [NSNotificationCenter.defaultCenter postNotificationName:UserInfoUpdateNotification object:NULL];
            self.userModel = [UserModel objectWithKeyValues:dataDict];
            [self updateView];
        } else {
            NSString *msg = [dict objectForKey:@"RespMsg"];
            [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:1.0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

- (void)updateUserHeadImgWithImgUrl:(NSString *)imgUrl
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [parametersDict setObject:self.userModel.UserID forKey:@"UserID"];
    [parametersDict setObject:imgUrl forKey:@"HeadImgUrl"];
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr POST:UpdateHeadImgURL parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.hud hide:YES];
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            [MBProgressHUD showProgressWithTitle:@"上传成功" message:nil duration:1.0];
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            [[NSUserDefaults standardUserDefaults] setObject:dataDict forKey:@"userInfoData"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
        } else {
            NSString *msg = [dict objectForKey:@"RespMsg"];
            [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:1.0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

- (void)uploadHeadImgWithData:(NSData *)data
{
    self.hud = [MBProgressHUD showMessageWithActivityIndicator:@"" toView:self.view];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 20.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [parametersDict setObject:self.userModel.UserID forKey:@"UserID"];
    [parametersDict setObject:@"0" forKey:@"ImageBusinessType"];
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    
    [mgr POST:UploadFileURL parameters:parametersDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件参数
        [formData appendPartWithFileData:data name:@"userPic" fileName:@"userPic.png" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印上传进度
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"%.2lf%%", progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            [self updateUserHeadImgWithImgUrl:[dataDict objectForKey:@"ImgUrl"]];
        } else {
            [self.hud hide:YES];
            NSString *msg = [dict objectForKey:@"RespMsg"];
            [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

- (IBAction)upgradeAction:(id)sender {
    if (_userModel.AuthStatus.intValue != 1){
        [self showAlertView];
        return;
    }
    UpgradeViewController *upgradeVc = [[UpgradeViewController alloc] init];
    upgradeVc.hidesBottomBarWhenPushed = YES;
    upgradeVc.userModel = self.userModel;
    [self.navigationController pushViewController:upgradeVc animated:YES];
}

- (IBAction)changeHeadIconAction:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 2.创建并添加按钮
    UIAlertAction *phoneAction = [UIAlertAction actionWithTitle:@"拍摄头像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
            authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
        {
            // 无权限 引导去开启
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"拍照功能需要获取您的相册权限,请先到设置里设置允许" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:ipc animated:YES completion:nil];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持拍照功能。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
        }
    }];
    UIAlertAction *localAction = [UIAlertAction actionWithTitle:@"本地图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:ipc animated:YES completion:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Action");
    }];
    
    [alertController addAction:phoneAction];
    [alertController addAction:localAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



- (IBAction)btn1Action:(id)sender {
    InformationVC *infoVc = [[InformationVC alloc] initWithUserInfo:self.userModel];
    infoVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoVc animated:YES];
}

- (IBAction)btn2Action:(id)sender {
//    [MBProgressHUD showProgressWithTitle:@"提示" message:@"功能正在测试中" duration:1.0];
}

- (IBAction)btn3Action:(id)sender {
    CardManagerViewController *cardVc = [[CardManagerViewController alloc] init];
    cardVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cardVc animated:YES];
}

- (IBAction)btn4Action:(id)sender {
    OperationManualVC *cardVc = [[OperationManualVC alloc] init];
    cardVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cardVc animated:YES];
    
//    [MBProgressHUD showProgressWithTitle:@"提示" message:@"功能正在测试中" duration:1.0];
}

- (IBAction)btn5Action:(id)sender {
//    [MBProgressHUD showPrressWithTitle:@"提示" message:@"功能正在测试中" duration:1.0];
    [_kefuView setHidden:NO];
    _kefuView.alpha = 0;
    CGAffineTransform  transform = CGAffineTransformScale(self.kefuContentView.transform, 0.1, 0.1);
    self.kefuContentView.transform = transform;
    CGAffineTransform  transformTranslation1 = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform  transform1 = CGAffineTransformScale(transformTranslation1, 1, 1);
    [UIView animateWithDuration:0.3 animations:^{
        _kefuView.alpha = 1;
        _kefuContentView.transform = transform1;
    }];
}

- (IBAction)btn6Action:(id)sender {
    SettingViewController *settingVc = [[SettingViewController alloc] init];
    settingVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVc animated:YES];
}
- (IBAction)walletAction:(id)sender {
    if (_userModel.AuthStatus.intValue != 1){
        [self showAlertView];
        return;
    }
    WalletViewController* ctr = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"WalletViewController"];
    ctr.userModel = self.userModel;
    ctr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctr animated:true];
}
- (IBAction)WBalanceAction:(id)sender {
    if (_userModel.AuthStatus.intValue != 1){
        [self showAlertView];
        return;
    }
    WBalanceVC* ctr = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"WBalanceVC"];
    ctr.userModel = self.userModel;
    ctr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctr animated:true];
}

- (IBAction)userAgreement {
    UserAgreementViewController *mapVc = [[UserAgreementViewController alloc] init];
    mapVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapVc animated:YES];
}

#pragma mark - UIImagePickerController Delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSData *data;
    
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *scaleImage = [UIImage scaleImage:editedImage ToSize:CGSizeMake(100, 100)];
        data = UIImageJPEGRepresentation(scaleImage, 0.5);
        [self uploadHeadImgWithData:data];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCustomCell"];
//    MyCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyNewCustomCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, 0.01)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
