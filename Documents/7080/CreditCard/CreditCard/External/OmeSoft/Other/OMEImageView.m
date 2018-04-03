

#import "OMEImageView.h"
#import "UIImageView+WebCache.h"
#import "OMESoft.h"

#define defaultWith 120

@implementation OMEImageView

- (void)dealloc
{
    [self sd_cancelCurrentImageLoad];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithFrame:CGRectZero];
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isIncludeBorder = YES;
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self imageWithURL:_imageURL];
}

#pragma mark - Public methods
- (void)imageWithURL:(NSURL *)url
{
    [self imageWithURL:url placeholdImage:self.placeholderImage isNeedBorder:NO isRound:NO isNeedScale:NO];
}

- (void)headerImageWithURL:(NSURL *)url
{
   [self imageWithURL:url placeholdImage:self.placeholderImage isNeedBorder:self.isIncludeBorder isRound:YES isNeedScale:NO];
}

- (void)bbsImageWithURL:(NSURL *)url isNeedScale:(BOOL)isNeedScale
{
    [self imageWithURL:url placeholdImage:self.placeholderImage isNeedBorder:NO isRound:NO isNeedScale:isNeedScale];
}

- (void)imageWithURL:(NSURL *)url placeholdImage:(UIImage *)placeholdImage isNeedBorder:(BOOL)isNeedBorder isRound:(BOOL)isRound isNeedScale:(BOOL)isNeedScale
{
    if (!url) {
        self.image = placeholdImage;
        return;
    }
    __weak __typeof(self) weakself = self;
    [self sd_setImageWithURL:url placeholderImage:placeholdImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) return;
        if (isNeedScale) {
            float scale = defaultWith/MIN(image.size.width, image.size.height);
            UIImage *img = [self scaleImage:image toScale:scale];
            weakself.image = [self cutWithImage:img];
            [weakself setNeedsLayout];
        } else if (isRound) {
            weakself.image = [weakself addRoundBoardWithImage:image isBorder:isNeedBorder];
            [weakself setNeedsLayout];
        }
    }];
}

#pragma mark - bbs scale
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)cutWithImage:(UIImage *)image
{
    CGRect imageRect = CGRectMake((image.size.width - defaultWith)/2, (image.size.height - defaultWith)/2, defaultWith, defaultWith);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, imageRect);
    UIGraphicsBeginImageContext(imageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, imageRect, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}

#pragma mark - Round image

- (UIImage *)addRoundBoardWithImage:(UIImage *)image isBorder:(BOOL)isBorder
{
    if (!image) return image;
    float scale = [[UIScreen mainScreen] scale];
    float pxWidth = scale *  2.0;
    float px = 200;
    CGRect imageRect = CGRectMake(0, 0, px, px);
    CGRect boardRect = CGRectMake(pxWidth/2.0, pxWidth/2.0, px-pxWidth, px-pxWidth);
    
    UIGraphicsBeginImageContext(imageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == nil) {
        return nil;
    }
    CGContextTranslateCTM(context, 0, imageRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, boardRect);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, px, px), image.CGImage);
    CGContextRestoreGState(context);
    if (isBorder) {
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, pxWidth);
        CGContextStrokeEllipseInRect(context, boardRect);
        CGContextRestoreGState(context);
    }
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(newCGImage);
    return newImage;
}

@end
