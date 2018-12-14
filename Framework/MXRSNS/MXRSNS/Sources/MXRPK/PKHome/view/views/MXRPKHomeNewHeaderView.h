//
//  MXRPKHomeNewHeaderView.h
//  huashida_home
//
//  Created by MountainX on 2018/10/15.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRPKHomeHeaderViewModel.h"

@class MXRPKHomeNewHeaderView;

typedef void(^MXRPKHomeHeaderViewActionBlock)(MXRPKHomeNewHeaderView *sender);
typedef void(^MXRPKHomeHeaderViewBeginPKBlock)();
typedef void(^MXRPKHomeHeaderViewBeginChallengeBlock)();
typedef void(^MXRPKHomeHeaderViewJumpToRankBlock)();
typedef void(^MXRPKHomeHeaderViewJumpToPropBlock)();
typedef void(^MXRPKHomeHeaderViewJumpToVIPBlock)();

@interface MXRPKHomeNewHeaderView : UICollectionReusableView

@property (nonatomic, strong) MXRPKHomeHeaderViewModel *headerViewModel;

@property (nonatomic, copy) MXRPKHomeHeaderViewActionBlock goMedalsBlock;

@property (copy, nonatomic) MXRPKHomeHeaderViewBeginPKBlock beginPKBlock;

@property (copy, nonatomic) MXRPKHomeHeaderViewBeginChallengeBlock beginChallengeBlock;

@property (copy, nonatomic) MXRPKHomeHeaderViewJumpToRankBlock jumpToRankBlock;

@property (copy, nonatomic) MXRPKHomeHeaderViewJumpToPropBlock jumpToPropBlock;

@property (copy, nonatomic) MXRPKHomeHeaderViewJumpToVIPBlock jumpToVIPBlock;

@end
