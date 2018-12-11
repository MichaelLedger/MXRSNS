//
//  MXRBookSNSUserHandleMomentView.h
//  huashida_home
//
//  Created by gxd on 16/9/23.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRSNSShareModel.h"
typedef NS_ENUM(NSInteger,MXRUserHandleMomentViewType){
    MXRUserHandleMomentViewTypeDelete = 1,
    MXRUserHandleMomentViewTypeNoInterest = 2,
    MXRUserHandleMomentViewTypeReport = 3
};
typedef NS_ENUM(NSInteger,MXRUserHandleMomentBelongViewtype){
    MXRUserHandleMomentBelongViewtypeBookSNSView = 1,
    MXRUserHandleMomentBelongViewtypeTopicView = 2,
    MXRUserHandleMomentBelongViewtypeMyBookSNSView = 3
};
@interface MXRBookSNSUserHandleMomentView : UIView
+(instancetype) getInstance;
-(void)showWithIsXiaomengMoment:(BOOL)isSystemMoment momentID:(NSString *)momentId  andUnFocusUserId:(NSString *)userId andMomentBelongViewtype:(MXRBookSNSBelongViewtype )belongViewtype;
@end
