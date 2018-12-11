//
//  YYPhotoCollectionViewCell.m
//  huashida_home
//
//  Created by MountainX on 2018/3/1.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "YYPhotoCollectionViewCell.h"
#import "YYPhotoBrowserSubScrollView.h"

@implementation YYPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setDelegate:(id<YYPhotoBrowserSubScrollViewDelegate>)delegate {
    _delegate = delegate;
    _subScrollView.delegate = _delegate;
}

- (void)setImageInfo:(MXRBookSNSUploadImageInfo *)imageInfo {
    _imageInfo = imageInfo;
    _subScrollView.imageInfo = _imageInfo;
}

- (void)setImageFrame:(CGRect)imageFrame {
    _imageFrame = imageFrame;
    _subScrollView.imageFrame = _imageFrame;
}

- (void)reloadCell {
    [_subScrollView reloadData];
}

- (void)setup {
    YYPhotoBrowserSubScrollView *subScrollView = [[YYPhotoBrowserSubScrollView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:subScrollView];
    _subScrollView = subScrollView;
}

@end
