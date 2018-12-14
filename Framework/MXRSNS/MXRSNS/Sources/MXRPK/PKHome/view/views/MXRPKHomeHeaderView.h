//
//  MXRPKHomeHeaderView.h
//  huashida_home
//
//  Created by 周建顺 on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRPKHomeHeaderViewModel.h"

@class MXRPKHomeHeaderView;

typedef void(^MXRPKHomeHeaderViewActionBlock)(MXRPKHomeHeaderView *sender);

@interface MXRPKHomeHeaderView : UICollectionReusableView

@property (nonatomic, strong) MXRPKHomeHeaderViewModel *headerViewModel;

@property (nonatomic, copy) MXRPKHomeHeaderViewActionBlock goMedalsBlock;

@end
