//
//  MXRPKChallengeResponseModel.h
//  huashida_home
//
//  Created by MountainX on 2018/10/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRPKRadarModel : NSObject <MXRModelDelegate, NSCopying, NSCoding>

@property (nonatomic, assign) NSInteger correctRate;//正确率
@property (nonatomic, assign) NSInteger tagId;//标签id
@property (copy, nonatomic) NSString *tagName;//标签名称

@end

@interface MXRPKChallengeResponseModel : NSObject <MXRModelDelegate, NSCopying, NSCoding>

@property (nonatomic, assign) NSInteger beatPerCent;//击败人数百分比
@property (nonatomic, assign) NSInteger bestRecord;//最佳纪录
@property (nonatomic, assign) NSInteger lastWeekRanking;//上周排名
@property (copy, nonatomic) NSArray <MXRPKRadarModel *> *qaChallengeUserAnswerStats;//问答个人挑战赛首页知识能力图谱数据
@property (nonatomic, assign) NSInteger reliveCardNum;//复活卡数量
@property (nonatomic, assign) NSInteger removeWrongCardNum;//除错卡数量
@property (nonatomic, assign) NSInteger totalNum;//每日可挑战次数
@property (nonatomic, assign) NSInteger usedNum;//已挑战次数
@property (nonatomic, assign) NSInteger userId;//用户id
@property (nonatomic, assign) BOOL vipFlag;//是否为VIP V5.18.0 MT.X

@end
