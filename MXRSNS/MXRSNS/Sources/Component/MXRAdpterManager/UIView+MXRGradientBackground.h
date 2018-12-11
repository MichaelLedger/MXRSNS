//
//  UIView+MXRGradientBackground.h
//  huashida_home
//
//  Created by Martin.liu on 2017/11/14.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Direction of the linear gradient
 */
typedef NS_ENUM(NSInteger, MXRUIViewLinearGradientDirection) {
    /**
     *  Linear gradient vertical
     */
    MXRUIViewLinearGradientDirectionVertical = 0,
    /**
     *  Linear gradient horizontal
     */
    MXRUIViewLinearGradientDirectionHorizontal,
    /**
     *  Linear gradient from left to right and top to down
     */
    MXRUIViewLinearGradientDirectionDiagonalFromLeftToRightAndTopToDown,
    /**
     *  Linear gradient from left to right and down to top
     */
    MXRUIViewLinearGradientDirectionDiagonalFromLeftToRightAndDownToTop,
    /**
     *  Linear gradient from right to left and top to down
     */
    MXRUIViewLinearGradientDirectionDiagonalFromRightToLeftAndTopToDown,
    /**
     *  Linear gradient from right to left and down to top
     */
    MXRUIViewLinearGradientDirectionDiagonalFromRightToLeftAndDownToTop
};

typedef NS_ENUM(NSInteger, MXRUIViewGradientStyle) {
    MXRUIViewGradientStyleLightGreen,
    MXRUIViewGradientStylePink,
    MXRUIViewGradientStyleLightGreen2,
    MXRUIViewGradientStyleDarkGreen,
    MXRUIViewGradientStyleDarkGreenMain,
    MXRUIViewGradientStyle_F3F4F6_White,
    MXRUIViewGradientStyle_VIPButton,       // F5D895 - D29228
    MXRUIViewGradientStyle_009FD8_022D71, //pk Home header background color
    MXRUIViewGradientStyle_80F0EA_29AAFE,  //pk Medal button background color
    MXRUIViewGradientStyle_FF6A5C_FF392F,  //pk ZoneDetailCoupon button background color
    MXRUIViewGradientStyle_F5D895_D29228,  //pk ZoneDetailVIP button background color
    MXRUIViewGradientStyle_FF405F_FF7A4D,  //pk Result Logo BgColor
    MXRUIViewGradientStyle_FF7A4D_FF405F,  //pk Result Gain MXB Btn BgColor
    MXRUIViewGradientStyle_B4EC51_429321,  //pk Home Begin PK Btn BgColor
    MXRUIViewGradientStyle_FAD961_F76B1C,  //pk Home Personal Challenge Btn BgColor
};

@interface UIView (MXRGradientBackground)

@property (nonatomic, strong, readonly) CAGradientLayer *gradientLayer;

/**
 *  Create a linear gradient
 *
 *  @param colors    NSArray of UIColor instances
 *  @param direction Direction of the gradient
 */
- (void)mxr_setGradientWithColors:(NSArray *)colors
                        direction:(MXRUIViewLinearGradientDirection)direction;


/**
 set linear gradient with style

 @param style custom style
 */
- (void)mxr_setGradientBackGoundStyle:(MXRUIViewGradientStyle)style;
- (void)mxr_setGradientBackGoundStyle:(MXRUIViewGradientStyle)style direction:(MXRUIViewLinearGradientDirection)direction;

@end
