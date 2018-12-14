//
//  DimensMacro.h
//  huashida_home
//
//  Created by 周建顺 on 15/6/3.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#ifndef huashida_home_DimensMacro_h
#define huashida_home_DimensMacro_h


// 提示没有数据的VC中，图片距离64高度导航栏的距离
#define MXR_NO_DATE_VIEW_TOP_TO_64NAVIBAR (iphone4Size?82.f:(iPhone6Plus?142.f:112.f))

//////////////////////////////////////////////////////////////////////////////////////////////////
//状态栏高度
//#define STATUS_BAR_HEIGHT 20
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height == 0 ? 20:[[UIApplication sharedApplication] statusBarFrame].size.height
//系统状态栏准确高度
//#define STATUS_BAR_HEIGHT_EXACT [[UIApplication sharedApplication] statusBarFrame].size.height

#define TOP_BAR_CONTENT_HEIGHT 44

#define TOP_BAR_HEIGHT [BUUtil mxrNaviBarHeight] // 显示statebar时的高度

#define TOP_BAR_HEIGHT_HIDDEN_STATE_BAR  64 // 隐藏statebar时的高度

#define IPHONEX_SAFEAREA_INSETS_PORTRAIT UIEdgeInsetsMake(44, 0, 34, 0)//iPhone X竖屏时的safeAreaInsets
#define IPHONEX_SAFEAREA_INSETS_LANSCAPE UIEdgeInsetsMake(0, 44, 21, 44)//iPhone X横屏时的safeAreaInsets

//TabBar高度
#define TAB_BAR_HEIGHT 49
//屏幕 rect
#define SCREEN_RECT ([UIScreen mainScreen].bounds)

//获取屏幕 宽度、高度
#define SCREEN_WIDTH_DEVICE ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT_DEVICE ([UIScreen mainScreen].bounds.size.height)

// iphoneX
/// Status bar
#define MXRStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
/// navigation bar
#define MXRNavBarHeight self.navigationController.navigationBar.frame.size.height
///  Status bar & navigation bar height
#define MXRStatusAndNavHeight (MXRStatusBarHeight + MXRNavBarHeight)


#define SCREEN_WIDTH_320    (MIN(SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE) == 320)

#define SCREEN_WIDTH_SCALE SCREEN_WIDTH_DEVICE_ABSOLUTE/320.0f
#define SCREEN_HEIGHT_SCALE SCREEN_HEIGHT_DEVICE_ABSOLUTE/568.0f
#define IPHONE6_SCREEN_WIDTH_SCALE SCREEN_WIDTH_DEVICE/375.0f
#define IPHONE6_SCREEN_HEIGHT_SCALE SCREEN_HEIGHT_DEVICE/667.0f

#define SCREEN_WIDTH_DEVICE_ABSOLUTE (([UIScreen mainScreen].bounds.size.width)<([UIScreen mainScreen].bounds.size.height)?([UIScreen mainScreen].bounds.size.width):([UIScreen mainScreen].bounds.size.height))
#define SCREEN_HEIGHT_DEVICE_ABSOLUTE (([UIScreen mainScreen].bounds.size.width)>([UIScreen mainScreen].bounds.size.height)?([UIScreen mainScreen].bounds.size.width):([UIScreen mainScreen].bounds.size.height))

//屏幕分辨率
#define SCREEN_RESOLUTION (SCREEN_WIDTH * SCREEN_HEIGHT * ([UIScreen mainScreen].scale))


// 画一像素的线需要用到
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

#define SINGLE_LINE_HEIGHT (1.f/[UIScreen mainScreen].scale) // 一像素的线

#define AUTO_VALUE(_value_) (_value_ * [[UIScreen mainScreen] scale])



#endif
