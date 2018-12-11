//
//  BasicNetwork.h
//  huashida_home
//
//  Created by yanbin on 15/4/24.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicNetwork : NSObject
/*
 *      从服务端获取游客的唯一标识符
 */
- (void)getUniqueIdForTouristWithCallBack:(void(^)(BOOL isServerOk,NSString * uniqueId))callBack;
/*
 *      将本地的唯一标识符和userid进行绑定
 */
- (void)associationUserId:(NSString *)userId withUniqueId:(NSString *)uniqueId withCallBack:(void(^)(BOOL isServerOK))callBack;

/**
 *  第一次进入我的界面赠送100梦想币
 */
//- (void) requestFirstToPersonNewWithDeviceID:(void(^)(BOOL , id))callBack;


@end
