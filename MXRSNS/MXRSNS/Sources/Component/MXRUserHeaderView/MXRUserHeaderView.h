//
//  MXRUserHeaderView.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/8/27.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRUserHeaderView : UIView


/**
 default mode UIViewContentModeScaleAspectFill
 */
@property (nonatomic, readonly) UIImageView *userHeaderImageView;


/**
 头像url
 */
@property (nonatomic, strong) NSString *headerUrl;


/**
 头像image
 */
@property (nonatomic, strong) UIImage *headerImage;

/**
 default is NO
 */
@property (nonatomic, assign, getter=isVip, setter=setVip:) BOOL vip;

/**
 default is NO  戴皇冠的
 */
@property (nonatomic, assign) BOOL hasVipCrown;

/**
 default is NO , 个人页面用到
 */
@property (nonatomic, assign) BOOL hasOutsideBorder;

/**
 default is 1 , 边距
 */
@property (nonatomic, assign) CGFloat userHeaderPadding;

/**
 default is MXRIMAGE(@"icon_common_default_head")
 */
@property (nonatomic, strong) UIImage *placeHolderheaderImage;

//@property (nonatomic, assign) BOOL isChoiceness;       // 精选
@property (nonatomic, assign) BOOL hasVIPLabel;        // 主要用于梦想圈显示vip标签的

@end
