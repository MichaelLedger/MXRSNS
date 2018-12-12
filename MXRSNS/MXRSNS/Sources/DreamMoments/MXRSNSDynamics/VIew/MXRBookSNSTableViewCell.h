//
//  MXRBookSNSTableViewCell.h
//  huashida_home
//
//  Created by gxd on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRBookSNSUserHandleMomentView.h"
#import "MXRSNSShareModel.h"
#import "MXRBookSNSPraiseModel.h"
@class MXRBookSNSMomentImageView;
@protocol MXRBookSNSTableViewCellDelegate <NSObject>
//Usage: Only To Register For Previewing(3D-Touch)
@optional
- (void)commentSNSFromPreview;//预览下对动态进行评论
- (void)praiseSNSFromPreview;//预览下对动态进行点赞
- (void)commentSNSFromCell:(MXRSNSShareModel *)model;//点击评论按钮对动态进行评论
@end

@interface MXRBookSNSTableViewCell : UITableViewCell
@property (strong, nonatomic) NSNumber * isSNSDetailView;
@property (assign, nonatomic) MXRBookSNSBelongViewtype belongViewtype;
@property (copy, nonatomic) void (^imageClick)(BOOL isShowTabbar);
@property (copy, nonatomic) void (^deleteMomentClick)(MXRUserHandleMomentViewType handleType , NSString * momentIdOrUserId);
@property (strong, nonatomic) MXRSNSShareModel * model;
@property (nonatomic, weak) id<MXRBookSNSTableViewCellDelegate> delegate;

@property(strong,nonatomic)MXRBookSNSPraiseModel *praiseModel;     //   动态的点赞数据模型
@end
