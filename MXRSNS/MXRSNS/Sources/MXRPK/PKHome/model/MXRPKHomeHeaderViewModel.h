//
//  MXRPKHomeHeaderViewModel.h
//  huashida_home
//
//  Created by 周建顺 on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRPKHomeRankingInfoResponseModel.h"
#import "MXRPKMedalInfoModel.h"
#import "MXRPKChallengeResponseModel.h"

@interface MXRPKHomeHeaderViewModel : NSObject

//-(instancetype)initWithModel:(MXRPKHomeRankingInfoResponseModel*)model;
@property (nonatomic, strong, readonly) MXRPKHomeRankingInfoResponseModel *model;

-(void)updateDataWithModel:(MXRPKHomeRankingInfoResponseModel*)model;

@property (nonatomic, copy) NSString *nickName; // 昵称
@property (nonatomic, copy) NSString *userIcon; // 用户头像
@property (nonatomic) NSInteger medalsCount; // 获得的勋章数量
@property (nonatomic, copy) NSString *records; // 战绩

@property (nonatomic, strong) MXRPKMedalInfoModel *medalInfoModel;//勋章列表
@property (nonatomic, strong) MXRPKChallengeResponseModel *challengeInfoModel;//个人挑战赛用户信息


@end
