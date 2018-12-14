//
//  MXRConstant.h
//  HuaShiDa
//
//  Created by zhenyu.wang on 14-7-18.
//  Copyright (c) 2014年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SandboxFile.h"
//#import "MarkInfo.h"
//#import "UtilMacro.h"
//#import "BUUtil.h"
#import "Enums.h"

#define OpenTopicID @"OpenTopicID"

// 图书的cell
#define MXRBOOKITEM_DETAILVIEW_HEIGHT 41    // 介绍文字的区域高度
#define MXRBOOKITEM_READSTATEVIEW_HEIGHT 6 // 阅读进度高度
#define MXRBOOKITEM_IMAGE_SCALE_W 89
#define MXRBOOKITEM_IMAGE_SCALE_H 125

// 书架
#define SHELFHEIGHT    ((132.5/568)*(SCREEN_HEIGHT_DEVICE<568?568:SCREEN_HEIGHT_DEVICE))
#define SHELFWIDTH     ((100.5/320)*(SCREEN_WIDTH_DEVICE))

// 6天对应的秒数 518400.0f
#define macroNotificationTime 518400.0f
//判断屏幕尺寸
#define FOUR_INCH ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define WLAN_NAME       @"http://192.168.120.1/usb/"

#define MXR_PREVIEW_INFO                        @"book_preview_resource_download_info_is_ok"   //filelist解析完成后的通知


#define THIS_IS_DIANDUSHU                       //这是4D点读书
#define THIS_IS_HUIBEN                          //4D点读书里有绘本功能
#if defined(DEBUG)
#define BUILD_FOR_TESTING                       1 // 定义此次构建是否是用于测试还是正式版
#endif




#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define Caches_Directory_Book(guid) [NSString stringWithFormat:@"%@/%@",Caches_Directory,guid]
#define Caches_Directory [SandboxFile GetDirectoryForCaches:@"Books"]
#define Caches_Directory_COMMON [SandboxFile GetDirectoryForCaches:@"BookCommon"] // 公共资源已废弃
#define Caches_Directory_ResStore [SandboxFile GetDirectoryForCaches:@"ResStore"] // 资源商店文件目录
#define Caches_Directory_ResStore_Preview  [NSString stringWithFormat:@"%@/%@",[SandboxFile GetTmpPath],@"ResStore_Preview"]  // 资源商店文件预览目录
#define Caches_Directory_Diy [SandboxFile GetDirectoryForCaches:@"DiyBooks"]
#define Caches_Directory_BookSNS [SandboxFile GetDirectoryForCaches:@"BookSNS"]
#define Caches_Directory_Temp [SandboxFile GetDirectoryForCaches:@"BooksTemp"]
#define Publication_CacheData_Directory [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/CacheData"]

#define Caches_Directory_PresentingBooks [SandboxFile GetDirectoryForCaches:@"PresentingBooks"]  //首次安装赠送图书目录
#define PresentingBooks @"presentingBooks.archiver"

#define kGetBookResult              @"//GetBookResult"
#define kGetBookPreviewResult       @"//GetBookPreviewResult"
#define kDataRow                    @"//DATAROW"
#define kXmlSize                    @"XmlSize"
#define kBookGUID                   @"//BookGUID"
#define kSeries                     @"//BookSeries"
#define kBarCode                    @"//BarCode"
#define kBookName                   @"//BookName"
#define kPublisher                  @"//Publisher"
#define kPublishID                  @"//Press"
#define kBookIconURL                @"//BookCover"
#define kBookIconURL1               @"//bookIconURL"
#define kVersion                    @"//UPLOADTIME"
#define kTotalSize                  @"//TotalSize"
#define kModelUrl                   @"ModelURL"
#define kOthersURL                  @"//OthersURL"
#define kMarkersURL                 @"//MarkersURL"
#define kReadThroughURL             @"//ReadThrough"
#define kresURL                     @"//ActivityURL"
#define kBookType                   @"//BookType"
#define kCreateTime                 @"//BookType"

#define kAppDownloadPlace           @"299"


#ifdef BUILD_FOR_TESTING
#ifndef kServerVersion
#define kServerVersion @"99"
#endif

#else

#ifndef kServerVersion
#define kServerVersion @"1"
#endif
#endif


//声音的定义
#define KAudioFlipPage @"audio_pageflip.mp3" //翻页的声音
#define KAudioRecord @"luShiPin.mp3" //录制视频
#define KAudioLevelTip @"leveltip.mp3"



typedef enum {
    Read_Online,
    Read_Offline,
    PreRead,
}ReadMode;

@class BookInfoForShelf;
@interface MXRConstant : NSObject
//提示框
+ (void)showAlertNoNetwork;
+ (void)showAlertBadNetwork;
+ (void)showAlert:(NSString *)infStr andShowTime:(float)tStr;
+ (void)showAlert:(NSString *)infStr andShowTime:(float)tStr radius:(CGFloat)radius;
+ (void)showAlertOnWindow:(NSString *)infStr andShowTime:(float)tStr;
+ (void)showAlertOnWindow:(NSString *)infStr andShowTime:(float)tStr radius:(CGFloat)radius;
+ (void)showAlertOnForwordWindow:(NSString *)infStr andShowTime:(float)tStr;
+ (void)showAlert:(NSString *)infStr andShowTime:(float)tStr andShowWindow:(BOOL )isShow;
+ (void)showAlertOnVC:(UIViewController*)vc info:(NSString *)infStr andShowTime:(float)tStr;+(void)showSuccessAlertWithMsg:(NSString*)msg andShowTime:(CGFloat)showTime;
+ (void)dismissAlert;


//解析
+ (NSDictionary *)parseXML:(NSString *) str;

/*
 * 检测魔镜是否可用
 */
+ (BOOL) checkPlatformForMoJing;
+ (BOOL) checkPlatformForMoJingShowPrompt:(BOOL)show;


//统计数据
+ (void)downloadBookGUID:(NSString *)bookGUID;
+ (void)addUGCCountBookGUID:(NSString *)bookGUID andBookPage:(NSString *)page andUGCType:(NSString *)name;
+ (void)clickHotCountBookGUID:(NSString *)bookGUID andBookPage:(NSString *)page andIsOnline:(NSString *)name andBtnType:(CustomBtnType)btnType andIsXiaomengBtn:(BOOL )isXiaomengBtn;


//去除特殊字符
+ (NSString *)mxrReplaceStr:(NSString *)str;

+ (BookInfoForShelf *) getPreViewBookinfo:(NSString *)bookGUID;
+ (void) savePreViewBookinfo:(BookInfoForShelf *)bookinfotemp;
+ (void) removePreViewBookinfo:(NSString *)bookGuid;
+ (NSMutableArray *)allFilesAtPath:(NSString *)direString;//遍历目录下的所有文件
+(NSString *)changeObjectTypeToString:(id)value;
+(NSInteger)changeObjectTypeToInteger:(id)value;
+(NSNumber *)changeObjectTypeToNumber:(id)value;
+(NSString *)changeObjectTypeToString:(id)value defaultValue:(NSString *)defaultValue;
+(NSInteger)changeObjectTypeToInteger:(id)value defaultValue:(NSInteger)defaultValue;
+(NSNumber *)changeObjectTypeToNumber:(id)value defaultValue:(NSNumber *)defaultValue;
+(long long)changeObjectTypeTolonglong:(id)value defaultValue:(long long)defaultValue;


//当小数点为0的时候，直接显示整数
//当小数点不为0的时候，显示两位小数
+(NSString*)formatFloat:(float)value;
//先转换成小写，在改成https
+(NSString*)changeHttpToHttps:(NSString*)arg;

+(NSDictionary *)getUmengClickDictWithValue:(NSString *)clickValue;




@end

@interface MXRConstant(MXRStatusBarToast)
#pragma mark - statusBar toast 提示

+(void)showStatusBarMsg:(NSString*)msg;

+(void)showStatusBarErrorMsg:(NSString*)msg;
@end




@interface MXRConstant(PromotView)
/*
 提示空间不足
 */
+(void)showMemoryWarning;
@end
