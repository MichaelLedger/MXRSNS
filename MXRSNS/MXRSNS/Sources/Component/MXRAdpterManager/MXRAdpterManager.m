//
//  MXRAdpterManager.m
//  huashida_home
//
//  Created by Martin.liu on 2017/11/14.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRAdpterManager.h"
#import <objc/runtime.h>
#import "UIView+MXRSnapshot.h"
#import "MXRDeviceUtil.h"
#import "GlobalFunction.h"
#import "CacheData.h"
//#import <MAREXMacro.h>
#import "NSString+Ex.h"
#import "UserDefaultKey.h"
#import "MXRAdpterManager.h"

#define kScreenWIDTH            ([UIScreen mainScreen].bounds.size.width)
#define kScreenHEIGHT           ([UIScreen mainScreen].bounds.size.height)
#define kScreenMAXLENGTH        (MAX(kScreenWIDTH, kScreenHEIGHT))
#define kScreenMINLENGTH        (MIN(kScreenWIDTH, kScreenHEIGHT))
#define kSCALE(value)           (value * (kScreenMINLENGTH/375.0f))

@interface MXRAdpterManager ()

@property(nonatomic, strong) NSMutableDictionary *gradientImageDic;

@end

@implementation MXRAdpterManager


+(instancetype)shareManager
{
    static MXRAdpterManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MXRAdpterManager alloc] init];
    });
    
    return manager;
}


- (NSMutableDictionary *)gradientImageDic
{
    if (!_gradientImageDic) {
        _gradientImageDic = [NSMutableDictionary dictionaryWithCapacity:1<<4];
    }
    return _gradientImageDic;
}

+(MXRAppType)currentAppType
{
    static  MXRAppType appType = MXRAppTypeSnapLearn;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if defined(MXRBOOKCITY)
        appType = MXRAppTypeBookCity;
#elif defined(MXRSNAPLEARN)
        appType = MXRAppTypeSnapLearn;
#endif
    });
    return appType;
}

+ (NSString*)currentAppID{
    NSString *appID;
#if defined(MXRBOOKCITY)
    appID = @"10000000000000000000000000000001";
#elif defined(MXRSNAPLEARN)
    appID = @"10000000000000000000000000000011";
#endif
    return appID;
}

+ (NSString*)currentRegion{
    NSString *region;
#if defined(MXRBOOKCITY)
    region = @"0";
#else
    region = @"1";
#endif
    return region;
}

+ (UIFont *)fontWithSize:(CGFloat)aFontSize isBold:(BOOL)bold
{
    CGFloat fontSize  = [self adapterFontSize:aFontSize];
    if (!bold) {
        return [UIFont systemFontOfSize:fontSize];
    }
    else
        return [UIFont boldSystemFontOfSize:fontSize];
}

+ (CGFloat)adapterFontSize:(CGFloat)fontSize
{
#ifndef MXRUSEFONTHOOKTOADAPTER     // 如果不是用挂钩适配就走下面的逻辑
    if ([self currentAppType] == MXRAppTypeSnapLearn) {//snaplearn字体强制缩小
        fontSize -= 2 * (fontSize / 10);
    }
    //    else if ([[MXRDeviceUtil currentLocaleLanguage] isEqualToString:@"en"]) {//英文字体缩小
    //        fontSize -= 2 * (fontSize / 10);
    //    }
#else
    if ([self currentAppType] == MXRAppTypeSnapLearn) {//snaplearn字体强制缩小
        fontSize -= 2 * (fontSize / 10);
    }
#endif
    fontSize = kSCALE(fontSize);
    return fontSize;
}

+ (NSString *)fileNameWithOriginalName:(NSString *)originalName
{
    NSString *tmpFileName = [[originalName copy] stringByDeletingPathExtension];
    if ([tmpFileName isKindOfClass:[NSString class]] && tmpFileName.length > 0) {
        if ([self currentAppType] == MXRAppTypeSnapLearn) {
            if ([tmpFileName hasSuffix:@"_cn"]) {
                tmpFileName = [tmpFileName substringToIndex:tmpFileName.length - 3];
                tmpFileName = [tmpFileName stringByAppendingString:@"_en"];
            }
            else if ([tmpFileName hasSuffix:@"_en"])
            {
                // 不错操作
            }
            else
            {
                tmpFileName = [tmpFileName stringByAppendingString:@"_en"];
            }
        }
    }
    return tmpFileName;
}

+ (UIImage *)imageWithName:(NSString *)imageName
{
    NSString *desImageName = [self fileNameWithOriginalName:imageName];
    UIImage *image = [UIImage imageNamed:desImageName];
    return image ? image : [UIImage imageNamed:imageName];
}

+ (UIImage *)gradientImageWithStyle:(MXRUIViewGradientStyle)style direction:(MXRUIViewLinearGradientDirection)direction
{
    NSString *imageKey = [NSString stringWithFormat:@"%ld", (long)style];
    UIImage *image = [[MXRAdpterManager shareManager].gradientImageDic objectForKey:imageKey];
    if (!image) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        [view mxr_setGradientBackGoundStyle:style direction:direction];
        image = [view mxr_snapshotImage];
        if (image) {
            [[MXRAdpterManager shareManager].gradientImageDic setObject:image forKey:imageKey];
        }
    }
    return image;
}

+ (UIImage *)mainGradientImageWithStyle:(MXRUIViewGradientStyle)style
{
    return [self mainGradientImageWithStyle:style direction:MXRUIViewLinearGradientDirectionHorizontal];
}

+ (UIImage *)mainGradientImageWithStyle:(MXRUIViewGradientStyle)style direction:(MXRUIViewLinearGradientDirection)direction
{
    NSString *imageKey = [NSString stringWithFormat:@"%ld", (long)style];
    UIImage *image = [[MXRAdpterManager shareManager].gradientImageDic objectForKey:imageKey];
    if (!image) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_WIDTH_DEVICE)];
        [view mxr_setGradientBackGoundStyle:style direction:direction];
        image = [view mxr_snapshotImage];
        if (image) {
            [[MXRAdpterManager shareManager].gradientImageDic setObject:image forKey:imageKey];
        }
    }
    return image;
}

+ (UIImage *)gradientImageWithStyle:(MXRUIViewGradientStyle)style
{
    return [self gradientImageWithStyle:style direction:MXRUIViewLinearGradientDirectionHorizontal];
}

/**
 MXR网址拼接必要参数
 */
+(NSString*)smartGetWebPath:(NSString *)url {
    MXRAppType apptype = [self currentAppType];
    NSString *culture;
    if (apptype == MXRAppTypeBookCity) {
        culture =@"zh-cn";
    }else{
        culture = @"en-us";
    }
    NSString *newUrl = [NSString stringWithFormat:@"v=%@&t=%@&appId=%@&culture=%@", getCurrentShortVerion(), @"ios", MXRAppID, culture ];
    if(([url rangeOfString:@"?"].location != NSNotFound)){
        
        newUrl = [NSString stringWithFormat:@"%@&%@", url, newUrl ];
        
        
    }else{
        newUrl = [NSString stringWithFormat:@"%@?%@",url, newUrl];
    }
    return newUrl;
}

+(NSString *)innerWrapperH5Path:(NSString *)originalUrl {
    // 强制类型转换
    originalUrl = autoString(originalUrl);
    
    // 补充前缀
    if (![originalUrl hasPrefix:@"http://"] && ![originalUrl hasPrefix:@"https://"]) {
        originalUrl = [NSString stringWithFormat:@"http://%@", originalUrl];
    }
    
    // 拼接必要参数
    NSString *jointedUrl = originalUrl;
    
    NSString *userID = [UserInformation modelInformation].userID;
    jointedUrl = [jointedUrl urlAppendCompnentWithKey:@"uid" value:userID];
    jointedUrl = [jointedUrl urlAppendCompnentWithKey:@"userId" value:userID];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    jointedUrl = [jointedUrl urlAppendCompnentWithKey:@"v" value:version];
    
    MXRAppType apptype = [MXRAdpterManager currentAppType];
    NSString *culture;
    if (apptype == MXRAppTypeBookCity) {
        culture =@"zh-cn";
    }else{
        culture = @"en-us";
    }
    jointedUrl = [jointedUrl urlAppendCompnentWithKey:@"culture" value:culture];
    
    NSString *appID = MXRAppID;
    jointedUrl = [jointedUrl urlAppendCompnentWithKey:@"appId" value:appID];
    
    NSString *platform = @"ios";
    jointedUrl = [jointedUrl urlAppendCompnentWithKey:@"t" value:platform];
    
    NSString *deviceId = [MXRDeviceUtil getCurrentUserIdAsscationDevice]?:@"";
    jointedUrl = [jointedUrl urlAppendCompnentWithKey:@"deviceId" value:deviceId];
    
    NSString *deviceUnique = [MXRDeviceUtil getDeviceUUID];
    jointedUrl = [jointedUrl urlAppendCompnentWithKey:@"deviceUnique" value:deviceUnique];
    
    if (![[UserInformation modelInformation] getIsLogin]) {
        NSString *noLogin = @"1";
        jointedUrl = [jointedUrl urlAppendCompnentWithKey:@"nologin" value:noLogin];
    }
    
    //V5.12.0 强制隐藏网页自带导航
    jointedUrl  = [jointedUrl urlAppendCompnentWithKey:@"nav" value:@"0"];
    
    //V5.13.0 新增VIP
    NSString *vip = [UserInformation modelInformation].vipFlag ? @"1" : @"0";
    jointedUrl = [jointedUrl urlAppendCompnentWithKey:@"vip" value:vip];
    
    return jointedUrl;
}

+ (NSURL *)smartURLEncode:(NSString *)urlStr {
    // URL编码
    NSURL *url;
    // Vue配置的history路由
    if ([urlStr containsString:@"/#/"]) {
        //不进行URL编码
        url = [NSURL URLWithString:urlStr];
    } else {
        // 进行URL编码才能正确解析
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        url = [NSURL URLWithString:urlStr];
    }
    return url;
}

/**
 七牛服务器，获取指定大小的图片

 @param url <#url description#>
 @param w <#w description#>
 @param h <#h description#>
 @return <#return value description#>
 */
+(NSString*)smartGetResizePicPath:(NSString *)url w:(NSUInteger)w h:(NSUInteger)h{

    CGFloat scale = [[UIScreen mainScreen] scale];
    
    NSString *newUrl = [NSString stringWithFormat:@"imageView2/1/w/%@/h/%@/interlace/1", @(w*scale), @(h*scale) ];
    if(([url rangeOfString:@"?"].location != NSNotFound)){
        
        newUrl = [NSString stringWithFormat:@"%@&%@", url, newUrl ];
    
    }else{
        newUrl = [NSString stringWithFormat:@"%@?%@",url, newUrl];
    }
    
    return newUrl;
}


/**
 语言国际化

 @param key <#key description#>
 @return <#return value description#>
 */
+(NSString*)localizedStringForKey:(NSString*)key{
    
    MXRAppType apptype = [self currentAppType];
    
    NSString *tableName = @"Localizable";
    switch (apptype) {
        case MXRAppTypeBookCity:
        {
            
        }
            break;
        case MXRAppTypeSnapLearn:
        {
            tableName = @"Localizable_en";
        }
            break;
        default:
            break;
    }
   
    return  NSLocalizedStringFromTable(key, tableName, nil);
}
#pragma mark -获取占位图
/**
 获取用户头像头像占位图
 
 @return 头像占位图
 */
+(UIImage *)getUserIconPlaceholder {
    return MXRIMAGE(@"icon_common_xiaomengheader");
}

/**
 获取图书封面占位图
 
 @return 图书封面占位图
 */
+(UIImage *)getBookIconPlaceholder {
    return MXRIMAGE(@"img_cell_book_shelf_cover");
}

/**
 获取banner封面占位图
 
 @return banner封面占位图
 */
+(UIImage *)getBannerIconPlaceholder {
    return MXRIMAGE(@"icon_banner_4dbookstore_cn");
}

/**
 获取用户头像url
 
 @return 用户头像url
 */
+(NSString *)getUserIconURLString {
    NSString *userIconURL = [CacheData readApplicationStr:CACHE_USERICON_KEY];
    if (!userIconURL) {
        userIconURL = [UserInformation modelInformation].userImage;
    }
    return userIconURL ? userIconURL :@"";
}
@end

@implementation NSObject (MXRSwizze)

+ (BOOL)mxr_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

+ (BOOL)mxr_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}




@end

#if defined(MXRUSEFONTHOOKTOADAPTER)
@implementation UIFont (MXRAdapter)
+ (void)load
{
    [self mxr_swizzleClassMethod:@selector(systemFontOfSize:) with:@selector(mxr_systemFontOfSize:)];
}

+ (UIFont *)mxr_systemFontOfSize:(CGFloat)fontSize
{
    if ([MXRAdpterManager currentAppType] == MXRAppTypeSnapLearn) {
        fontSize -= 2;
    }
    return [self mxr_systemFontOfSize:fontSize];
}
@end
#endif
