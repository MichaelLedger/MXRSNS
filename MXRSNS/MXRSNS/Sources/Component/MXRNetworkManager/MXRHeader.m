//
//  MXRHeader.m
//  huashida_home
//
//  Created by weiqing.tang on 2017/9/8.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRHeader.h"
//#import "MXRConstant.h"
#import "UserInformation.h"
//#import "GlobalFunction.h"
//#import "MXRJsonUtil.h"
#import "MXRMacro.h"
#import "MXRDeviceUtil.h"
#import "MXRBase64.h"
#import "UtilMacro.h"
#import "MXRJsonUtil.h"

@implementation MXRHeader

//保留原来的
NSString  * const MXR_OS_TYPE_KEY      = @"OS-Type";
NSString  * const MXR_SOFT_VERSION_KEY = @"Soft-Version";

//增加新建的
NSString  * const MXR_OS_TYPE_NEW_KEY       = @"osType";//设备类型（1,ios;2,android）
NSString  * const MXR_SOFT_VERSION_NEW_KEY  = @"appVersion";
NSString  * const MXR_DEVICE_ID_KEY         = @"deviceId";//服务端创建的deviceid，依赖于本地创建的deviceid
NSString  * const MXR_USER_ID_KEY           = @"userId";
NSString  * const MXR_REGION                = @"region";//区分国内版本和国际版（0，国内版；1，国际版）
NSString  * const MXR_LOCAL_DEVICE_ID_KEY   = @"deviceUnique";//本地创建的deviceid
NSString  * const MXR_APP_ID_KEY          =  @"appId"; // 渠道

+(NSString*)createHeader{    
    NSString * deviceId = [MXRDeviceUtil getCurrentUserIdAsscationDevice]?:@"";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UserInformation modelInformation].userID,MXR_USER_ID_KEY,
                          deviceId,MXR_DEVICE_ID_KEY,
                          MXR_APP_REGION,MXR_REGION,
                          MXR_SOFT_VERSION,MXR_SOFT_VERSION_NEW_KEY,
                          @"1",MXR_OS_TYPE_NEW_KEY,
                          [MXRDeviceUtil getDeviceUUID],MXR_LOCAL_DEVICE_ID_KEY,
                          MXRAppID,MXR_APP_ID_KEY,
                          nil];
    NSString *value = [MXRBase64 encodeBase64WithString:[MXRJsonUtil dictionaryToJson:dict]];
    return value;
}

+(NSString*)createHeaderAndForceUserIdToZero {
    NSString * deviceId = [MXRDeviceUtil getCurrentUserIdAsscationDevice]?:@"";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"0",MXR_USER_ID_KEY,
                          deviceId,MXR_DEVICE_ID_KEY,
                          MXR_APP_REGION,MXR_REGION,
                          MXR_SOFT_VERSION,MXR_SOFT_VERSION_NEW_KEY,
                          @"1",MXR_OS_TYPE_NEW_KEY,
                          [MXRDeviceUtil getDeviceUUID],MXR_LOCAL_DEVICE_ID_KEY,
                          MXRAppID,MXR_APP_ID_KEY,
                          nil];
    NSString *value = [MXRBase64 encodeBase64WithString:[MXRJsonUtil dictionaryToJson:dict]];
    return value;
}

@end
