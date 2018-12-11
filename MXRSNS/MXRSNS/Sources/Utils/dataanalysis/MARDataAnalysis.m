//
//  MARDataAnalysis.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/18.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARDataAnalysis.h"

#define AliAppKey                   @"24744913"
#define AliSecretKey                @"64fa37cff242b036680aac055696797c"
#define AliDataAnalysisAppKey       AliAppKey
#define AliDataAnalysisSecretKey    AliSecretKey

@implementation MARDataAnalysis

+ (void)initDataAnalysis
{
    // 获取MAN服务
    ALBBMANAnalytics *man = [ALBBMANAnalytics getInstance];
    [man turnOffCrashHandler];
#ifdef DEBUG
    // 打开调试日志，线上版本建议关闭
//    [man turnOnDebug];
#endif
    // 初始化MAN
    [man initWithAppKey:AliDataAnalysisAppKey secretKey:AliDataAnalysisSecretKey];
    // appVersion默认从Info.list的CFBundleShortVersionString字段获取，如果没有指定，可在此调用setAppversion设定
    // 如果上述两个地方都没有设定，appVersion为"-"
//    [man setAppVersion:@"0.0.1"];
    // 设置渠道（用以标记该app的分发渠道名称），如果不关心可以不设置即不调用该接口，渠道设置将影响控制台【渠道分析】栏目的报表展现。
    if (APPCURRENTTYPE == MXRAppTypeBookCity) {
        [man setChannel:@"1"];
    }
    else if (APPCURRENTTYPE == MXRAppTypeSnapLearn)
    {
        [man setChannel:@"3"];
    }
}

+ (void)userRegister:(NSString *)pUsernick
{
    [[ALBBMANAnalytics getInstance] userRegister:@"userNick"];
}

+ (void)updateUserAccount:(NSString *)pNick userid:(NSString *)pUserId
{
    [[ALBBMANAnalytics getInstance] updateUserAccount:pNick userid:pUserId];
}

+ (void)pageAppear:(UIViewController *)pViewController
{
    [[ALBBMANPageHitHelper getInstance] pageAppear:pViewController];
}

+ (void)pageDisAppear:(UIViewController *)pViewController
{
    [[ALBBMANPageHitHelper getInstance] pageDisAppear:pViewController];
}

+ (void)updatePageProperties:(UIViewController *)pViewController properties:(NSDictionary *)pProperties
{
    [[ALBBMANPageHitHelper getInstance] updatePageProperties:pViewController properties:pProperties];
}

+ (void)setSourcePageName:(NSString *)sourcePageName destinationPagename:(NSString *)destinationPageName
{
    ALBBMANPageHitBuilder *pageHitBuilder = [[ALBBMANPageHitBuilder alloc] init];
    // 设置页面refer
    [pageHitBuilder setReferPage:sourcePageName];
    // 设置页面名称
    [pageHitBuilder setPageName:destinationPageName];
    // 设置页面停留时间
//    [pageHitBuilder setDurationOnPage:100];
    // 设置页面事件扩展参数
//    [pageHitBuilder setProperty:@"pagePropertyKey1" value:@"pagePropertyValue1"];
//    [pageHitBuilder setProperty:@"pagePropertyKey2" value:@"pagePropertyValue2"];
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    // 组装日志并发送
    [tracker send:[pageHitBuilder build]];
}

+ (void)setSourcePageName:(NSString *)sourcePageName destinationPagename:(NSString *)destinationPageName durationOnPage:(long long)durationTimeOnPage
{
    ALBBMANPageHitBuilder *pageHitBuilder = [[ALBBMANPageHitBuilder alloc] init];
    // 设置页面refer
    [pageHitBuilder setReferPage:sourcePageName];
    // 设置页面名称
    [pageHitBuilder setPageName:destinationPageName];
    // 设置页面停留时间
        [pageHitBuilder setDurationOnPage:durationTimeOnPage];
    // 设置页面事件扩展参数
    //    [pageHitBuilder setProperty:@"pagePropertyKey1" value:@"pagePropertyValue1"];
    //    [pageHitBuilder setProperty:@"pagePropertyKey2" value:@"pagePropertyValue2"];
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    // 组装日志并发送
    [tracker send:[pageHitBuilder build]];
}

+ (void)setEventLabel:(NSString *)pEventId
{
    ALBBMANCustomHitBuilder *customBuilder = [[ALBBMANCustomHitBuilder alloc] init];
    // 设置自定义事件标签
    [customBuilder setEventLabel:pEventId];
    // 设置自定义事件页面名称
//    [customBuilder setEventPage:@"test_Page"];
    // 设置自定义事件持续时间
//    [customBuilder setDurationOnEvent:12345];
    // 设置自定义事件扩展参数
//    [customBuilder setProperty:@"ckey0" value:@"value0"];
//    [customBuilder setProperty:@"ckey1" value:@"value1"];
//    [customBuilder setProperty:@"ckey2" value:@"value2"];
    ALBBMANTracker *traker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    // 组装日志并发送
    NSDictionary *dic = [customBuilder build];
    [traker send:dic];
}

+ (void)setEventPage:(NSString *)pPageName EventLabel:(NSString *)pEventId
{
    ALBBMANCustomHitBuilder *customBuilder = [[ALBBMANCustomHitBuilder alloc] init];
    // 设置自定义事件标签
    [customBuilder setEventLabel:pEventId];
    // 设置自定义事件页面名称
    [customBuilder setEventPage:pPageName];
    // 设置自定义事件持续时间
    //    [customBuilder setDurationOnEvent:12345];
    // 设置自定义事件扩展参数
    //    [customBuilder setProperty:@"ckey0" value:@"value0"];
    //    [customBuilder setProperty:@"ckey1" value:@"value1"];
    //    [customBuilder setProperty:@"ckey2" value:@"value2"];
    ALBBMANTracker *traker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    // 组装日志并发送
    NSDictionary *dic = [customBuilder build];
    [traker send:dic];
}

@end
