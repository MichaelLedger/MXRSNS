//
//  MXRDeviceUtil.h
//  huashida_home
//
//  Created by yuchen.li on 17/2/7.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRDeviceUtil : NSObject

/**
 获取客户端版本

 @return
 */
+ (NSString *)getClientVersion;

/**
 获取设备机型 （iphone 7  iphone 6 ...）
 
 @return apple 设备
 */
+ (NSString *)getDeviceModel;

/**
 本地化设备模型

 @return 本地化的模型  iPad   iphone
 */
+ (NSString *)getDeviceLocalizedModel;

/**
 获取系统版本

 @return
 */
+ (NSString *)getSystermVersion;

/**
 获取系统名字

 @return iOS
 */
+ (NSString *)getSystermName;

/**
 联通，移动，电信 等

 @return 运营商信息
 */
+ (NSString *)getOperationType;

/**
 wifi 3g

 @return 网络类型
 */
+ (NSString *)getNetworkType;

/**
 创建唯一的uuid

 @return 返回创建好的string
 */
+ (NSString *)getUUID;

/**
 获取设备的唯一ID

 @return 返回设备的唯一ID
 */
+ (NSString *)getDeviceUUID;

/**
 获取局域网的ip地址172.16.0.216

 @return ip地址
 */
+ (NSString *)getIPAddress;

/**
 获取网络所在的地区名 IP地址 等
 @"country"   国家名
 @"countryId"
 @"area"      大区名（华东 华北 ...）
 @"areaId"
 @"region"    省名
 @"regionId"
 @"city"      市名
 @"cityId"
 @"county"    村名
 @"countyId"
 @"ip"         外网 ip地址
 
 @param callBack 是否成功 和 包含网络和地区的字典
 */
+ (void)getUserLocationIPWithCallBack:(void(^)(NSDictionary *ipDict,BOOL isOk))callBack;


/**
 获取磁盘剩余空间

 @return 返回大小
 */
+(float) getFreeDiskSpaceInBytes;

/**
 获取SDWebImage缓存大小

 @return 缓存大小(Byte)
 */
+ (NSUInteger)getSDImageCacheSize;

/**
 手机系统剩余可用空间大小

 @return 手机系统剩余可用空间大小(单位：MB)
 */
+(float)getFreeDiskspace;


/**
 字节转描述

 @param byteSize 字节大小(单位：Byte)
 @return 相对应的描述
 */
+ (NSString *)translate:(float)byteSize;

/**
 获取当前任务所占用的内存

 @return 获取当前任务所占用的内存（单位：MB）
 */
+ (double)currentTaskUsedMemory;

/**
 是否连接网络

 @return YES连接，NO不连接
 */
+ (BOOL)isReachable;


/**
 当前是否是手机移动运营商网络

 @return YES手机网络，NO不是手机网络
 */
+ (BOOL)isViaWWAN;


/**
 是否是Wi-Fi网络

 @return YES是Wi-Fi网络，NO不是Wi-Fi网络
 */
+ (BOOL)isViaWiFi;
+ (NSString *)getCurrentUserIdAsscationDevice;


/**
 获取设置的语言

 @return 语言
 */
+ (NSString *)currentLocaleLanguage;


/**
 获取当前设备支持的所有语言

 @return 语言数组
 */
+ (NSArray *)availableLocaleLanguages;

@end
