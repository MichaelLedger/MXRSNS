//
//  MXRPKNetworkManager.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MXRModel.h"
#import "MXRNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "MXRPKRequestModel.h"
#import "MXRPKResponseModel.h"
#import "MXRPKHomeResponeModel.h"
#import "MXRPKMedalInfoModel.h"
#import "MXRPKHomeRankingInfoResponseModel.h"
#import "MXRPKUserInfoModel.h"
#import "MXRPKChallengeResponseModel.h"
#import "MXRPKPropShopResponseModel.h"

@interface MXRPKNetworkManager : NSObject

/**
 *  单例方法
 *
 *  @return 实例对象
 */
+ (instancetype)shareManager;

+ (void)getQAListWithId:(MXRGetQAListWithIdR *)param
                success:(void (^)(MXRPKQuestionLibModel *pkQuestionLibModel))success
                failure:(void (^)(id error))failure;

+ (void)submitPKAnswers:(MXRSubmitPKAnswersR *)param
                success:(void (^)(MXRPKSubmitResultModel *submitResult))success
                failure:(void (^)(id error))failure;

/**
 获取pk首页答题分类列表

 @param success success description
 @param failure failure description
 */
+(void)getPKHomeSuccess:(successCallback)success failure:(failureCallback)failure;


/**
 pk首页用户信息

 @param success <#success description#>
 @param failure <#failure description#>
 */
+(void)getPKHomeRankingInfoSuccess:(successCallback)success failure:(failureCallback)failure;



/**
 获取pk勋章列表服务

 @param success 返回pk勋章列表信息model
 @param failure 错误信息
 */
+(void)requestUserPKMedalListSuccess:(void(^)(MXRPKMedalInfoModel *pkMedalListInfo))success failure:(failureCallback)failure;


/**
 获取pk匹配信息

 @param success <#success description#>
 @param failure <#failure description#>
 */
+(void)getPKUserInfoWithSuccess:(void (^)(MXRPKUserInfoModel *pkUserInfoModel))success
                        failure:(failureCallback)failure;

/**
 个人挑战赛-用户首页信息（by weichao.song）

 @param success 成功
 @param failure 失败
 */
+ (void)requestPKChallengeInfoSuccess:(void(^)(MXRPKChallengeResponseModel *pkChallengeInfo))success failure:(failureCallback)failure;

/**
 个人挑战赛-用户排名
 
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)loadPKRankListsuccess:(void(^)(MXRNetworkResponse *response))success
                      failure:(void(^)(id error))failure;

/**
 个人挑战赛-分页获取道具列表（by dong.chen)

 @param pageNo 页码（非必传，默认为1）
 @param pageSize 每页记录数（非必传，默认为20）
 @param success 成功
 @param failure 失败
 */
+ (void)fetchPropShopListWithPageNo:(NSInteger)pageNo
                           pageSize:(NSInteger)pageSize
                            Success:(void(^)(MXRPKPropShopResponseModel *pkChallengeInfo))success
                            failure:(failureCallback)failure;


/**
 个人挑战赛-保存用户购买道具记录（by dong.chen）

 @param propId 道具ID
 @param coinNum 道具梦想钻个数
 @param success 成功
 @param failure 失败
 */
+ (void)purchasePropWithPropId:(NSInteger)propId
                       coinNum:(NSInteger)coinNum
                       success:(void(^)(MXRNetworkResponse *response))success
                       failure:(void(^)(id error))failure;

/**
 分享雷达图获取道具

 @param type 追加类型type 0-老数据包含type=1和type=2的数据，1-问答首页分享，2-道具页面分享 (5.19.0 by dong.chen)
 @param success 成功
 @param failure 失败
 */
+ (void)challengeShareWithType:(NSInteger)type Success:(void(^)(MXRNetworkResponse *response))success
                      failure:(void(^)(id error))failure;

@end
