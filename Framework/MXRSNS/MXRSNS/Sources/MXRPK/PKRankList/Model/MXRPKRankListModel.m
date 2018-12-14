//
//  MXRPKRankListModel.m
//  huashida_home
//
//  Created by MinJing_Lin on 2018/10/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKRankListModel.h"

@implementation MXRPKRankListModel

+ (NSDictionary<NSString *,id> *)mxr_modelContainerPropertyGenericClass {
    
    return @{
             @"qaChallengeRankingInfoList": [MXRPKUserRankModel class],
             @"qaChallengeBestRankingVos":  [MXRPKBestUserRankModel class]
            };
}

@end


@implementation MXRPKUserRankModel

@end

@implementation MXRPKBestUserRankModel

@end
