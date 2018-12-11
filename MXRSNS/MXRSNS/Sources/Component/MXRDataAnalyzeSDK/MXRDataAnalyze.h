//
//  MXRDataAnalyze.h
//  huashida_home
//
//  Created by weiqing.tang on 2017/2/6.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRDataAction.h"
#import "MXRCollectionDataController.h"
@interface MXRDataAnalyze : NSObject

/**
 存储用户行为信息
 */
+(BOOL)saveUesrAction:(MXRDataAction *)action;

/**
 根据sessionID从数据库里面查找对应的下载数据改变下载状态state
 
 bookGuid  图书的bookGuid
 */
+(void)modifyDownloadStatusBecomeSuccessWithBookGuid:(NSString *)bookGuid;

/**
  上传 系统信息和所有未上传的信息

 @param accountType 登录方式
 @param account 用户账户
 @param phoneNo 用户电话号码
 @param userId 用户ID
 */
+(void)uploadAllUnuploadCollectDataAccountType:(MXRDataAccountType)accountType account:(NSString* )account phone:(NSString *)phoneNo userId:(NSString*)userId;
/**
 请求上传采集数据方式
 */
+(void)requestUploadCollectDataWayWithCallBack:(void(^)(CollectWay collectWay,BOOL isSuccess))callBack;

/**
 获取地域信息
 */
+(void)AccessToTheRegionalWithCallBack:(void(^)(NSDictionary *ipDict))callBack;
@end
