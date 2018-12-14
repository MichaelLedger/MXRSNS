//
//  TZPhotoPreviewCell.m
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "MXRPreviewCell.h"
#import "UIView+MXRFrame.h"
#import "UIImageView+WebCache.h"
#import "GlobalBusyFlag.h"
@interface MXRPreviewCell ()<UIGestureRecognizerDelegate,UIScrollViewDelegate> {
    CGFloat _aspectRatio;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;

@end

@implementation MXRPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor blackColor];
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
        _imageView.clipsToBounds = YES;
        
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
    }
    return self;
}

-(void)setIconImage:(UIImage *)iconImage
{
    self.imageView.image=iconImage;
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

-(void)setImageInfo:(MXRBookSNSUploadImageInfo *)imageInfo{

    _imageInfo = imageInfo;
    @MXRWeakObj(self);
    if (_imageInfo.image) {
        _imageView.image = _imageInfo.image;
        [selfWeak resizeSubviews];
        [[GlobalBusyFlag sharedInstance] hideDownloadIamgeLoading];
    }else{
        [[GlobalBusyFlag sharedInstance] showDownloadIamgeLoading];
        //Warning: SDWebImageProgressiveDownload : Crash When Image is GIF
//        [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageInfo.imageUrl] placeholderImage:nil options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (!image) {
//                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_imageInfo.shrinkImageUrl] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                    if (image) {
//                        selfWeak.imageView.contentMode = UIViewContentModeScaleAspectFit;
//                        selfWeak.imageView.image = image;
//                    }else{
//                        [selfWeak.imageView setImage:MXRIMAGE(@"icon_common_bookIconPlaceholder")];
//                    }
//                }];
//            }
//            [selfWeak resizeSubviews];
//            [[GlobalBusyFlag sharedInstance] hideDownloadIamgeLoading];
//        }];
    }
    [_scrollView setZoomScale:1.0 animated:NO];
}

- (void)recoverSubviews {
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
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
}
#pragma mark - UITapGestureRecognizer Event

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

- (void)singleTap:(UITapGestureRecognizer *)tap {
    
    if (self.imageViewClick) {
        self.imageViewClick(self);
    }
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

@end
