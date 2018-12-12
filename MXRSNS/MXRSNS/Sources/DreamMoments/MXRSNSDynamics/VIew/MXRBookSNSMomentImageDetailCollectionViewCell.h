//
//  MXRBookSNSMomentImageDetailCollectionViewCell.h
//  huashida_home
//
//  Created by gxd on 16/9/30.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRBookSNSUploadImageInfo.h"
@interface MXRBookSNSMomentImageDetailCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic) MXRBookSNSUploadImageInfo * imageInfo;
@property (assign, nonatomic) BOOL isShowDetailImage;
@end
