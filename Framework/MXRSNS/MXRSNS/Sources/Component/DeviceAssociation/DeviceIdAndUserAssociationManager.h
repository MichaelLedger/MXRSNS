//
//  DeviceIdAndUserAssociationManager.h
//  huashida_home
//
//  Created by yanbin on 15/4/24.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceIdAndUserAssociationManager : NSObject
+(id)sharedInstance;
- (void)addAssociationOfUser:(NSString *)userId withDeviceId:(NSString *)deviceId;
- (NSString *)userIdAssociatedWithDeviceId:(NSString *)deviceId andUserId:(NSString *)uId;

/**
 判断当前uID是否已经绑定设备iD
 */
//- (BOOL )userIdIsAssociatedWithDeviceId:(NSString *)uId;

- (NSString *)getCurrentUserIdAssicationDeviceId;
@end
