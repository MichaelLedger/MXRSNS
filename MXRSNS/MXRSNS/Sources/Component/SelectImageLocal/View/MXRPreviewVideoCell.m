//
//  MXRPreviewVideoCell.m
//  huashida_home
//
//  Created by yuchen.li on 16/12/19.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPreviewVideoCell.h"
#import "UIView+MXRFrame.h"
#import "MXRGetLocalImageController.h"
#import <AVFoundation/AVFoundation.h>
#import "MXRImageInformationModel.h"
#import <Photos/Photos.h>
#import "MXRMp4Play.h"
@interface MXRPreviewVideoCell ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>{
  CGFloat _aspectRatio;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIView *videoView;


@end


@implementation MXRPreviewVideoCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, self.mxr_width, self.mxr_height);
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self addSubview:_scrollView];
        
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor=[UIColor blackColor];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        _videoPauseButton=[[UIButton alloc]init];
        [_videoPauseButton addTarget:self action:@selector(changeStateToVideo:) forControlEvents:UIControlEventTouchUpInside];
        [_imageContainerView addSubview:_videoPauseButton];
        
        _videoView=[self createVideoView];
        [_imageContainerView addSubview:_videoView];
        
        [_imageContainerView bringSubviewToFront:_videoPauseButton];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        
    }
    return self;
}

-(void)setIconImage:(UIImage *)iconImage{
    
    self.imageView.image = iconImage;
    
}

- (void)setIsSharePlay:(BOOL)isSharePlay{
    _isSharePlay = isSharePlay;
    
    if (self.isSharePlay) {
        [self changeStateToVideo:nil];
    }
}

-(void)setModel:(MXRImageInformationModel *)model{
    
    _model = model;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preViewScroll) name:Notification_PreviewScroll_End_Decceleting object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toPauseVideo) name:Notification_Video_To_Pause object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toPlayVideo) name:Notification_Video_To_Play object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteVideo) name:Notification_Go_To_Reload_Data_After_Delete object:nil];
    [_scrollView setZoomScale:1.0 animated:NO];
    [self.videoPauseButton setImage:MXRIMAGE(@"btn_common_bigVideoPlay") forState:UIControlStateNormal];
    self.videoPauseButton.hidden = NO;
    self.videoPauseButton.enabled = YES;
    [self resizeSubviews];

}
- (void)recoverSubviews {
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

/*
 * 一开始点击播放视频
 */
-(void)changeStateToVideo:(UIButton*)sender{
    sender.enabled = NO;
        @MXRWeakObj(self);
        [[MXRGetLocalImageController getInstance]getVideoFromAlbumWithPHAsset:self.model completionHandler:^(BOOL isOkay) {
            if (isOkay) {
                if (selfWeak.model.videoURL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [selfWeak toPlayVideo];
                    });
                }else{
                    assert(0);
                }
            }else{
                assert(0);
            }
        }];
}

/*
 * 播放视频
 */
-(void)toPlayVideo{
    @MXRWeakObj(self);
    MXRMp4Play *playManager = [MXRMp4Play shareMp4PlayManager];
    if (![playManager videoPlaying]) {
        [playManager isHeFaMp4:[self.model.videoURL absoluteString] startAt:0 endOf:-1];
        [playManager playMp4OnView:self.videoView url:self.model.videoURL stopCallBack:^(NSDictionary *dict) {
            [selfWeak videoPlayEnd];
        }];
    }else{
        [playManager play];
    }
    [self checkVideoPlayStatus];
    [self.delegate userPauseORPlayVideo:[[MXRMp4Play shareMp4PlayManager] videoPlaying]];
}

/*
 * 暂停视频播放
 */
-(void)toPauseVideo{
    [[MXRMp4Play shareMp4PlayManager] pausePlay];
    [self checkVideoPlayStatus];
}

-(void)checkVideoPlayStatus{
    if (![[MXRMp4Play shareMp4PlayManager] videoPlaying]) {
        
//        [self.videoPauseButton setImage:MXRIMAGE(@"btn_common_bigVideoPlay") forState:UIControlStateNormal];
//        self.videoPauseButton.enabled = YES;
        
    }else{
        [self.videoPauseButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.videoPauseButton.enabled = NO;
    }
}

/*
 *  视频自动结束播放
 */
-(void)videoPlayEnd{
    [[MXRMp4Play shareMp4PlayManager] stopPlay];
    [self checkVideoPlayStatus];
    if (self.isSharePlay) {
        [self toPlayVideo];  //分享页面重复播放视频
    }else{
        [self.delegate userEndPlayVideo];  //其它页面播放完成之后暂停
    }
    
}

/*
 *  滑动时 结束播放刷新videoCell 和 MXRPreViewViewController
 */
- (void)preViewScroll{
    self.videoPauseButton.enabled = YES;
    [self.videoPauseButton setImage:MXRIMAGE(@"btn_common_bigVideoPlay") forState:UIControlStateNormal];
    [[MXRMp4Play shareMp4PlayManager] stopPlay];
    [self.delegate userEndPlayVideo];
}

/*
 *  播放过程中删除该视频 结束播放刷新videoCell 和 MXRPreViewViewController
 */
- (void)deleteVideo{
    self.videoPauseButton.enabled = YES;
    [self.videoPauseButton setImage:MXRIMAGE(@"btn_common_bigVideoPlay") forState:UIControlStateNormal];
    [[MXRMp4Play shareMp4PlayManager] stopPlay];
    [self.delegate userDeleteVideo];
    
}
- (void)resizeSubviews {
    _imageContainerView.mxr_origin = CGPointZero;
    _imageContainerView.mxr_width = self.scrollView.mxr_width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.mxr_height / self.scrollView.mxr_width) {
        _imageContainerView.mxr_height = floor(image.size.height / (image.size.width / self.scrollView.mxr_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.mxr_width;
        if (height < 1 || isnan(height)) height = self.mxr_height;
        height = floor(height);
        _imageContainerView.mxr_height = height;
        _imageContainerView.mxr_centerY = self.mxr_height / 2;
    }
    if (_imageContainerView.mxr_height > self.mxr_height && _imageContainerView.mxr_height - self.mxr_height <= 1) {
        _imageContainerView.mxr_height = self.mxr_height;
    }
    _scrollView.contentSize = CGSizeMake(self.scrollView.mxr_width, MAX(_imageContainerView.mxr_height, self.mxr_height));
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.mxr_height <= self.mxr_height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
    _videoPauseButton.center =_imageView.center;
    CGSize pauseView = CGSizeMake(1.0/7.0*_imageView.frame.size.width, 1.0/7.0*_imageView.frame.size.width);
    _videoPauseButton.mxr_size = pauseView;
    _videoView.frame =_imageView.frame;
}

#pragma mark - UITapGestureRecognizer Event

/*
 * 双击放大视频
 */
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

/*
 * 单击
 */
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(userSingleClick)]) {
        [self.delegate userSingleClick];
    }
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.mxr_width > scrollView.contentSize.width) ? (scrollView.mxr_width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.mxr_height > scrollView.contentSize.height) ? (scrollView.mxr_height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

-(UIView*)createVideoView{
    if (!_videoView) {
        _videoView=[[UIView alloc]init];
    }
    return _videoView;
}
-(void)dealloc{
    DLOG_METHOD
    [[MXRMp4Play shareMp4PlayManager]stopPlay];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}
@end
