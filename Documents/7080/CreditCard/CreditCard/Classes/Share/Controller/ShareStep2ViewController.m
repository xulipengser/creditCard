//
//  ShareStep2ViewController.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/12.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "ShareStep2ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ShareCustom.h"
#import "UserModel.h"

@interface ShareStep2ViewController ()
@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UIImage *img;

@property(nonatomic, strong) UIImage *qrcodeImage;
@property(nonatomic, strong) UIImage *resultImage;

@property(nonatomic, strong) UserModel *userModel;
@end

@implementation ShareStep2ViewController

- (instancetype)initWithImg:(UIImage *)img
{
    self = [super init];
    if (self) {
        _img = img;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoData"];
    self.userModel = [UserModel objectWithKeyValues:userInfoDict];
    NSString *userStr = [NSString stringWithFormat:@"http://www.7080pay.cn/page/register.html?merMobile=%@", self.userModel.MobilePhone];
    [self genarateEncodeWithStr:userStr];
    self.navigationItem.title = @"分享";
    [self setRightBarBtn];
    [self.view addSubview:self.imgView];
}

#pragma mark - Private

- (void)genarateEncodeWithStr:(NSString *)qrStr{
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    //存放的信息
    NSString *info = qrStr;
    //把信息转化为NSData
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    //滤镜对象kvc存值
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    //我们可以打印,看过滤器的 输入属性.这样我们才知道给谁赋值
    NSLog(@"%@",filter.inputKeys);
    /*
     inputMessage,        //二维码输入信息
     inputCorrectionLevel //二维码错误的等级,就是容错率
     */
    CIImage *outImage = [filter outputImage];
    
    self.qrcodeImage = [self createNonInterpolatedUIImageFormCIImage:outImage withSize:100*HPFrameRatioWidth];
    
    // 生成图片
    CGSize size = self.view.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO,[UIScreen mainScreen].scale);
    [_img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [_qrcodeImage drawInRect:CGRectMake(size.width - 115, 15, 108*HPFrameRatioWidth, 108*HPFrameRatioWidth)];
    self.resultImage = UIGraphicsGetImageFromCurrentImageContext();
    self.imgView.image = _resultImage;
    UIGraphicsEndImageContext();
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度以及高度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)nextBtnClick:(UIButton *)btn
{
    //1、创建分享参数
    NSArray* imageArray = @[self.resultImage];
    
    if (imageArray) {
        
        NSString *userStr = [NSString stringWithFormat:@"http://www.7080pay.cn/page/register.html?merMobile=%@", self.userModel.MobilePhone];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"八戒卡管家，幸福你我他"
                                         images:imageArray
                                            url:[NSURL URLWithString:userStr]
                                          title:@"卡管家"
                                           type:SSDKContentTypeImage];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //调用自定义分享
        [ShareCustom shareWithContent:shareParams];
    }
  
}

- (void)setRightBarBtn
{
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}


#pragma mark - Get

- (UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenCGRect.size.width, MainScreenCGRect.size.height)];
        [_imgView setImage:_img];
    }
    return _imgView;
}

@end
