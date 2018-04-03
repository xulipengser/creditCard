//
//  FMPhotoGridCollectionCell.m
//  Pinnacle
//
//  Created by DengLliujun on 16/6/14.
//  Copyright © 2016年 5milesapp.com. All rights reserved.
//

#import "FMPhotoGridCollectionCell.h"

@interface FMPhotoGridCollectionCell()
@end

@implementation FMPhotoGridCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageView];
        imageView.clipsToBounds = YES;
        _imageView = imageView;
        
        UIImage *checkImage = [UIImage imageNamed:@"sel_no_like"];
        _checkButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - checkImage.size.width - 5*2 , 0, checkImage.size.width + 5*2, checkImage.size.height + 5*2)];
        [self.contentView addSubview:_checkButton];
        [_checkButton setImage:checkImage forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"sel_like"] forState:UIControlStateSelected];
        _checkButton.userInteractionEnabled = NO;
        
        
        UIImage *videoImg = [UIImage imageNamed:@"video_play"];
        CGFloat X = 2;
        CGFloat Y = self.frame.size.height - videoImg.size.height - 2;
        _isVideoBtn = [[UIButton alloc] initWithFrame:CGRectMake(X, Y, videoImg.size.width, videoImg.size.height)];
        [self.contentView addSubview:_isVideoBtn];
        [_isVideoBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
        _isVideoBtn.userInteractionEnabled = NO;
        
        CGFloat labelW = 60;
        CGFloat labelH = 12;
        CGFloat labelX = self.frame.size.width - labelW - 2;
        CGFloat labelY = self.frame.size.height - labelH;
        _durationLbl = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        _durationLbl.textColor = [UIColor whiteColor];
        _durationLbl.font = [UIFont systemFontOfSize:10.0];
        _durationLbl.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_durationLbl];
        _durationLbl.userInteractionEnabled = NO;
    }
    
    return self;
}

@end
