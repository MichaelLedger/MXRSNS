//
//  MXRPKRankListModel.h
//  huashida_home
//
//  Created by MinJing_Lin on 2018/10/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MXRPKUserRankModel,MXRPKBestUserRankModel;
@interface MXRPKRankListModel : NSObject

/// 当前用户连续答题数
@property (nonatomic, assign) NSInteger continuousCorrectNum;
/// 当前用户id
@property (nonatomic, copy) NSString *userId;
/// 当前用户logo
@property (nonatomic, copy) NSString *userLogo;
/// 当前用户排名
@property (nonatomic, assign) NSInteger userRanking;
/// 问答个人挑战赛排名列表对象数组
@property (nonatomic, strong) NSArray<MXRPKUserRankModel *> *qaChallengeRankingInfoList;
/// 问答个人挑战赛最高纪录列表对象数组
@property (nonatomic, strong) NSArray<MXRPKBestUserRankModel *> *qaChallengeBestRankingVos;
/// 最好用户连续答题数
@property (nonatomic, assign) NSInteger bestContinuousCorrectNum;
/// 最好用户Id
@property (nonatomic, copy) NSString *bestUserId;
/// 记录保持天数
@property (nonatomic, assign) NSInteger keepDays;
/// 当前用户logo
@property (nonatomic, copy) NSString *bestUserLogo;
/// 最好用户昵称
@property (nonatomic, assign) NSString *bestUserName;

@end

@interface MXRPKUserRankModel : NSObject
/// 连续答题数
@property (nonatomic, assign) NSInteger continuousCorrectNum;
/// 用户id
@property (nonatomic, copy) NSString *userId;
/// 用户logo
@property (nonatomic, copy) NSString *userLogo;
/// 用户昵称
@property (nonatomic, copy) NSString *userName;

@end

@interface MXRPKBestUserRankModel : NSObject
/// 用户id
@property (nonatomic,  copy) NSString *userId;
/// 用户logo
@property (nonatomic, copy) NSString *userLogo;
@end
