//
//  MXRPreviewImageViewController.h
//  huashida_home
//
//  Created by MountainX on 2018/2/22.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXRBookSNSUploadImageInfo;

@protocol MXRPreviewImageViewControllerDelegate <NSObject>

/**
 获取点赞状态
 */
- (BOOL)previewCheckPraiseStatus;

/**
 点赞
 */
- (void)previewPraise;

/**
 评论
 */
- (void)previewComment;

/**
 转发
 */
- (void)previewPromote;

@end

@class MXRBookSNSMomentImageDetailCollection;

@interface MXRPreviewImageViewController : UIViewController

@property (nonatomic, strong)MXRBookSNSUploadImageInfo *imageInfo;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) NSMutableArray *imageViewFrameArray;//外部的图片控件数组

@property (nonatomic, weak) id<MXRPreviewImageViewControllerDelegate> delegate;

@end
