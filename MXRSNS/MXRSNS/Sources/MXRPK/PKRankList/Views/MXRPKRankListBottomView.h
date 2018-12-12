//
//  MXRPKRankListBottomView.h
//  huashida_home
//
//  Created by MinJing_Lin on 2018/10/24.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MXRPKRankListModel;

@interface MXRPKRankListBottomView : UIView

@property (nonatomic, strong) MXRPKRankListModel *rankModel;

+ (instancetype)instancePKRankListView;

@end

