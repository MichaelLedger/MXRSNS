//
//  MARDataAnalysis.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/18.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlicloudMobileAnalitics/ALBBMAN.h>

@interface MARDataAnalysis : NSObject

+ (void)initDataAnalysis;

/**
 产生一条注册会员事件日志
 调用时机: 注册时调用
 @param pUsernick userNickName
 */
+ (void)userRegister:(NSString *)pUsernick;

// 1 登录/注册会员
/**
 登录会员
 功能: 获取登录会员，然后会给每条日志添加登录会员字段
 调用时机: 登录时调用
 @param pNick userNickName
 @param pUserId userUUID
 */
+ (void)updateUserAccount:(NSString *)pNick userid:(NSString *)pUserId;

// 页面埋点
/**
 页面进入
 记录页面进入时的一些状态信息，但不发送日志，和 pageDisappear 配合使用
 调用时机： viewDidAppear
 @param pViewController vc appear
 */
+ (void)pageAppear:(UIViewController *)pViewController;

/**
 页面离开
 页面离开发送页面事件日志，和 pageAppear 配合使用
 调用时机： viewDidDisAppear
 @param pViewController vc vc disapear
 */
+ (void)pageDisAppear:(UIViewController *)pViewController;

/**
 设置页面扩展参数
 调用时机：调用pageDisAppear之前

 @param pViewController vc
 @param pProperties pro
 */
+ (void)updatePageProperties:(UIViewController *)pViewController properties:(NSDictionary *)pProperties;

//  页面事件
/**
 页面事件，从一个源页面跳转到目标页面

 @param sourcePageName source VC PageName nullabel
 @param destinationPageName destination VC PageName
 */
+ (void)setSourcePageName:(NSString *)sourcePageName destinationPagename:(NSString *)destinationPageName;

/**
 页面事件，从一个源页面跳转到目标页面,并且在该页面停留的时间
 
 @param sourcePageName source VC PageName nullabel
 @param destinationPageName destination VC PageName
 @param durationTimeOnPage duration Time On Page
 */
+ (void)setSourcePageName:(NSString *)sourcePageName destinationPagename:(NSString *)destinationPageName durationOnPage:(long long)durationTimeOnPage;;

// 自定义事件

/**
 设置自定义事件的标签
 功能： 区分不同自定义事件的标签，同一种自定义事件的 pEventId 相同
 调用时机： 创建 ALBBMANCustomHitBuilder 后，必须调用 setEventLabel，否则调用 build 后返回为 nil
 
 备注： 对于自定义事件，必须设置标签，pEventId需要事先在wdm上申请
 @param pEventId 自定义事件标签，相当于自定义事件的业务 ID，不能为空
 */
+ (void)setEventLabel:(NSString *)pEventId;


/**

 设置该自定义事件发生在哪个页面和设置自定义事件标签
 功能： 设置该自定义事件发生在哪个页面
 
 入参： 自定义事件的页面名称，可以为空，这种情况日志中默认页面名称为 “UT”

 @param pPageName page name nullabel
 @param pEventId eventid
 */
+ (void)setEventPage:(NSString *)pPageName EventLabel:(NSString *)pEventId;

/**
 设置自定义事件停留时间
 功能： 设置自定义事件持续时间，跟 ALBBMANPageHitBuilder 中的页面停留时间类似

 入参： 自定义事件停留时间
 @param durationOnEvent duration
 */
//+ (void)setDurationOnEvent:(long long)durationOnEvent;

@end
