//
//  UIView+MXRFrame.h
//  huashida_home
//
//  Created by yuchen.li on 17/2/28.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MXRFrame)
@property (nonatomic) CGFloat mxr_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat mxr_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat mxr_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat mxr_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat mxr_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat mxr_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat mxr_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat mxr_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint mxr_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  mxr_size;        ///< Shortcut for frame.size.
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@end
