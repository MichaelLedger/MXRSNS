//
//  MXRGlobalUtil.m
//  huashida_home
//
//  Created by Martin.liu on 2017/12/11.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRGlobalUtil.h"
//#import <MARUserDefault.h>
#import "MXRUserSettingsManager.h"
//#import <UIDevice+MAREX.h>
#import "MXRBaseServiceNetworkManager.h"
//#import "MXRUserInfoNetwrokManager.h"
#import "MXRBaseDBModel.h"
#import "UserDefaultKey.h"
#import <objc/runtime.h>

// logout 用的
//#import "MXRBookSNSModelProxy.h"        // 梦想圈缓存
//#import "MXRPurchaseManager.h"          // 购买记录
//#import "ActiveCodeDatabase.h"          // 激活码相关
//#import "IsLockBook.h"                  //
//#import "MXRReadRecordDBManager.h"      // 最近阅读缓存
//#import "BookShelfManger.h"             //
//#import "MXRZonePurchaseDataProxy.h"    // 购买专区记录
//#import "MXRPersonNewController.h"

#define MXRDefaultReviewResultWhenRequestFail YES      // 服务器请求失败，默认返回的结果  YES  |  NO

static NSString *MXRHasBeenOpened                   =   @"MARHasBeenOpened";
static NSString *MXRHasBeenOpenedForCurrentVersion  =   @"";

@implementation MXRGlobalUtil

+ (instancetype)sharedInstance
{
    SINGLE_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    return _dateFormatter;
}

- (void)onFirstStartForCurrentVersion:(void (^)(BOOL))block
{
    MXRHasBeenOpenedForCurrentVersion = [NSString stringWithFormat:@"%@%@", MXRHasBeenOpened, AppVersion];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasBeenOpenedForCurrentVersion = [defaults boolForKey:MXRHasBeenOpenedForCurrentVersion];
    if (hasBeenOpenedForCurrentVersion != true) {
        [defaults setBool:YES forKey:MXRHasBeenOpenedForCurrentVersion];
        [defaults synchronize];
    }
    if (block){
        block(!hasBeenOpenedForCurrentVersion);
    }
    
}

+ (void)onFirstStartForCurrentVersion:(void (^)(BOOL))block
{
    [[MXRGlobalUtil sharedInstance] onFirstStartForCurrentVersion:block];
}

- (BOOL)checkSpecailRenZhiBookWithBookGuid:(NSString *)bookGuid
{
    NSArray *bookGuidArray = @[@"FA25155654FA4EEA9C10659270D20E1F",
                               @"EC58AA3A1ABB412DA05A80519EC092C6",
                               @"D2E85DE63FBD48239A099E9FBEBDCACE",         // AR识字卡 一年级上册
                               @"0B4273A263984ED8B3728DF9093E6D13"          // AR识字卡 一年级下册
                               ];
    if ([bookGuidArray containsObject:bookGuid]) {
        return YES;
    }
    return NO;
}

- (void)actionsOnDidFinishLaunch
{
    [self defaultSettingAction];
    if ([[UserInformation modelInformation] getIsLogin])
//        [MXRUserInfoNetwrokManager receiveUserCouponSuccess:nil failure:nil];
    
#ifndef CHANNEL_APPSTORE
    [MXRGlobalUtil sharedInstance].isDisplayCheckBookTool = YES;
#else
    [MXRGlobalUtil sharedInstance].isDisplayCheckBookTool = NO;
#endif
    
}

- (void)defaultSettingAction
{
    [self defaultSettingCameraOnOnce];
    [self defaultSettingSmothStyleOnce];
}

// 默认摄像头设置开启状态
- (void)defaultSettingCameraOnOnce
{
    [self invokeOnceInAppWithKey:UserDefaultOnceKey_SettingCameraOn block:^{
        [[MXRUserSettingsManager defaultManager] setIsARCameraOn:YES];
    }];
}

// 手机内存低于1G的设备默认开启流畅模式
- (void)defaultSettingSmothStyleOnce
{
//    [self invokeOnceInAppWithKey:UserDefaultOnceKey_SettingSmoothStyleOn block:^{
//        if ([UIDevice currentDevice].mar_memoryTotal < 1000000000) {  // 不完全是2的30次方
//            [[MXRUserSettingsManager defaultManager] setSmoothStyle:YES];
//        }
//    }];
}

- (void)invokeOnceInAppWithKey:(NSString *)key block:(void (^)(void))block
{
//    if ([key isKindOfClass:[NSString class]] && key.length > 0 && ![MARUserDefault getBoolBy:key]) {
//        block();
//        [MARUserDefault setBool:YES key:key];
//    }
}

+ (void)invokeOnceInAppWithKey:(NSString *)key block:(void (^)(void))block
{
    [[self.class sharedInstance] invokeOnceInAppWithKey:key block:block];
}

//+ (BOOL)isInReviewed
//{
//    BOOL isReviewSecurityOn = [MARUserDefault getBoolBy:USERKEY_ReviewSecurityOnKey];  // 是否在审核状态
//    NSString *lastReviewReqeustSuccessVersion = [MARUserDefault getStringBy:USERKEY_VersionReviewRequesetSuccessKey];
//    NSString *currentVersion = AppVersion;
//    if ([currentVersion isEqual:lastReviewReqeustSuccessVersion]) {
//        return isReviewSecurityOn;
//    }
//    else
//    {
//        [MXRGlobalUtil requestCheckIsInReview];
//        return MXRDefaultReviewResultWhenRequestFail; // 默认审核状态。
//    }
//}

//+ (void)requestCheckIsInReview
//{
//    NSString *currentVersion = AppVersion;
//    [[MXRBaseServiceNetworkManager defaultInstance] requestIsShowHiddenThingsOrNotWithCallback:^(MXRServerStatus status, id result, id error) {
//        if ([result isKindOfClass:[NSDictionary class]]) {
//            [MARUserDefault setString:currentVersion key:USERKEY_VersionReviewRequesetSuccessKey];
//            NSString *isShowWord = autoString([(NSDictionary *)result objectForKey:@"channel"]);
//            [UserInformation modelInformation].reviewedFlags = isShowWord;
//            BOOL isReview = [isShowWord isEqual:@"hide"];
//            [MARUserDefault setBool:isReview key:USERKEY_ReviewSecurityOnKey];
//        }
//    }];
//}
//
//- (void)checkIsInReview:(void (^)(BOOL))reviewCallback
//{
//    BOOL isReviewSecurityOn = [MARUserDefault getBoolBy:USERKEY_ReviewSecurityOnKey];  // 是否在审核状态
//    NSString *lastReviewReqeustSuccessVersion = [MARUserDefault getStringBy:USERKEY_VersionReviewRequesetSuccessKey];
//    NSString *currentVersion = AppVersion;
//    if ([currentVersion isEqual:lastReviewReqeustSuccessVersion]) {
//        if (reviewCallback) {
//            reviewCallback(isReviewSecurityOn);
//        }
//    }
//    else
//    {
//        [[MXRBaseServiceNetworkManager defaultInstance] requestIsShowHiddenThingsOrNotWithCallback:^(MXRServerStatus status, id result, id error) {
//            if ([result isKindOfClass:[NSDictionary class]]) {
//                [MARUserDefault setString:currentVersion key:USERKEY_VersionReviewRequesetSuccessKey];
//                NSString *isShowWord = autoString([(NSDictionary *)result objectForKey:@"channel"]);
//                [UserInformation modelInformation].reviewedFlags = isShowWord;
//                BOOL isReview = [isShowWord isEqual:@"hide"];
//                [MARUserDefault setBool:isReview key:USERKEY_ReviewSecurityOnKey];
//                if (reviewCallback) {
//                    reviewCallback(isReview);
//                }
//                //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NETWORKSTATUSHASCHANGE" object:nil];     // 有啥用
//            }
//            else
//            {
//                if (reviewCallback) {
//                    reviewCallback(MXRDefaultReviewResultWhenRequestFail);    // 默认YES
//                }
//            }
//        }];
//    }
//}

+ (void)checkIsInReview:(void (^)(BOOL))reviewCallback
{
    [[self sharedInstance] checkIsInReview:reviewCallback];
}

+ (void)actionsOnNetworkDidChangeReachable
{
    [self requestCheckIsInReview];      // 确保安全机制结果正确
}

- (void)actionsOnNetworkDidChangeReachable
{
    [self checkIsInReview:nil]; // 确保安全机制结果正确
}

- (NSMutableArray *)getAllViewControllers
{
    
    NSMutableArray *vcs = [NSMutableArray array];
    int i, numClasses = 0;
    int newNumClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    while (numClasses < newNumClasses) {
        numClasses = newNumClasses;
        classes = (Class *)realloc(classes, sizeof(Class) * numClasses);
        newNumClasses = objc_getClassList(classes, numClasses);
    }
    
    for (i=0; i< numClasses; ++i)
    {
        Class clazz = classes[i];
        const char *imagePathC = class_getImageName(clazz);
        if (imagePathC) {
            NSString *imagePath = [NSString stringWithCString:imagePathC encoding:NSUTF8StringEncoding];
            if ([imagePath containsString:@"4dBookCity.app/4dBookCity"]) {
                NSString *className =[NSString stringWithCString:class_getName(clazz) encoding:NSUTF8StringEncoding];
                Class superClazz = class_getSuperclass(clazz);
                Class vcClass = UIViewController.class;
                while (superClazz) {
                    if ([vcClass isEqual:superClazz]) {
                        [vcs addObject:className];
                        break;
                    }
                    superClazz = class_getSuperclass(superClazz);
                }
            }
        }
    }
    
    free(classes);
    
    return vcs;
}

+ (void)logout
{
    [[UserInformation modelInformation] logout];        // 清空本地user数据
//    [[MXRBookSNSModelProxy getInstance] deleteCacheData];   // 清空梦想圈缓存
//    [[MXRPurchaseManager defaultManager] clearLocalPuchaseHistory]; // 清空购买记录
//    [ActiveCodeDatabase deleteAllActiveBook];               // 清空激活码本地缓存
//    [IsLockBook deleteMHSAuthorization];                    // 删除美慧树本地授权
//    [[MXRReadRecordDBManager sharedManager] deleteAllReadRecord];
//    [[NSNotificationCenter defaultCenter] postNotificationName:MXRBookShelfChangeBookPostionAndReadStateNotification object:nil ];
//    [MXRZonePurchaseDataProxy sharedInstance].dataArray = nil;  // 清空购买记录
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UserLogout object:nil];
//    [[MXRPersonNewController getInstance] guestLogin];// 进行游客登录
}


@end
