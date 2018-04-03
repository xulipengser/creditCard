//
//  RealNameAuthViewController3.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/23.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "RealNameAuthViewController3.h"
#import <AVFoundation/AVFoundation.h>
#import "UIButton+WebCache.h"
#import "MBProgressHUD+CAAdd.h"
#import "RealNameCertModel.h"
#import "UserModel.h"
#import "BankModel.h"
@interface RealNameAuthViewController3 () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) RealNameCertModel *realNameModel;
@property(nonatomic, strong) UserModel *userModel;
@property(nonatomic, strong) NSArray *bankList;
@end

@implementation RealNameAuthViewController3

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nextBtn.layer.cornerRadius = 23;
    self.nextBtn.layer.masksToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    NSDictionary *userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoData"];
    self.userModel = [UserModel objectWithKeyValues:userInfoDict];
    [self getBankList];
    
}

- (instancetype)initWithModel:(RealNameCertModel *)realNameModel
{
    self = [super init];
    if (self) {
        _realNameModel = realNameModel;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - Private
- (void)getBankList
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
    
    [mgr POST:BankListURL parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            self.bankList = [BankModel objectArrayWithKeyValuesArray:[dataDict objectForKey:@"BankList"]];
            
        } else {
            [hud hide:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

#pragma mark - UIImagePickerController Delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSData *data;
    
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.scanBtn setImage:editedImage forState:UIControlStateNormal];
        data = UIImageJPEGRepresentation(editedImage, 0.5);
        [self uploadHoldIdCardImgWithData:data];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action
- (void)updateUserInfo
{
    if([self.address.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请输入现住址"];
        return;
    }
    if([self.email.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请输入邮箱"];
        return;
    }
    
    if (![self.email.text isEmail]) {
        [MBProgressHUD showError:@"请输入正确的邮箱格式"];
        return;
    }
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [parametersDict setObject:self.userModel.UserID forKey:@"UserID"];
    [parametersDict setObject:self.address.text forKey:@"Address"];
    [parametersDict setObject:self.email.text forKey:@"Email"];
    
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr POST:UpdateUserInfo parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            self.userModel = [UserModel objectWithKeyValues:dataDict];
            [self certAction];
        } else {
            NSString *msg = [dict objectForKey:@"RespMsg"];
            [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:1.0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}


- (void)certAction
{
    MBProgressHUD *hud = [MBProgressHUD showMessageWithActivityIndicator:@"" toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:10];
    [parametersDict setObject:self.realNameModel.UserID forKey:@"UserID"];
    [parametersDict setObject:self.realNameModel.RealName forKey:@"RealName"];
    [parametersDict setObject:self.realNameModel.IdCardNo forKey:@"IdCardNo"];
    [parametersDict setObject:self.realNameModel.BankMobile forKey:@"BankMobile"];
    [parametersDict setObject:@"aaa" forKey:@"BranchBankName"];
    [parametersDict setObject:@"123" forKey:@"BranchBankCode"];
    
    [parametersDict setObject:[self.realNameModel.BankCardNo stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"BankCardNo"];
    for (BankModel* bank in _bankList) {
        if ([_realNameModel.BankId indexOfAccessibilityElement:bank.BankName] != -1){
            [parametersDict setObject:bank.Id forKey:@"BankId"];
            break;
        }
    }
    
    [parametersDict setObject:self.realNameModel.IdCardImgUrl forKey:@"IdCardImgUrl"];
    [parametersDict setObject:self.realNameModel.BankCardImgUrl forKey:@"BankCardImgUrl"];
    [parametersDict setObject:self.realNameModel.HoldIdCardImgUrl forKey:@"HoldIdCardImgUrl"];
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr POST:IdCertURL parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"111");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            [MBProgressHUD showProgressWithTitle:@"资料提交成功, 请等待审核" message:nil duration:1.0];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
            //            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            //            NSString* signature = [dataDict objectForKey:@"Signature"];
            //            NSMutableDictionary* mutableDic = [NSMutableDictionary dictionaryWithDictionary:dataDict];
            //            [mutableDic removeObjectForKey:@"Signature"];
            //            NSDictionary* newDic = mutableDic;
            //            if ([signature isEqualToString:[newDic getSignature:PrivateKey]]) {
            //                [[NSUserDefaults standardUserDefaults] setObject:dataDict forKey:@"userInfoData"];
            //                [[NSUserDefaults standardUserDefaults]synchronize];
            //                [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
            //                [MBProgressHUD showProgressWithTitle:@"资料提交成功, 请等待审核" message:nil duration:1.0];
            //                [self.navigationController popToRootViewControllerAnimated:YES];
            //            }else{
            //                [MBProgressHUD showProgressWithTitle:@"请求失败" message:nil duration:1.0];
            //            }
        } else {
            NSString *msg = [dict objectForKey:@"RespMsg"];
            [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:1.0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
    
    
}

// 上传手持身份证照片
- (void)uploadHoldIdCardImgWithData:(NSData *)data
{
    self.hud = [MBProgressHUD showMessageWithActivityIndicator:@"" toView:self.view];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 20.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [parametersDict setObject:self.realNameModel.UserID forKey:@"UserID"];
    [parametersDict setObject:@"3" forKey:@"ImageBusinessType"];  // 0头像 1 用户身份证正面  2用户银行卡正面  3用户手持身份证照片
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
            self.realNameModel.HoldIdCardImgUrl = [dataDict objectForKey:@"ImgUrl"];
            
            // 上传身份证图片
            NSData *data = UIImageJPEGRepresentation(self.realNameModel.IdCardImg, 0.5);
            [self uploadIdCardImgUrlWithData:data];
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

// 上传银行卡照片
- (void)uploadBankCardImgWithData:(NSData *)data
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 20.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [parametersDict setObject:self.realNameModel.UserID forKey:@"UserID"];
    [parametersDict setObject:@"2" forKey:@"ImageBusinessType"];  // 0头像 1 用户身份证正面  2用户银行卡正面  3用户手持身份证照片
    [parametersDict  setObject:[parametersDict getSignature:PrivateKey]  forKey:@"Signature"];
    
    [mgr POST:UploadFileURL parameters:parametersDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件参数
        [formData appendPartWithFileData:data name:@"userPic" fileName:@"userPic.png" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印上传进度
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"%.2lf%%", progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.hud hide:YES];
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSString *RespCode = [dict objectForKey:@"RespCode"];
        if ([RespCode isEqualToString:@"000000"]) {
            NSDictionary *dataDict = [dict objectForKey:@"Data"];
            self.realNameModel.BankCardImgUrl = [dataDict objectForKey:@"ImgUrl"];
        } else {
            NSString *msg = [dict objectForKey:@"RespMsg"];
            [MBProgressHUD showProgressWithTitle:@"提示" message:msg duration:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.hud hide:YES];
        [MBProgressHUD showProgressWithTitle:error.localizedDescription message:error.localizedFailureReason duration:1.5];
    }];
}

// 上传身份证照片
- (void)uploadIdCardImgUrlWithData:(NSData *)data
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 20.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [parametersDict setObject:self.realNameModel.UserID forKey:@"UserID"];
    [parametersDict setObject:@"1" forKey:@"ImageBusinessType"];  // 0头像 1 用户身份证正面  2用户银行卡正面  3用户手持身份证照片
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
            self.realNameModel.IdCardImgUrl = [dataDict objectForKey:@"ImgUrl"];
            
            // 上传银行卡图片
            NSData *data = UIImageJPEGRepresentation(self.realNameModel.BankCardImg, 0.5);
            [self uploadBankCardImgWithData:data];
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

- (IBAction)scanBtnAction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 2.创建并添加按钮
    UIAlertAction *phoneAction = [UIAlertAction actionWithTitle:@"手机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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

- (IBAction)nextBtnAction:(id)sender {
    if (self.scanBtn.currentImage == nil) {
        [MBProgressHUD showProgressWithTitle:@"请先上传手持身份证照片" message:nil duration:1.0];
        return;
    }
    
    [self updateUserInfo];
}

@end
