//
//  UIViewController+Ex.h
//  huashida_home
//
//  Created by 周建顺 on 15/8/14.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRDataAction.h"
#import "MXRDataAnalyze.h"

@interface UIViewController(Ex)


//是否转为竖屏
- (void)toProtrait;

//是否转为横屏
- (void)toLand;

//是否转为竖屏
- (void)interfaceOrientationToProtrait;

//是否转为横屏
- (void)interfaceOrientationToLandRight;

@end

@interface UIViewController(ReadingTime)

@property (nonatomic,retain) NSDate *startReadTime; // 开始读书的时间，用于统计阅读时间
@property (nonatomic,retain) NSNumber *readDuration; // 阅读时间

/*
 * 开始记录
 */
-(void)startRecordReadDuration;

/*
 * 重置阅读开始时间
 */
-(void)continueRecordReadDuration;

/*
 * 保存阅读时间，重置阅读开始时间
 */
-(void)pauseRecordReadDuration;

/*
 * 将数据发送到服务端
 */
-(void)sendReadDurationToServerWith:(NSString *)bookGUID;

/*
 * 失去焦点的时候调用
 */
-(void)readDurationInResignActive;

/*
 * 获得焦点或者进入前台的时候调用
 */
-(void)readDurationInEnterForeground;

@end


/**
 *  滑动返回手势
 */
@interface UIViewController(EdgePopGestureRecognizer)

/**
 *  滑动返回可用，viewWillDisappear 中调用
 */
-(void)enableInteractivePopGestureRecognizer;

/**
 *  禁用滑动返回，viewDidAppear中调用
 */
-(void)disableInteractivePopGestureRecognizer;
@end

@interface UIViewController(MXRDataAnalyze)


/**
 创建一个阅读行为

 @param account 用户账户
 @param pageNumber 当前书的页码
 @param bookId 书的唯一标识
 @param readSessionId 阅读当前书的唯一标识
 */
- (void)createReadActionAccount:(NSString *)account
                     pageNumber:(NSString *)pageNumber
                         bookId:(NSString *)bookId
                  readSessionId:(NSString *)readSessionId ;

/**
 结束一个阅读行为

 @param status 主动退出 或者 被动退出
 */
- (void)endReadActionWithStatus:(MXRDataUserActionStatus) status;

/**
 创建一个 热点行为

 @param readSessionId 阅读当前书的唯一标识
 @param userAccount 用户账户
 @param hotId 热点Id
 */
- (void)createHotPointActionReadSessionId:(NSString *)readSessionId
                              userAccount:(NSString *)userAccount
                                    hotId:(NSString *)hotId;

/**
 结束一个热点行为

 @param status 主动退出 或者 被动退出
 */
- (void)endHotPointActionStatus:(MXRDataUserActionStatus)status;


/**
 统计 私信 通知点击行为

 @param account 账户
 @param moduleId 消息的Id
 @param moduleType 0
 @param actionType 	操作类型：0-点击，1-阅读，2-链接点击
 */
- (void)saveNotifictionActionWithAccount:(NSString *)account
                                moduleId:(NSInteger)moduleId
                              moduleType:(NSInteger)moduleType
                              actionType:(NSInteger)actionType;

/**
 统计 私信 通知里面的链接点击行为

 @param account 账户
 @param moduleId 消息的Id
 @param moduleType 0
 @param actionType 操作类型：0-点击，1-阅读，2-链接点击
 @param linkName 链接的名字
 @param linkType 链接的类型
 */
- (void)saveNotifiactionLinkActionWithAccount:(NSString *)account
                                     moduleId:(NSInteger)moduleId
                                   moduleType:(NSInteger)moduleType
                                   actionType:(NSInteger)actionType
                                     linkName:(NSString *)linkName
                                     linkType:(MXRNotificationLinkType)linkType;

@end

@interface UIViewController (Presentation)

- (void)showAtTop;

@end

@interface UINavigationController (Presentation)

- (void)showAtTop;

@end

@interface UIViewController (Current)

/**
 是否为当前正在展示的页面

 @return BOOL
 */
- (BOOL)isCurrentViewController;

/**
 当前正在展示的页面

 @return 当前正在展示的页面
 */
+(UIViewController*) currentViewController;

@end
