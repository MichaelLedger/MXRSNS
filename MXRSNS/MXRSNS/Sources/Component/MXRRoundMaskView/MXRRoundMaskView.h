//
//  MXRRoundMaskView.h
//  huashida_home
//
//  Created by MountainX on 2017/12/28.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRRoundMaskView : UIView

/**
 需要事件穿透的视图数组(按优先级排列，以响应视图数组中的点击事件)
 */
@property (nullable, nonatomic, copy)NSArray <__kindof UIView *> *passthroughViews;

@end
