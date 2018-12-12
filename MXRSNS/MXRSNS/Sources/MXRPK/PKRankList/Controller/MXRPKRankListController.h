//
//  MXRRKRankListController.h
//  huashida_home
//
//  Created by MinJing_Lin on 2018/10/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//  

#import <Foundation/Foundation.h>

@class MXRPKRankListModel;
@interface MXRPKRankListController : NSObject

/**
 个人挑战赛-用户排名
 
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)loadPKRankListsuccess:(void(^)(MXRPKRankListModel *rankModel))success
                      failure:(void(^)(id error))failure ;

@end
