//
//  MXRGlobalUtil.h
//  huashida_home
//
//  Created by Martin.liu on 2017/12/11.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MXRGLOBALUTIL [MXRGlobalUtil sharedInstance]

@interface MXRGlobalUtil : NSObject

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) BOOL isDisplayCheckBookTool;  // 是否展示验证图书的工具
+ (instancetype)sharedInstance;

/**
 *  Executes a block on first start of someone version App.
 *  Remember to execute UI instuctions on main thread
 *
 *  @param block The block to execute, returns isFirstStartForCurrentVersion
 */
- (void)onFirstStartForCurrentVersion:(void (^)(BOOL isFirstStartForCurrentVersion))block;
+ (void)onFirstStartForCurrentVersion:(void (^)(BOOL isFirstStartForCurrentVersion))block;

- (BOOL)checkSpecailRenZhiBookWithBookGuid:(NSString *)bookGuid;

/**
 启动app的时候都会调用
 */
- (void)actionsOnDidFinishLaunch;


/**
 初始化一些设置
 */
- (void)defaultSettingAction;

/**
 根据key唯一标识，只在APP上只调用一次。
 @param key     保存在userDefault中
 @param block   调用的块
 */
- (void)invokeOnceInAppWithKey:(NSString *)key block:(void (^)(void))block;
+ (void)invokeOnceInAppWithKey:(NSString *)key block:(void (^)(void))block;

#pragma mark - 判断是非在审核中(登录小梦账号或者是游客登录;我的界面等界面兑换券、渠道码显示或者隐藏;)
/** 请求服务器  */
+ (void)requestCheckIsInReview;
/** 查看本地数据，如果该版本请求服务器成功，则返回结果；否则默认返回YES，并开始请求服务器。  */
+ (BOOL)isInReviewed;
/**
 查看本地数据，如果该版本请求服务器成功，则返回结果;
 否则异步请求服务器，返回结果。
 */
+ (void)checkIsInReview:(void (^)(BOOL isReview))reviewCallback;
- (void)checkIsInReview:(void (^)(BOOL isReview))reviewCallback;

+ (void)actionsOnNetworkDidChangeReachable;
/** 当网络状态变为可用时进行的一些列操作 */
- (void)actionsOnNetworkDidChangeReachable;            

+ (void)logout;     // 退出登录

@end
