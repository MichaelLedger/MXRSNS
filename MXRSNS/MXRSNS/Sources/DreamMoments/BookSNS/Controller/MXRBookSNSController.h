//
//  MXRBookSNSController.h
//  huashida_home
//  梦想圈动态相关服务
//  Created by gxd on 16/9/29.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRNetworkResponse.h"

@class MXRSNSBlackListModel;

@interface MXRBookSNSController : NSObject

/**
 单例
 */
+(instancetype)getInstance;

/**
 获取梦想圈动态首页所有动态（包含全部精选动态）

 @param handleUserID 用户ID
 */
-(void)getBookSNSAllMomentWithHandleUserId:(NSString *)handleUserID Success:(successCallback )success failure:(failureCallback )fail;

/**
 获取梦想圈更早的动态列表（不含精选动态）

 @param handleUserID 用户ID
 */
-(void)getPreviousBookSNSMomentWithandHandleUserId:(NSString *)handleUserID Success:(successCallback )success failure:(failureCallback )fail;

/**
 删除梦想圈动态

 @param momentId 动态ID
 @param handleUserID 用户ID
 */
-(void)deleteMomentWithMomentId:(NSString *)momentId andHandleUserId:(NSString *)handleUserID success:(successCallback )success failure:(failureCallback )fail;

/**
 对动态不感兴趣

 @param t_userId 取消关注的userid
 @param handleUserID 操作用户ID
 */
-(void)cancleFocusWithUserId:(NSString *)t_userId andHandleUserId:(NSString *)handleUserID success:(successCallback )success failure:(failureCallback )fail;

/**
 对动态进行点赞

 @param momentId 动态ID
 @param handleUserID 操作用户ID
 */
-(void)userLikeMomentWithMomentId:(NSString *)momentId andHandleUserId:(NSString *)handleUserID success:(successCallback )success failure:(failureCallback )fail;

/**
 对动态取消点赞

 @param momentId 动态ID
 @param handleUserID 操作用户ID
 */
-(void)userCancleLikeMomentWithMomentId:(NSString *)momentId andHandleUserId:(NSString *)handleUserID success:(successCallback )success failure:(failureCallback )fail;

/**
 举报动态

 @param reportStr 举报类型
 @param handleUserID 操作用户ID
 @param momentId 动态ID
 */
-(void)userReportMomentWithReportDetail:(NSString *)reportStr andHandleUserId:(NSString *)handleUserID andMomentId:(NSString *)momentId success:(successCallback )success failure:(failureCallback )fail;

/**
 获取运营调整过的动态排序或话题下的动态排序

 @param topicId 话题ID(两者选一即可)
 @param topicName 话题名称(两者选一即可)
 */
-(void)getServerRecommendDynamicWithTopicID:(NSString *)topicId topicName:(NSString *)topicName success:(successCallback )success failure:(failureCallback )fail;

/**
 获取梦想圈热门话题列表
 */
-(void)getHotTopicListWithSuccess:(successCallback )success failure:(failureCallback )fail;

/**
 获取我的动态相关服务

 @param handleUserID 用户ID
 */
-(void)getMyBookSNSAllMomentWithHandleUserId:(NSString *)handleUserID Success:(successCallback )success failure:(failureCallback )fail;

/**
 获取个人最新动态的数量

 @param handleUserID 用户ID
 @param time 个人动态最新时间戳
 */
-(void)getMyNewBookSNSMomentCountWithandHandleUserId:(NSString *)handleUserID andTime:(NSNumber *)time Success:(successCallback )success failure:(failureCallback )fail;

/**
 获取个人更早的动态数量

 @param handleUserID 用户ID
 @param time 个人动态最早时间戳
 */
-(void)getMyOldBookSNSMomentWithandHandleUserId:(NSString *)handleUserID andTime:(NSNumber *)time Success:(successCallback )success failure:(failureCallback )fail;

/**
 获取梦想圈顶部banner图片
 */
-(void)getBookSNSBannerIconUrlStringSuccess:(successCallback )success failure:(failureCallback )fail;

/**
 动态黑名单（记录本地删除的所有动态）

 @param block 黑名单
 */
- (void)cachedSNSBlackListModelArray:(void(^)(NSArray <MXRSNSBlackListModel *> *blackList))block;

/**
 删除动态（添加到本地数据库）

 @param model 黑名单（保存用户ID&动态ID）
 */
- (void)addSNSBlackListModel:(MXRSNSBlackListModel *)model;

@end
