//
//  MXRBookSNSDeleteForwardTableViewCell.h
//  huashida_home
//
//  Created by gxd on 16/10/13.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRSNSShareModel.h"
#import "MXRBookSNSUserHandleMomentView.h"
#import "MXRBookSNSPraiseModel.h"
@interface MXRBookSNSDeleteForwardTableViewCell : UITableViewCell
@property (strong, nonatomic) NSNumber * isSNSDetailView;
@property (assign, nonatomic) MXRBookSNSBelongViewtype belongViewtype;
@property (copy, nonatomic) void (^deleteMomentClick)(MXRUserHandleMomentViewType handleType , NSString * momentIdOrUserId);
@property (strong, nonatomic) MXRSNSShareModel * model;

@property(strong,nonatomic)MXRBookSNSPraiseModel *praiseModel;     //   动态的点赞数据模型
@end
