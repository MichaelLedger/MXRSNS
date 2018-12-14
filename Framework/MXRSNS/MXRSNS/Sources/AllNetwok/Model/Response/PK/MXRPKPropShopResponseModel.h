//
//  MXRPKPropShopResponseModel.h
//  huashida_home
//
//  Created by MountainX on 2018/10/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 道具类型

 - MXRPropTypeExcludeError: 除错卡
 - MXRPropTypeResurgence: 复活卡
 */
typedef NS_ENUM(NSUInteger, MXRPropType){
    MXRPropTypeResurgence = 1,
    MXRPropTypeExcludeError,
};

@interface MXRPKPropShopModel : NSObject

@property (nonatomic, assign) NSInteger coinNum;//道具价格
@property (nonatomic, assign) NSInteger propId;//道具ID
@property (nonatomic, assign) NSInteger num;//道具数量
@property (nonatomic, assign) MXRPropType type;//道具类型

@end

@interface MXRPKPropShopResponseModel : NSObject

@property (copy, nonatomic) NSArray <MXRPKPropShopModel *> *list;

@end
