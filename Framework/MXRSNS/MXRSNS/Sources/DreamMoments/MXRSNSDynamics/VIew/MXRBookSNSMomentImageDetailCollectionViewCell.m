//
//  MXRBookSNSMomentImageDetailCollectionViewCell.m
//  huashida_home
//
//  Created by gxd on 16/9/30.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSMomentImageDetailCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "GlobalBusyFlag.h"
#import "Masonry.h"
@interface MXRBookSNSMomentImageDetailCollectionViewCell()



@end
@implementation MXRBookSNSMomentImageDetailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
    // Initialization code
}

-(void)setup{

    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
    }];
    [self.scrollView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView.mas_right).offset(0);
        make.top.equalTo(self.scrollView.mas_top).offset(0);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(0);
        make.left.equalTo(self.scrollView.mas_left).offset(0);
    }];
    
}
-(void)setImageInfo:(MXRBookSNSUploadImageInfo *)imageInfo{

    _imageInfo = imageInfo;
}
-(void)setIsShowDetailImage:(BOOL)isShowDetailImage{

    @MXRWeakObj(self);
    _isShowDetailImage = isShowDetailImage;
    if (isShowDetailImage) {
        
    }else{
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    if (_imageInfo.image) {
        _imageView.image = _imageInfo.image;
    }else{
        if (isShowDetailImage) {
            
            [[GlobalBusyFlag sharedInstance] showDownloadIamgeLoading];
//            [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageInfo.imageUrl] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                [[GlobalBusyFlag sharedInstance] hideDownloadIamgeLoading];
//                selfWeak.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH_DEVICE_ABSOLUTE, SCREEN_HEIGHT_DEVICE_ABSOLUTE);
//                selfWeak.imageView.contentMode = UIViewContentModeScaleAspectFit;
//                selfWeak.imageView.image = image;
//                selfWeak.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE_ABSOLUTE, SCREEN_HEIGHT_DEVICE_ABSOLUTE);
//            }];
        }else{
//            [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageInfo.shrinkImageUrl] placeholderImage:MXRIMAGE(@"icon_common_bookIconPlaceholder") options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//            }];
        }
    }
   
}
#pragma mark - getter
-(UIScrollView *)scrollView{

    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.maximumZoomScale = 1.1f;
        _scrollView.minimumZoomScale = 1.0f;
//        _scrollView.delegate = self;
        _scrollView.decelerationRate = 0.5f;
//        _scrollView.zoomScale = 1.0f;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH_DEVICE_ABSOLUTE, SCREEN_HEIGHT_DEVICE_ABSOLUTE);
    }
    return _scrollView;
}
-(UIImageView *)imageView{

    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
@end


