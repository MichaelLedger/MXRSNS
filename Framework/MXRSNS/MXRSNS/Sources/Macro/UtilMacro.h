//
//  UtilMacro.h
//  huashida_home
//
//  Created by 周建顺 on 15/6/3.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#ifndef huashida_home_UtilMacro_h
#define huashida_home_UtilMacro_h
//#import "MXRConstant.h"
#import "MXRClickUtil.h"

#define IOS7_1_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.1) ? (YES):(NO)
#define IOS7_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? (YES):(NO)
#define IOS8_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? (YES):(NO)
#define IOS6_OR   ([[[UIDevice currentDevice] systemVersion] floatValue] <6.0)?(YES):(NO)
#define IOS9_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >=9.0)?(YES):(NO)
#define IOS10_OR_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >=10.0)?(YES):(NO)
#define IOS10_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >10.0)?(YES):(NO)
#define IOS11_OR_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >=11.0)?(YES):(NO)


#define ForceTouchCapabilityAvailable ([[[UIApplication sharedApplication] windows] objectAtIndex:0].traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)

#define iPhone6Plus (SCREEN_WIDTH_DEVICE_ABSOLUTE == 414)
#define iPhone6 (SCREEN_WIDTH_DEVICE_ABSOLUTE == 375)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : 0)

// iphone4的尺寸，iPhone4 这个宏在ipad上不对
#define iphone4Size CGRectEqualToRect([UIScreen mainScreen].bounds, CGRectMake(0, 0, 320, 480))
#define iphone4LandSize CGRectEqualToRect([UIScreen mainScreen].bounds, CGRectMake(0, 0, 480, 320))

#ifndef IS_iPhoneX_Device
#define IS_iPhone5_Device() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_iPhone6_Device() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_iPhone6P_Device() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_iPhoneX_Device() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#define kAppStatusBarHeight     ([UIApplication sharedApplication].statusBarHidden ? 0 : ([[UIApplication sharedApplication] statusBarFrame].size.height == 0 ? 20:[[UIApplication sharedApplication] statusBarFrame].size.height))
#define kAppNavigationBarHeight (self.navigationController.navigationBarHidden ? 0 : 44)
#define kAppTopViewHeight       (kAppStatusBarHeight + kAppNavigationBarHeight)     // 包括状态栏和导航栏的高度



//JSON字典数据类型自动转换
#define autoString(arg)  [MXRConstant  changeObjectTypeToString:arg]
#define autoInteger(arg) [MXRConstant  changeObjectTypeToInteger:arg]
#define autoNumber(arg)  [MXRConstant changeObjectTypeToNumber:arg]

#define autoStringWithDefaultValue(arg,__defaultValue)  [MXRConstant  changeObjectTypeToString:arg defaultValue:__defaultValue]
#define autoIntegerWithDefaultValue(arg,__defaultValue) [MXRConstant  changeObjectTypeToInteger:arg defaultValue:__defaultValue]
#define autoNumberWithDefaultValue(arg,__defaultValue)  [MXRConstant changeObjectTypeToNumber:arg defaultValue:__defaultValue]
#define autolonglongWithDefaultValue(arg,__defaultValue)  [MXRConstant changeObjectTypeTolonglong:arg defaultValue:__defaultValue]



//判断服务器返回的string是否为nil 或者<null>
#define ISNULL(arg) if(arg == nil || [arg isEqual:[NSNull null]]){\
return YES;\
}else{\
return NO;\
}\


//获取版本
#define MXR_BUILD_VERSION                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define MXR_SOFT_VERSION                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define DEVICE_VERSION                          "IOS"

#define kActiveBookDefaultReadTime               30 // 默认的试用时间30s
#define PublisherID @"publishID"
#define DownloadBookList @"downloadBookList"
#define PublishName @"publishName"
#define PublishIcon @"publishIcon"
#define ActivationCodeString @"activationCode"
#define DownloadBookList @"downloadBookList"
#define HELPOVER @"HELPOVER"
#endif

//梦想币转换成梦想钻
#define MXB_TO_MXZ(arg) (arg/100.0f)
//梦想钻转换成梦想币
#define MXZ_TO_MXB(arg) (arg*100)



//登录用户的ID
#define MAIN_USERID [UserInformation modelInformation].userID
/**
 *    搜索界面本地数据
 **/
// *  搜索历史数组
#define SAVE_HISTORY_ARRAY @"arrayHistory"

// * 本地存储图书CID
#define Cache_BookCid @"CID"

//是否显示绑定
#define KSHOWBINDPHONE @"KSHOWBINDPHONE"

//先转换成小写，在改成https
#define REPLACE_HTTP_TO_HTTPS(arg) [MXRConstant changeHttpToHttps:arg]

#define GET_UMENGCLICK_DICT(arg) [MXRConstant getUmengClickDictWithValue:arg]
//拍照和录制视频的水印大小
#define WATERMARKER_WIDTH 60

#define USER_ACCOUNT [UserInformation modelInformation].userPhone ? [UserInformation modelInformation].userPhone : [UserInformation modelInformation].userEmail //用户的注册账号   邮箱或者电话号码

#define CurrentUserLocalAge @"CurrentUserLocalAge"//本地保存的用户年龄
#define CurrentUserNetworkAge @"CurrentUserNetworkAge"//服务器存储的用户年龄
#ifdef MXRSNAPLEARN
#define MXRMaxSelectedAge 19//可选择的最大年龄+1
#else
#define MXRMaxSelectedAge 16//可选择的最大年龄+1
#endif
#define MXRMinSelectedAge (APPCURRENTTYPE == MXRAppTypeSnapLearn ? 2 : 0)//可选择的最小年龄-1

#define ShowNetworkFailAlertKey @"ShowNetworkFailAlert"
#define WhetherShowNetworkFailAlert [[NSUserDefaults standardUserDefaults] boolForKey:ShowNetworkFailAlertKey]//网络请求失败是否弹窗显示（默认为NO；正式服不会弹窗）

#define WhetherFirstOpenAppInToday @"WhetherFirstOpenAppInToday"   //是否为当天第一次启动
#define HideMXZExchangeEntrance @"HideMXZExchangeEntrance" //隐藏梦想钻兑换入口 V5.9.3
#define UserNeedUploadedMXBCountEarnedByRest @"UserNeedUploadedMXBCountEarnedByRest" // 用户待上传的通过休息获取的梦想币个数 V5.9.3
#define UserBindingQQGroupInfo @"UserBindingQQGroupInfo"  //一键绑定QQ群信息 V5.11.0
#define UserMainEntranceInfo @"UserMainEntranceInfo"      //首页banner下方四个主要入口 V5.12.0 
