//
//  MXRAdpterManager.h
//  huashida_home
//
//  Created by Martin.liu on 2017/11/14.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+MXRGradientBackground.h"
//#define MXRUSEFONTHOOKTOADAPTER           // 是否用挂钩进行对字体进行适配

/**
 app类型枚举

 - MXRAppTypeBookCity: 4D书城
 - MXRAppTypeSnapLearn: SnapLearn
 */
typedef NS_ENUM(NSInteger, MXRAppType) {
    MXRAppTypeBookCity,
    MXRAppTypeSnapLearn,
};

@interface MXRAdpterManager : NSObject

/**
 single
 */
+ (instancetype)shareManager;

/**
 根据宏返回当前的app类型，默认为英文版本

 @return MXRAppType枚举
 */
+ (MXRAppType)currentAppType;


/**
 获取当前的appID

 @return appID
 */
+ (NSString*)currentAppID;

/**
  App区域（0，国内版；1，国际版）.

 @return region
 */
+ (NSString*)currentRegion;

/**
 返回当前app类型（后期可能还会根据中英文环境）适配好的字体对象

 @param aFontSize 字体大小
 @param bold 是否是粗字体
 @return UIFont实例
 */
+ (UIFont *)fontWithSize:(CGFloat)aFontSize isBold:(BOOL)bold;

/**
 返回当前app类型（后期可能还会根据中英文环境）适配好的字体大小
 
 @param fontSize 字体大小
 @return 返回适配好的字体大小
 */
+ (CGFloat)adapterFontSize:(CGFloat)fontSize;

/**
 返回当前的app类型返回对应的文件名称，没有进行对其文件存在验证。
 英文加上后缀_en

 @param originalName 初始的文件名称（用于4D书城）
 @return 当前app的应该对应的文件名
 */
+ (NSString *)fileNameWithOriginalName:(NSString *)originalName;


/**
 返回当前app对应的图片，如果不存在则返回默认的。

 @param imageName 图片默认名称
 @return UIImage实例
 */
+ (UIImage *)imageWithName:(NSString *)imageName;

+ (UIImage *)gradientImageWithStyle:(MXRUIViewGradientStyle)style;
+ (UIImage *)gradientImageWithStyle:(MXRUIViewGradientStyle)style direction:(MXRUIViewLinearGradientDirection)direction;
+ (UIImage *)mainGradientImageWithStyle:(MXRUIViewGradientStyle)style; //按照屏幕宽度画出1：1的渐变图

/**
  MXR网址拼接必要参数
 */
+(NSString*)smartGetWebPath:(NSString *)url;

/**
 MXR内部打开的链接拼接必要参数

 @param originalUrl 原链接
 @return 拼接好的链接
 */
+(NSString *)innerWrapperH5Path:(NSString *)originalUrl;

/**
 网址链接进行URL编码

 @param urlStr 网址
 @return URL编码后的网址
 */
+ (NSURL *)smartURLEncode:(NSString *)urlStr;

/**
 七牛服务器，获取指定大小的图片
 
 @param url <#url description#>
 @param w <#w description#>
 @param h <#h description#>
 @return <#return value description#>
 */
+(NSString*)smartGetResizePicPath:(NSString *)url w:(NSUInteger)w h:(NSUInteger)h;

/**
 语言国际化
 
 @param key
 @return 对应语言的文本
 */
+(NSString*)localizedStringForKey:(NSString*)key;

/**
 获取用户头像头像占位图

 @return 头像占位图
 */
+(UIImage *)getUserIconPlaceholder;


/**
 获取图书封面占位图

 @return 图书封面占位图
 */
+(UIImage *)getBookIconPlaceholder;


/**
 获取banner封面占位图

 @return banner封面占位图
 */
+(UIImage *)getBannerIconPlaceholder;

/**
 获取用户头像url

 @return 用户头像url
 */
+(NSString *)getUserIconURLString;
@end

@interface NSObject (MXRSwizze)
+ (BOOL)mxr_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;
+ (BOOL)mxr_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;
@end

#if defined(MXRUSEFONTHOOKTOADAPTER)
@interface UIFont (MXRAdapter)
@end
#endif
