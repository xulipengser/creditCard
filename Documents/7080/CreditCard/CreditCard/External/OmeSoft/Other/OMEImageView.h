//
//  OMEImageView.h
//  FirstAid
//
//  Created by Omesoft on 12-10-22.
//
//

#import <UIKit/UIKit.h>

@interface OMEImageView : UIImageView

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, assign) BOOL isIncludeBorder;
@property (nonatomic, strong) NSURL *imageURL;

- (void)imageWithURL:(NSURL *)url;

- (void)headerImageWithURL:(NSURL *)url;

- (void)bbsImageWithURL:(NSURL *)url isNeedScale:(BOOL)isNeedScale;
@end
