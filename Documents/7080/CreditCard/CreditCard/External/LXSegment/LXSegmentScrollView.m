//
//  LXSegmentScrollView.m
//  LiuXSegment
//
//  Created by liuxin on 16/5/17.
//  Copyright © 2016年 liuxin. All rights reserved.
//


#import "LXSegmentScrollView.h"
#import "LiuXSegmentView.h"

@interface LXSegmentScrollView()<UIScrollViewDelegate>
@property (strong,nonatomic)UIScrollView *bgScrollView;
@property (strong,nonatomic)LiuXSegmentView *segmentToolView;
@property (nonatomic, assign) NSInteger viewNum;
@end

@implementation LXSegmentScrollView


-(instancetype)initWithFrame:(CGRect)frame
                  titleArray:(NSArray *)titleArray
            contentViewArray:(NSArray *)contentViewArray{
    if (self = [super initWithFrame:frame]) {
        _viewNum = contentViewArray.count;
        [self addSubview:self.bgScrollView];
        _segmentToolView=[[LiuXSegmentView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44) titles:titleArray clickBlick:^void(NSInteger index) {
            [_bgScrollView setContentOffset:CGPointMake(frame.size.width*(index-1), 0)];
        }];
        [self addSubview:_segmentToolView];
        for (int i=0;i<contentViewArray.count; i++ ) {
            UIView *contentView = (UIView *)contentViewArray[i];
            contentView.frame=CGRectMake(frame.size.width * i, _segmentToolView.bounds.size.height, frame.size.width, _bgScrollView.frame.size.height-_segmentToolView.bounds.size.height);
            [_bgScrollView addSubview:contentView];
        }
    }
    return self;
}

-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _bgScrollView.contentSize=CGSizeMake(self.bounds.size.width*_viewNum, self.bounds.size.height);
        _bgScrollView.backgroundColor=[UIColor whiteColor];
        _bgScrollView.showsVerticalScrollIndicator=NO;
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.delegate=self;
        _bgScrollView.bounces=NO;
        _bgScrollView.pagingEnabled=YES;
    }
    return _bgScrollView;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_bgScrollView)
    {
        NSInteger p=_bgScrollView.contentOffset.x/_segmentToolView.frame.size.width;
        _segmentToolView.defaultIndex=p+1;
    }
}

@end
