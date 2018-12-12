//
//  MXRUserBehaviour.h
//  huashida_home
//  本地数据库记录用户的行为数据
//  Created by MountainX on 2018/11/21.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRUserBehaviour : NSObject <MXRModelDelegate,NSCopying, NSCoding>

/**
 用户ID
 */
@property (copy, nonatomic) NSString *userID;

/**
 是否展示过VIP特权弹窗
 */
@property (nonatomic, assign) BOOL shownVIPPrivilegeAlert;

/**
 获取当前用户的行为数据

 @return MXRUserBehaviour数据模型
 */
+ (MXRUserBehaviour *)currentUserBehaviour;

/**
 根据用户ID获取该用户的行为数据

 @param userID 用户ID
 @return MXRUserBehaviour数据模型
 */
+ (MXRUserBehaviour *)fetchUserBehaviourWithUserID:(NSString *)userID;

@end
