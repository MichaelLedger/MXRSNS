//
//  TZPhotoPreviewCell.h
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRBookSNSUploadImageInfo.h"
@protocol MXRPreViewCellDelegate <NSObject>
-(void)userSingleClick;
@end

@interface MXRPreviewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MXRBookSNSUploadImageInfo * imageInfo;
@property (nonatomic,   weak) id <MXRPreViewCellDelegate>delegate;
@property (nonatomic,   copy) void (^imageViewClick)(UIView * previewCell);
- (void)recoverSubviews;

@end
