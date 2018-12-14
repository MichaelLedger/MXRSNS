//
//  YYPhotoCollectionViewCell.h
//  huashida_home
//
//  Created by MountainX on 2018/3/1.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYPhotoBrowserSubScrollView.h"

@class MXRBookSNSUploadImageInfo;

@interface YYPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) MXRBookSNSUploadImageInfo *imageInfo;

@property (nonatomic, assign) CGRect imageFrame;

@property (nonatomic, strong)YYPhotoBrowserSubScrollView *subScrollView;

@property (nonatomic, weak) id<YYPhotoBrowserSubScrollViewDelegate> delegate;

- (void)reloadCell;

@end
