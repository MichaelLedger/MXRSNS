//
//  MXRMacro.h
//  huashida_home
//
//  Created by Martin.liu on 2017/11/14.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRMacro_h
#define MXRMacro_h

#define MXRARCLASSROOMDISPLAY // 是否显示AR课堂功能，注释则隐藏该功能

#import "MXRAdpterManager.h"
#import <UIKit/UIKit.h>
//#import "UIImage+Extend.h"
//#import "UserDefaultKey.h"

// MAREXT
//#import <NSString+MAREX.h>

#ifndef AppVersion
    #define AppVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#endif

#define APP_MEIHUISHU_URL @"www.ecnupress.com.cn"   //判定美慧树跳转过来的URL

#define CURRENT_USERICON_URL [UserInformation modelInformation].userImage  //当前用户头像地址
/**
 app类型枚举
 - MXRAppTypeBookCity: 4D书城
 - MXRAppTypeSnapLearn: SnapLearn
 */
#define APPCURRENTTYPE [MXRAdpterManager currentAppType]  // 参考枚举 MXRAppType

#define MXRAppID [MXRAdpterManager currentAppID] // Appid

#define MXR_APP_REGION [MXRAdpterManager currentRegion] // app 区域

// 对MXR的h5页面的url后面增加必要的参数
#define WrapperH5Url(__url) [MXRAdpterManager smartGetWebPath:__url]

// 内部打开的链接后面增加必要的参数
#define InnerWrapperH5Url(__url) [MXRAdpterManager innerWrapperH5Path:__url]

// 网址链接进行URL编码
#define MXRURLEncode(__urlStr) [MXRAdpterManager smartURLEncode:__urlStr]

// 七牛服务器，获取指定大小的图片
#define MXRSmartGetResizePicPath(__url, __w, __h) [MXRAdpterManager smartGetResizePicPath:__url w:__w h:__h];

// 国际化
#define MXRLocalizedString(key, comment) \
    [MXRAdpterManager localizedStringForKey:key]


/////////////////////////////////////////////////////////////////////////////////////////////
// Font
#define MXRFONTSIZE(aFontSize)  [MXRAdpterManager adapterFontSize:aFontSize]
#define MXRFONT(fontSize)       [MXRAdpterManager fontWithSize:fontSize isBold:NO]
#define MXRBOLDFONT(fontSize)   [MXRAdpterManager fontWithSize:fontSize isBold:YES]

#define MXRBOLDFONT_30      MXRBOLDFONT(30.f)
#define MXRBOLDFONT_20      MXRBOLDFONT(20.f)
#define MXRBOLDFONT_18      MXRBOLDFONT(18.f)

#define MXRFONT_20          MXRFONT(20.f)
#define MXRFONT_18          MXRFONT(18.f)
#define MXRFONT_16          MXRFONT(16.f)
#define MXRFONT_15          MXRFONT(15.f)
#define MXRFONT_14          MXRFONT(14.f)
#define MXRFONT_13          MXRFONT(13.f)
#define MXRFONT_12          MXRFONT(12.f)
#define MXRFONT_10          MXRFONT(10.f)
#define MXRFONT_9           MXRFONT(9.f)

// 补充：

// Font
/////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////
// Color
#ifndef RGBHEX
#define RGB(r, g, b)        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:a]
#define RGBHEX(hex)         [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
#define RGBHEXA(hex,a)      [UIColor colorWithRed:((float)(((hex) & 0xFF0000) >> 16))/255.0 green:((float)(((hex) & 0xFF00)>>8))/255.0 blue: ((float)((hex) & 0xFF))/255.0 alpha:(a)]
#endif

// 主色
// 选中的标题／话题／标签背景／按钮／星级／题数／缺省页文字／点赞状态
#define MXRCOLOR_MAIN       RGBHEX(0x09A9D4)

#define MXRCOLOR_09A9D4     RGBHEX(0x09A9D4)      // 主色 v5.12.0
#define MXRCOLOR_29AAFE     RGBHEX(0x29AAFE)
#define MXRCOLOR_80F0EA     RGBHEX(0x80F0EA)
#define MXRCOLOR_F16702     RGBHEX(0xF16702)    //vip 会员色

#define MXRCOLOR_MAINA(alpha)       RGBHEXA(0x09A9D4, alpha)


// 辅助色
#define MXRCOLOR_F66691     RGBHEX(0xF66691)
#define MXRCOLOR_959DEF     RGBHEX(0x959DEF)
#define MXRCOLOR_38CCB6     RGBHEX(0x38CCB6)
#define MXRCOLOR_E58C7E     RGBHEX(0xE58C7E)
#define MXRCOLOR_FF76B9     RGBHEX(0xFF76B9)
#define MXRCOLOR_DDB4FE     RGBHEX(0xDDB4FE)
#define MXRCOLOR_93D75C     RGBHEX(0x93D75C)
#define MXRCOLOR_FAD22F     RGBHEX(0xFAD22F)
#define MXRCOLOR_FF7A4D     RGBHEX(0xFF7A4D)
#define MXRCOLOR_FF405F     RGBHEX(0xFF405F)

// 灰色
#define MXRCOLOR_FFFFFF     RGBHEX(0xFFFFFF)
#define MXRCOLOR_FFFFFF_A(alpha)     RGBHEXA(0xFFFFFF,alpha)
#define MXRCOLOR_F3F4F6     RGBHEX(0xF3F4F6)
#define MXRCOLOR_CCCCCC     RGBHEX(0xCCCCCC)
#define MXRCOLOR_333333     RGBHEX(0x333333)
#define MXRCOLOR_000000     RGBHEX(0x000000)
#define MXRCOLOR_000000_A(alpha)     RGBHEXA(0x000000,alpha)
#define MXRCOLOR_E7E7E7     RGBHEX(0xE7E7E7)
#define MXRCOLOR_D8D8D8     RGBHEX(0xD8D8D8)
// 文字色
#define MXRCOLOR_9B9B9B     RGBHEX(0x9B9B9B)
#define MXRCOLOR_E5E5E5     RGBHEX(0xE5E5E5)
#define MXRCOLOR_E5E5E5_A(alpha)     RGBHEXA(0xE5E5E5,alpha)
#define MXRCOLOR_999999     RGBHEX(0x999999)
#define MXRCOLOR_666666     RGBHEX(0x666666)
#define MXRCOLOR_333333     RGBHEX(0x333333)
#define MXRCOLOR_333333A(alpha)       RGBHEXA(0x333333, alpha)
#define MXRCOLOR_2FB8E2     RGBHEX(0x09A9D4)   // 按钮。文字MXRCOLOR_MAIN，图标都使用这个颜色 0x2FB8E2  -> 09A9D4
#define MXRCOLOR_2FB8E2_A(alpha)     RGBHEXA(0x09A9D4, alpha)
#define MXRCOLOR_4A4A4A     RGBHEX(0x4A4A4A)
// 其他颜色
#define MXRCOLOR_7ED321    RGBHEX(0x7ED321) // 书架最新下载
#define MXRCOLOR_F05351    RGBHEX(0xF05351) // 充值角标背景色
#define MXRCOLOR_FF001F    RGBHEX(0xFF001F) // 答题列表正确率红色
#define MXRCOLOR_4A90E2    RGBHEX(0x4A90E2) // 答题列表正确率蓝色
#define MXRCOLOR_6AC500    RGBHEX(0x6AC500) // 答题列表我的正确率青色
#define MXRCOLOR_DDDDDD    RGBHEX(0xDDDDDD) // 错题解析未选择边框颜色

// 补充：
#define MXRCOLOR_BBBBBB     RGBHEX(0xBBBBBB)        // 图书详情中的segment的tint
#define MXRCOLOR_FF3B30     RGBHEX(0xFF3B30)        // 动态评论置顶颜色
// VIP
#define MXRCOLOR_E35905     RGBHEX(0xE35905)        // VIP用到

// 领券中心按钮背景色
#define MXRCOLOR_FF8411     RGBHEX(0xFF8411)

// 搜索
#define MXRCOLOR_E73804     RGBHEX(0xE73804) // 红色
#define MXRCOLOR_ACACB5     RGBHEX(0xACACB5) // 灰色
#define MXRCOLOR_F2F2F2     RGBHEX(0xF2F2F2) // 分割线背景色

// Color
/////////////////////////////////////////////////////////////////////////////////////////////

// 导航栏相关
#define MXRNAVIBARTINTCOLOR [UIColor whiteColor]
#define MXRNAVITITLCOLOR    [UIColor whiteColor]
#define MXRNAVITITLEFONT    MXRFONT(17.f)
#define MXRNAVIBARITEMFONT  MXRFONT(16.f)


/////////////////////////////////////////////////////////////////////////////////////////////
// image
#define MXRFILENAME(fileName)               [MXRAdpterManager fileNameWithOriginalName:fileName]    // 返回当前的app类型返回对应的文件名称，没有进行对其文件存在验证。
#define MXRIMAGE(imageName)                 [MXRAdpterManager imageWithName:imageName]              // 返回当前app对应的图片，如果不存在则返回默认的。
#define MXRGRADIENTIMAGEWITHSTYLE(style)    [MXRAdpterManager gradientImageWithStyle:style]         // 返回渐变图片 1x1。style 参考 MXRUIViewGradientStyle
#define MXRGRADIENTIMAGEWITHSTYLEANDDIRECTION(_style, _direction)    [MXRAdpterManager gradientImageWithStyle:_style direction:_direction]         // 返回渐变图片 1x1。style 参考 MXRUIViewGradientStyle

#ifdef MXRSNAPLEARN
#define MXRAPPNAVIBARIMAGE MXRGRADIENTIMAGE3
#else
#define MXRAPPNAVIBARIMAGE [UIImage imageWithColor:MXRCOLOR_MAIN]   // 导航栏顶部图片
#endif

#define MXRGRADIENTIMAGE1                   MXRGRADIENTIMAGEWITHSTYLE(MXRUIViewGradientStyleLightGreen)
#define MXRGRADIENTIMAGE2                   MXRGRADIENTIMAGEWITHSTYLE(MXRUIViewGradientStylePink)
#define MXRGRADIENTIMAGE3                   MXRGRADIENTIMAGEWITHSTYLE(MXRUIViewGradientStyleLightGreen2)
#define MXRGRADIENTIMAGE4                   MXRGRADIENTIMAGEWITHSTYLE(MXRUIViewGradientStyleDarkGreen)

#define MXRGRADIENTIMAGEWITHSTYLEMAIN(style)    [MXRAdpterManager mainGradientImageWithStyle:style]
#define MXRGRADIENTIMAGEMAIN                   MXRGRADIENTIMAGEWITHSTYLEMAIN(MXRUIViewGradientStyleDarkGreenMain)

#define MXR_BUTTON_MAIN_IMAGE  [UIImage imageWithColor:MXRCOLOR_2FB8E2]
#define MXR_BUTTON_MAIN_IMAGE_HIGHKIGHTED  [UIImage imageWithColor:MXRCOLOR_2FB8E2_A(0.6)]

/**占位图**/
#define MXR_USER_ICON_PLACEHOLDER_IMAGE [MXRAdpterManager getUserIconPlaceholder]  //返回用户头像占位图
#define MXR_BOOK_ICON_PLACEHOLDER_IMAGE [MXRAdpterManager getBookIconPlaceholder]  //返回图书封面占位图
#define MXR_BANNER_ICON_PLACEHOLDER_IMAGE [MXRAdpterManager getBannerIconPlaceholder]  //返回banner占位图
// image
/////////////////////////////////////////////////////////////////////////////////////////////

#ifndef IS_iPhoneX_Device
#define IS_iPhone5_Device() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_iPhone6_Device() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_iPhone6P_Device() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_iPhoneX_Device() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#define MXRiPhoneX_TopMargin (IS_iPhoneX_Device() && UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? 30 : 0)

#define MXRiPhoneX_BottomMargin (IS_iPhoneX_Device() && UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? 34 : 0)
#define MXRiPhoneX_LeftMargin (IS_iPhoneX_Device() && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? 34 : 0)

// 关于iPhone11 x的适配
#define  MXRAdjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)

#ifndef weakify
    #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
    #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
    #endif
#else
    #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
    #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
    #endif
#endif

#ifndef strongify
    #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __strong __typeof__(object) strong##_##object = weak##_##object;
    #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
    #endif
#else
    #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __strong __typeof__(object) strong##_##object = weak##_##object;
    #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
    #endif
#endif


#import "MXRGlobalUtil.h"
#define ISSpecialRenZhiBookWithBookGuid(_bookGuid) [MXRGLOBALUTIL checkSpecailRenZhiBookWithBookGuid:_bookGuid]

#define MXRNEWERGUIDEASCSORT    // 新人引导正序排序，如果注销则倒序
#define MXRCITYLOADTIPARRAY   @[@"双指拖拽移动模型",          \
                                @"双指拖拽可以移动模型哦！",         \
                                @"双指放大可以放大模型哦！",         \
                                @"右下角重置按钮可以重置模型哦！",    \
                                @"更多图书请到书城-全部图书中寻找哦！",\
                                @"长按图书可以删除图书哦！",         \
                                @"长按图书后拖拽可以重新排序图书哦！", \
                                @"连续签到可以获得更多梦想币哦！",    \
                                @"可以在设置-时长提示修改提示时长哦！",\
                                @"可以在书架右上角更新图书一键更新图书哦！"];

/// Convert transform with simple coordinate. ref https://blog.csdn.net/u010679895/article/details/46648425
/// centerX 和 centerY是视图的字面意思， x和y是针对view上的坐标的点， 参照（x，y)这个点进行旋转
static inline CGAffineTransform  MXRCGAffineTransformRotateAroundPoint(float centerX, float centerY ,float x ,float y ,float angle)
{
    x = x - centerX; //计算(x,y)从(0,0)为原点的坐标系变换到(CenterX ，CenterY)为原点的坐标系下的坐标
    y = y - centerY; //(0，0)坐标系的右横轴、下竖轴是正轴,(CenterX,CenterY)坐标系的正轴也一样
    
    CGAffineTransform  trans = CGAffineTransformMakeTranslation(x, y);
    trans = CGAffineTransformRotate(trans,angle);
    trans = CGAffineTransformTranslate(trans,-x, -y);
    return trans;
}


#endif /* MXRMacro_h */
