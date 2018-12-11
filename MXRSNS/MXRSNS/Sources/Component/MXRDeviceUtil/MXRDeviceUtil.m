//
//  MXRDeviceUtil.m
//  huashida_home
//
//  Created by yuchen.li on 17/2/7.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRDeviceUtil.h"
#import <sys/utsname.h>
#import <sys/mount.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "KeychainItemWrapper.h"
#import "AFNetworkReachabilityManager.h"
#import "DeviceIdAndUserAssociationManager.h"
//#import "MXRThirdSupportConfigs.h"
#import "MXRNetworkManager.h"
#import <AFNetworking.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import "SDImageCache.h"
#import <AFNetworking/AFNetworking.h>
#import "KeychainItemWrapper.h"
#import "MXRConstant.h"

#define AppVersionStringKey @"CFBundleShortVersionString"

#define KEYCHAIN_IDENTIFIER     @"DianDuShu1.7"     // 钥匙串的key

@implementation MXRDeviceUtil
+(NSString *)getClientVersion{
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:AppVersionStringKey];
}

+(NSString *)getDeviceModel{
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    // 防止参数为空，
    if (!systemInfo.machine) {
        return @"iOS device";
    }
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G old";       // old 表示不支持该设备 过滤掉 4s 以下的设备
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G old";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS old";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 old";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 old";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 old";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G old";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G old";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G old";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G old";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

+ (NSString *)getDeviceLocalizedModel{

    return [[UIDevice currentDevice] localizedModel];
}

+ (NSString *)getSystermVersion{

    return [[UIDevice currentDevice] systemVersion] ;
}

+ (NSString *)getSystermName{
    
    return [[UIDevice currentDevice] systemName];
}
+ (NSString *)getOperationType{
    
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier carrierName];
    currentCountry= currentCountry !=nil? currentCountry:@"未查找到结果";
    return currentCountry;
}

+ (NSString *)getNetworkType{
    
    NSString *netconnType = @"";

    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusNotReachable:// 没有网络
        {
            
            netconnType = @"no network";
        }
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                
                netconnType = @"4G";
            }
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
}

+ (NSString *)getUUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uniqueId = (__bridge_transfer NSString *)uuidStringRef;
    return uniqueId;
}

+ (NSString *)getDeviceUUID
{
    KeychainItemWrapper * keychain = [[KeychainItemWrapper alloc] initWithIdentifier:KEYCHAIN_IDENTIFIER accessGroup:nil];
    NSString * uuid = [keychain objectForKey:(id)CFBridgingRelease(kSecValueData)];
    if ( uuid && ![uuid isEqualToString:@""] )
        return uuid;
    // 生成厂商id
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    if (!identifierStr) {
        //生成一个uuid的方法
       
        identifierStr  = [MXRDeviceUtil getUUID];
        if (!identifierStr) {
            return @"";
        }
    }
    //如果为空 说明是第一次安装 做存储操作
    [keychain setObject:identifierStr forKey:(id)CFBridgingRelease(kSecValueData)];
    
    return identifierStr;
}


+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

static AFHTTPSessionManager *manager;
+ (AFHTTPSessionManager *)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 初始化请求管理类
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        // 设置15秒超时 - 取消请求
        manager.requestSerializer.timeoutInterval = 15.0;
        // 编码
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        // 缓存策略
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 支持内容格式
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    });
    return manager;
    
}

/**
 获取地域信息
 */
+(void)getUserLocationIPWithCallBack:(void (^)(NSDictionary *ipDict,BOOL isOk))callBack{
    // 5.2.9版本修改
    NSString *URLTmp = [NSString stringWithFormat:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    
//    NSString *URLTmp1 = [URLTmp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  //转码成UTF-8  否则可能会出现错误
//    URLTmp = URLTmp1;

    //AFHTTPSessionManager这货用完之后不会释放，需要单例创建，instruments各种红叉，改单例后红叉不见了
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 10;
    
    [[MXRDeviceUtil sharedManager] GET:URLTmp parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSString *strData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSArray *arrayString = [strData componentsSeparatedByString:@"="];
            NSString *jsonString = arrayString.lastObject;
            if ([jsonString hasSuffix:@";"]) {
                jsonString = [jsonString substringToIndex:jsonString.length - 1];
            }
            NSString *newJsonString = jsonString;
            if (!newJsonString) {
                if (callBack) {
                    callBack(nil,NO);
                }
                return ;
            }
            NSData *jsonData = [newJsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];

            if (responseJSON && [responseJSON isKindOfClass:[NSDictionary class]]) {
                NSArray *regionAndCity = [autoString(responseJSON[@"cname"]) componentsSeparatedByString:MXRLocalizedString(@"Province", @"省")];
                NSString *region = regionAndCity.firstObject;
                NSString *city = regionAndCity.lastObject;
                NSString *ipStr = @" ";
                
                if (autoString(responseJSON[@"cip"]).length < 20) {
                    ipStr = autoString(responseJSON[@"cip"]);
                }
                
                NSDictionary *dicIpData = @{
                                            @"country" : autoString(responseJSON[@"country"]),
                                            @"countryId":autoString(responseJSON[@"country_id"]),
                                            @"area":autoString(responseJSON[@"area"]),
                                            @"areaId":autoString(responseJSON[@"area_id"]),
                                            @"region":autoString(region),
                                            @"regionId":autoString(responseJSON[@"region_id"]),
                                            @"city" : autoString(city),
                                            @"cityId":autoString(responseJSON[@"city_id"]),
                                            @"county":autoString(responseJSON[@"county"]),
                                            @"countyId":autoString(responseJSON[@"county_id"]),
                                            @"ip" : ipStr
                                            };
        
                if (callBack) {
                    callBack(dicIpData,YES);
                }
            }else{
                if (callBack) {
                    callBack(nil,NO);
                }
                DLOG(@"数据不规范,地址请求失败");
            }
            
        }else{
            if (callBack) {
                callBack(nil,NO);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callBack) {
            callBack(nil,NO);
        }
        DLOG(@"请求地域信息和IP Error: %@", error);
    }];
    
    
}


///获取当前设备剩余存储空间
+(float) getFreeDiskSpaceInBytes
{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return freespace/1024/1024;
    
}

//手机系统剩余可用空间大小
+(float)getFreeDiskspace {

    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];

    if (dictionary) {
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        
//        DLOG(@"Memory Capacity of %llu GB with %llu GB Free memory available.", ((totalSpace/1024)/1024/1024), ((totalFreeSpace/1024)/1024/1024));
    } else {
        DLOG(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalFreeSpace;
}

+ (NSString *)translate:(float)byteSize {
    NSArray *units = @[@"B", @"KB", @"MB", @"GB", @"TB", @"PB", @"EB", @"ZB", @"YB", @"BB", @"NB", @"DB", @"CB", @"XB"];
    NSInteger round = 0;
    while (byteSize >= 1024 && round < units.count - 1) {
        byteSize = byteSize/1024;
        round ++;
    }
    
    return [NSString stringWithFormat:@"%.2f%@", byteSize, units[round]];
}

+ (NSUInteger)getSDImageCacheSize {
    //获取图片的缓存大小 单位：B
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    return size;
}

// 获取当前任务所占用的内存（单位：MB）
+ (double)currentTaskUsedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024 / 1024;
}

+ (BOOL)isReachable
{
    return  [AFNetworkReachabilityManager sharedManager].reachable;
    
}

+ (BOOL)isViaWWAN{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN;
}

+ (BOOL)isViaWiFi{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}
+ (NSString *)getCurrentUserIdAsscationDevice{
    return [[DeviceIdAndUserAssociationManager sharedInstance] getCurrentUserIdAssicationDeviceId];
}

+ (NSString *)currentLocaleLanguage {
    return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}

+ (NSArray *)availableLocaleLanguages {
    return [NSLocale availableLocaleIdentifiers];
}

@end
