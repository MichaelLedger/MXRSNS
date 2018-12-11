//
//  MXRBaseServiceNetworkManager.h
//  huashida_home
//
//  Created by 周建顺 on 15/8/6.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRNetworkResponse.h"

@interface MXRBaseServiceNetworkManager : NSObject

+(instancetype)defaultInstance;

/*
 *  请求分享奖励的金币
 */
-(void)requestGitCoinNumWithCallback:(defaultCallback)callback;

/*
 *  获取加锁书，试用的时间
 */
-(void)requestReadTimeWithCallback:(defaultCallback)callback;





#pragma mark 获取是否显示隐藏类容
- (void)requestIsShowHiddenThingsOrNotWithCallback:(defaultCallback)callback;

-(void)requestCheckBooksStatusWithBooks:(NSArray*)books success:(successCallback)success failure:(failureCallback)failure;


#pragma mark - 更新deviceUUID
-(void)updateDeviceUUID:(NSString*)deviceUUID deviceID:(NSString*)deviceID deviceDesc:(NSString*)deviceDesc Success:(successCallback)success failure:(failureCallback)failure;
@end
