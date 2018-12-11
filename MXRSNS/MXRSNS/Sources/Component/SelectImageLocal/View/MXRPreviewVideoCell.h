//
//  MXRPreviewVideoCell.h
//  huashida_home
//
//  Created by yuchen.li on 16/12/19.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MXRPreviewVideoCellDelegate <NSObject>
-(void)userSingleClick;
-(void)userPauseORPlayVideo:(BOOL)isPause;
-(void)userEndPlayVideo;
-(void)userDeleteVideo;
@end
@class MXRImageInformationModel;
@interface MXRPreviewVideoCell : UICollectionViewCell

@property (nonatomic, strong) UIImage  *iconImage;
@property (nonatomic, strong) UIButton *videoPauseButton;
@property (nonatomic, strong) MXRImageInformationModel*model;
@property (nonatomic, weak)id <MXRPreviewVideoCellDelegate>delegate;
@property (nonatomic, assign) BOOL isSharePlay; //是否分享播放，默认为NO

- (void)recoverSubviews;
@end
