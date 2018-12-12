//
//  MXRScreenShotHelper.h
//  4dBookCitySim
//
//  Created by MountainX on 2017/10/13.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRScreenShotHelper : NSObject

/**
 获取截屏图片

 @param view 截屏视图
 @return 截屏
 */
+ (UIImage *)screenShotWithView:(UIView *)view;

/**
 获取滚动视图的长截屏

 @param scrollView 滚动视图
 @return 截屏
 */
+ (UIImage *)screenShotWithScrollView:(UIScrollView *)scrollView;

/**
 根据链接生成带AppIcon的二维码

 @param url 链接字符串
 @return 二维码图片
 */
+ (UIImage *)generatorlogoImageQRCodeWithUrl:(NSString *)url;

/**
 拼凑截屏和二维码以及文本（通过imageCompressForWidth先将shotImage缩放到屏幕等宽）

 @param shotImage 截屏
 @param QRCodeImage 二维码图片
 @param text 文本
 @return 图片
 */
+ (UIImage *)jointShotImage:(UIImage *)shotImage QRCodeImage:(UIImage *)QRCodeImage Text:(NSString *)text;


/**
 获取文字高度

 @param str 字符串
 @param font 字体
 @param width 宽度
 @param space 行间距
 @return 高度
 */
+ (CGFloat)getHeightOfString:(NSString *)str font:(UIFont *)font width:(CGFloat)width lineSpace:(CGFloat)space;

@end
