//
//  MXREgretInterfaceModel.h
//  huashida_home
//
//  Created by MountainX on 2018/10/24.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXREgretInterfaceModel : NSObject

/**
 复活卡数量
 */
@property (nonatomic, assign) NSInteger rebootNums;

/**
 除错卡数量
 */
@property (nonatomic, assign) NSInteger skillNums;

/**
 挑战机会次数
 */
@property (nonatomic, assign) NSInteger lives;

/**
 梦想钻个数
 */
@property (nonatomic, assign) NSInteger mxzNums;

/**
 个人最佳记录
 */
@property (nonatomic, assign) NSInteger maxRights;

- (NSDictionary *)interfaceDict;

@end
